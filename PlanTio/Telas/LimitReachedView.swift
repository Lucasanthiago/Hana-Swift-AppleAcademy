import SwiftUI

struct LimitReachedView: View {
    @EnvironmentObject var store: Store
    @ObservedObject var viewModel: PlantViewModel

    var body: some View {
        ZStack {
            
            LinearGradient(
                stops: [
                    Gradient.Stop(color: .afternoonSkyGradient1, location: 0),
                    Gradient.Stop(color: .afternoonSkyGradient2, location: 0.7)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            Image("SunClouds")
                .resizable()
                .scaledToFit()
                .frame(width:110)
                .padding(.bottom, 670)
                .padding(.leading, 200)
            
            
            RoundedRectangle(cornerRadius: 20.0)
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
                .padding(.top, 280)
                .ignoresSafeArea()
            
            VStack {
                ZStack {
                    VStack(alignment: .leading, spacing: 100){
                        
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
                        .padding(.leading, 10)
                        
                        
                        VStack(alignment: .leading) {
                            Text("Hana Plus+")
                                .font(.custom("Quicksand", size: 34, relativeTo: .largeTitle))
                                .bold()
                                .padding(.bottom, 1)
                            
                            Text("+12 plant slots")
                                .font(.custom("Quicksand", size: 22, relativeTo: .title2))
                                .fontWeight(.medium)
                                .foregroundStyle(Color.lightGreen)
                            
                            Text("R$ 4,90")
                                .font(.custom("Quicksand", size: 28, relativeTo: .title))
                                .bold()
                                .foregroundStyle(Color.white)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 25)
                                .background(
                                    RoundedRectangle(cornerRadius: 25.0)
                                        .foregroundStyle(Color.pinkButton)
                                )
                                .padding(.top, 20)
                            
                        }
                        .padding(.leading, 30)
                        .padding(.trailing, 150)
                        .padding(.top, 40)
                        .padding(.bottom, 130)
                        .background(
                            RoundedRectangle(cornerRadius: 36)
                                .foregroundStyle(Color.cards)
                        )
                        
                    }
                    Image("HanaPremium")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 300)
                        .padding(.top, 150)

                }
                
                // Adicionando o botão abaixo do ZStack
                Button(action: {
                    Task {
                        await purchaseHanaPlus()
                    }
                }) {
                    Text("Upgrade Now")
                        .font(.custom("Quicksand", size: 22, relativeTo: .title3))
                        .bold()
                        .padding(.horizontal, 100)
                        .padding(.vertical, 20)
                        .foregroundColor(.white)
                        .background(
                        RoundedRectangle(cornerRadius: 30)
                            .foregroundStyle(Color.accentColor)
                        )
                        
                }
            }
            .navigationTitle("Limit Reached")
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
