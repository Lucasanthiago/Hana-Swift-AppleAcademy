//
//  Store.swift
//  PlanTio
//
//  Created by Kaua Trindade on 03/06/24.
//

import Foundation
import StoreKit

typealias Transaction = StoreKit.Transaction
typealias RenewalInfo = StoreKit.Product.SubscriptionInfo.RenewalInfo
typealias RenewalState = StoreKit.Product.SubscriptionInfo.RenewalState

public enum StoreError: Error {
    case failedVerification
}


class Store: NSObject, ObservableObject  {
    

    @Published private(set) var products: [Product]
    @Published private(set) var nonConsumableProducts: [Product] = []
    @Published private(set) var subscriptionGroupStatus: RenewalState?
    
    var updateListenerTask: Task<Void, Error>? = nil


    override init() {
        //Initialize empty products, and then do a product request asynchronously to fill them in.
        products = []
        
        super.init()
      
        print(Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt")

        //Start a transaction listener as close to app launch as possible so you don't miss any transactions.

        Task {
            //During store initialization, request products from the App Store.
            await requestProducts()

            //Deliver products that the customer purchases.
            await refreshPurchasedProducts()
            updateListenerTask = listenForTransactions()

        }

    }

    deinit {
        updateListenerTask?.cancel()
    }

    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            //Iterate through any transactions that don't come from a direct call to `purchase()`.
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)

                    //Deliver products to the user.
                    await self.refreshPurchasedProducts()

                    //Always finish a transaction.
                    await transaction.finish()
                } catch {
                    //StoreKit has a transaction that fails verification. Don't deliver content to the user.
                    print("Transaction failed verification")
                }
            }
        }
    }

    @MainActor
    func requestProducts() async {
        do {
            let storeProducts = try await Product.products(for: ["hanaplus"])

            var products: [Product] = []
            
            //Filter the products into categories based on their type.
            for product in storeProducts {
                switch product.type {
                case .nonConsumable:
                    products.append(product)
                default:
                    print("Unknown product")
                }
            }

            //Sort each product category by price, lowest to highest, to update the store.
            self.products = sortByPrice(products)
        } catch {
            print("Failed product request from the App Store server: \(error)")
        }
    }

    func purchase(_ product: Product) async throws -> Transaction? {
        //Begin purchasing the `Product` the user selects.
        let result = try await product.purchase()

        switch result {
        case .success(let verification):
                
            switch verification {
                case .unverified(let transaction, let verificationError):
                    return nil
                case .verified(let transaction):
                    await refreshPurchasedProducts()
                    
                    //Always finish a transaction.
                    await transaction.finish()
                    
                    return transaction
            }
            
            //The transaction is verified. Deliver content to the user.
           
        case .userCancelled, .pending:
            return nil
        default:
            return nil
        }
    }

    func isPurchased(_ product: Product) async throws -> Bool {
        //Determine whether the user purchases a given product.
        switch product.type {
        case .nonConsumable:
            return nonConsumableProducts.contains(product)
        default:
            return false
        }
    }

    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        //Check whether the JWS passes StoreKit verification.
        switch result {
        case .unverified:
            //StoreKit parses the JWS, but it fails verification.
            throw StoreError.failedVerification
        case .verified(let safe):
            //The result is verified. Return the unwrapped value.
            return safe
        }
    }
    
    
    @MainActor
    func refreshPurchasedProducts() async {
        var nonConsumables: [Product] = []
        
        //Iterate through all of the user's purchased products.
        for await result in Transaction.currentEntitlements {
            
            switch result {
                case .verified(let transaction):
                    switch transaction.productType {
                    case .nonConsumable:
                        if let coin = products.first(where: { $0.id == transaction.productID }) {
                            nonConsumables.append(coin)
                        }
                    default:
                        break
                    }
                
                case .unverified(let transaction, let error):
                    print(error)
            }
            
        }

        //Update the store information with the purchased products.
        self.nonConsumableProducts = nonConsumables

        //Check the `subscriptionGroupStatus` to learn the auto-renewable subscription state to determine whether the customer
        //is new (never subscribed), active, or inactive (expired subscription). This app has only one subscription
        //group, so products in the subscriptions array all belong to the same group. The statuses that
        //`product.subscription.status` returns apply to the entire subscription group.
//        subscriptionGroupStatus = try? await subscriptions.first?.subscription?.status.first?.state
    }

    func restorePurchases() async {
        do {
            try await AppStore.sync()
            print("Restoration completed ")
            await refreshPurchasedProducts()
            
        }catch{
            print("Failed to restore purchase: \(error)")
        }
        
    }

    func sortByPrice(_ products: [Product]) -> [Product] {
        products.sorted(by: { return $0.price < $1.price })
    }

    func convertCoinId(coinId: String) -> Int{
        let separatedCoin = coinId.split(separator: "coins")
        let coinValue = Int(String(separatedCoin.first ?? "0")) ?? 0
        return coinValue
    }
}
