//
//  AnimationView.swift
//  PlanTio
//
//  Created by izabour Azevedo on 27/05/24.
//

import SwiftUI
import RiveRuntime

struct AnimationView: View {
    @StateObject private var riveViewModel = RiveViewModel(fileName: "hana")
    @State private var tapCount = 0

    var body: some View {
        VStack {
            riveViewModel.view()
                .frame(width: 360, height: 136)
                .onAppear {
                    setupRive()
                }
                .gesture(
                    TapGesture(count: 1)
                        .onEnded {
                            handleClick()
                        }
                )
        }
    }

    private func setupRive() {
        riveViewModel.setInput("hover", value: false)
        riveViewModel.setInput("reset", value: false)
    }

    private func handleClick() {
        tapCount += 1
        riveViewModel.triggerInput("click")
        if tapCount == 3 {
            tapCount = 0 // Reset tap count after third click
        }
    }


    private func setReset() {
        riveViewModel.setInput("reset", value: true)
    }

    private func setHover() {
        riveViewModel.setInput("hover", value: true)
    }
}

// Pré-visualização no Xcode
struct AnimationView_Previews: PreviewProvider {
    static var previews: some View {
        AnimationView()
    }
}
