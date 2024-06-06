//
//  SplashArt.swift
//  PlanTio
//
//  Created by izabour Azevedo on 05/06/24.
//

import SwiftUI
import RiveRuntime

struct SplashArtView: View {
    @StateObject private var openingViewModel: RiveViewModel = RiveViewModel(fileName: "Opening")
    @State private var isAnimationFinished = false
    
    @Environment(\.colorScheme) var colorScheme
    func backgroundGradient() -> LinearGradient {
        if colorScheme == .dark {
            return LinearGradient(
                gradient: Gradient(colors: [Color.backgroundGradient, Color.backgroundGradientEndpoint]),
                startPoint: .top,
                endPoint: .bottom
            )
        } else {
            return LinearGradient(
                gradient: Gradient(colors: [Color.backgroundGradient, Color.backgroundGradientEndpoint]),
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
    
    var body: some View {
        ZStack {
            // Gradiente de fundo
            Rectangle()
                .fill(backgroundGradient())
                .edgesIgnoringSafeArea(.all)
            
            // Container da animação
            VStack {
                // Animação
                RiveViewContainer(viewModel: openingViewModel)
                    .frame(width: 300, height: 300)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(isAnimationFinished ? 0 : 1)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                            withAnimation {
                                isAnimationFinished = true
                            }
                        }
                    }
                Text("hana")
                               .font(.custom("Quicksand", size: 70, relativeTo: .title))
                               .fontWeight(.medium)
                               .foregroundColor(.fontColorLogo)
                               .padding(-30)
                               .opacity(isAnimationFinished ? 0 : 1)
                
                // Texto abaixo da animação
                if isAnimationFinished {
                    RiveViewContainer(viewModel: openingViewModel)
                        .padding(.top, 20)
                        .transition(.move(edge: .bottom)) // Adicionando efeito de transição
                        .opacity(isAnimationFinished ? 0 : 1) // Animação de opacidade
                }
            }
        }
    }
    
    struct SplashArtView_Previews: PreviewProvider {
        static var previews: some View {
            SplashArtView()
        }
        
    }
    
}
