import SwiftUI

struct LimitReachedView: View {
    @EnvironmentObject var store: Store
    @ObservedObject var viewModel: PlantViewModel
    
    var body: some View {
        ZStack {
            
            LinearGradient(
                stops: [
                    Gradient.Stop(color: .skyGradient1, location: 0),
                    Gradient.Stop(color: .skyGradient2, location: 0.7)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
           
            Image("SunSmall")
                .resizable()
                .scaledToFit()
                .frame(maxWidth:160)
                .padding(.bottom, 690)
                .padding(.leading, 240)
            
            VStack (alignment: .leading, spacing: 50){
                
                VStack (alignment: .leading, spacing: 15){
                    Text("It seems that you've\nreached your garden's limit.")
                        .font(.custom("Quicksand", size: 20, relativeTo: .title3))
                        .foregroundStyle(Color.white)
                        .fontWeight(.medium)
                    
                    Text("Buy slots to keep\nyour garden growing.")
                        .font(.custom("Quicksand", size: 28, relativeTo: .title))
                        .foregroundStyle(Color.white)
                        .bold()
                }
                .padding(.top, 55)
                .padding(.leading, 25)
                
                
                RoundedRectangle(cornerRadius: 20.0)
                    .ignoresSafeArea()
                    .foregroundStyle(
                        LinearGradient(
                            stops: [
                                Gradient.Stop(color: .grassGradient1, location: 0),
                                Gradient.Stop(color: .grassGradient2, location: 1)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                
                    .overlay (alignment: .top){
                        Image("Grass")
                            .alignmentGuide(.top, computeValue: {dimension in dimension[.bottom] - 20})
                        
                    }
                
                    .overlay (alignment: .top) {
                        ScrollView {
                            VStack (spacing: 30) {
                                VStack(alignment: .leading) {
                                    Text("Hana Plus+")
                                        .font(.custom("Quicksand", size: 34, relativeTo: .largeTitle))
                                        .bold()
                                        .foregroundStyle(Color.normalText)
                                        .padding(.bottom, 1)
                                        .colorScheme(.light)
                                    
                                    Text("+12 plant slots")
                                        .font(.custom("Quicksand", size: 22, relativeTo: .title2))
                                        .fontWeight(.medium)
                                        .foregroundStyle(Color.lightGreen)
                                    
                                }
                                .padding(.leading, 30)
                                .padding(.trailing, 150)
                                .padding(.top, 40)
                                .padding(.bottom, 130)
                                .background(
                                    RoundedRectangle(cornerRadius: 36)
                                        .foregroundStyle(Color.cards)
                                        .colorScheme(.light)
                                )
                                .overlay {
                                    Image("HanaPremium")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: 300)
                                        .padding(.top, 100)
                                }
                                
                                Button(action: {
                                    Task {
                                        await purchaseHanaPlus()
                                    }
                                }) {
                                    Text("R$ 4,90")
                                        .font(.custom("Quicksand", size: 28, relativeTo: .title3))
                                        .bold()
                                        .padding(.horizontal, 125)
                                        .padding(.vertical, 20)
                                        .foregroundColor(.white)
                                        .background(
                                            RoundedRectangle(cornerRadius: 30)
                                                .foregroundStyle(Color.pinkButton)
                                                .colorScheme(.light)
                                        )
                                    
                                    
                                }
                                
                                Button(action: {
                                    Task{
                                        await store.restorePurchases()
                                    }
                                    
                                }, label: {
                                    Text("Restore Purchase")
                                        .font(.custom("Quicksand", size: 22, relativeTo: .title2))
                                        .bold()
                                        .underline()
                                        .foregroundStyle(Color.darkGreen)
                                })
                            }
                            .padding(.top, 40)
                            
                            
                            
                            
                        }
                        .scrollBounceBehavior(.basedOnSize)
                        .navigationTitle("Limit Reached")
                        
                    }
            }
        }
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
                viewModel.updateMaxPlantCount(to: 17) // Atualiza o limite para 17 após a compra
            } else {
                print("Purchase failed or cancelled")
            }
        } catch {
            print("Purchase error: \(error)")
        }
    }
}

#Preview {
    LimitReachedView(viewModel: PlantViewModel())
        .environmentObject(Store())
        .environmentObject(PlantViewModel())
}
