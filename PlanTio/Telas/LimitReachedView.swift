//
//  LimitReachedView.swift
//  PlanTio
//
//  Created by Kaua Trindade on 04/06/24.
//

import SwiftUI

struct LimitReachedView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var viewModel: PlantViewModel

    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color("Cards"))
                        .frame(width: 400, height: 300)
                        .cornerRadius(10)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Hana Plus+")
                                .font(.custom("Quicksand", size: 25))
                                .bold()
                                .padding(.bottom, 15)
                            
                            Text("You have reached your limit.")
                                .font(.custom("Quicksand", size: 15))
                                .padding(.bottom, 5)
                            Text("You will add 12 plants.")
                                .font(.custom("Quicksand", size: 15))
                                .padding(.bottom, 2)
                    
                        }
                        .padding()
                        Spacer()
                        
                        Image("HanaPremium")
                            .resizable()
                            .scaledToFit()
                            
                    }
                    .frame(width: 380)
                }
                
                // Adicionando o botão abaixo do ZStack
                Button(action: {
                    Task {
                        await purchaseHanaPlus()
                    }
                }) {
                    Text("Upgrade Now")
                        .font(.custom("Quicksand", size: 20))
                        .bold()
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.top, 20)
                }
            }
            .navigationTitle("Limit Reached")
        }
        .background(Color("Background").ignoresSafeArea())
    }
    
    private func purchaseHanaPlus() async {
        guard let product = store.products.first(where: { $0.id == "hanaplus" }) else {
            print("Product not found")
            return
        }
        
        do {
            let transaction = try await store.purchase(product)
            if let transaction = transaction {
                print("Purchased successfully: \(transaction)")
                viewModel.updateMaxPlantCount(to: 17) // Atualiza o limite para 22 após a compra
            } else {
                print("Purchase failed or cancelled")
            }
        } catch {
            print("Purchase error: \(error)")
        }
    }
}

#Preview {
    LimitReachedView()
        .environmentObject(Store())
        .environmentObject(PlantViewModel())
}
