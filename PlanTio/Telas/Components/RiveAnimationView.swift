//
//  RiveAnimationView.swift
//  PlanTio
//
//  Created by izabour Azevedo on 28/05/24.
//

import SwiftUI
import RiveRuntime

struct RiveAnimationView: View {
    @StateObject private var riveViewModel: RiveViewModel
    @StateObject private var secondaryRiveViewModel: RiveViewModel
    @State private var showPrimaryAnimation = true
    @State private var tapCount = 0

    init(primaryFileName: String, secondaryFileName: String) {
        _riveViewModel = StateObject(wrappedValue: RiveViewModel(fileName: primaryFileName))
        _secondaryRiveViewModel = StateObject(wrappedValue: RiveViewModel(fileName: secondaryFileName))
    }

    var body: some View {
        VStack {
            if showPrimaryAnimation {
                RiveViewContainer(viewModel: riveViewModel)
                    .frame(width: 360, height: 136)
                    .onAppear {
                        setupRive()
                    }
                    .gesture(
                        TapGesture()
                            .onEnded {
                                handlePrimaryAnimationTap()
                            }
                    )
                    .gesture(
                        LongPressGesture(minimumDuration: 1.0)
                            .onChanged { _ in
                                handleLongPress(isPressing: true)
                            }
                            .onEnded { _ in
                                handleLongPress(isPressing: false)
                            }
                    )
            } else {
                RiveViewContainer(viewModel: secondaryRiveViewModel)
                    .frame(width: 360, height: 136)
                    .gesture(
                        LongPressGesture(minimumDuration: 1.0)
                            .onEnded { _ in
                                withAnimation(.easeInOut(duration: 2.0)) {
                                    resetPrimaryAnimation()
                                    showPrimaryAnimation = true
                                }
                            }
                    )
            }
        }
        
    }

    private func setupRive() {
        riveViewModel.setInput("hover", value: false)
        riveViewModel.setInput("reset", value: false)
    }

    private func handlePrimaryAnimationTap() {
        tapCount += 1
        riveViewModel.triggerInput("click")
        if tapCount == 3 {
            tapCount = 0 // Reset tap count after third click
        }
    }

    private func handleLongPress(isPressing: Bool) {
        if isPressing {
            withAnimation(.easeInOut(duration: 1.5)) {
                showPrimaryAnimation = false
            }
        } else {
            // Adjust the delay before returning to the primary animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation(.easeInOut(duration: 2.0)) {
                    resetPrimaryAnimation()
                    showPrimaryAnimation = true
                }
            }
        }
    }

    private func resetPrimaryAnimation() {
        // Parar a animação primária e reiniciá-la para evitar o "bug de fantasma"
        riveViewModel.stop()
        riveViewModel.play()
    }
}

struct RiveViewContainer: UIViewRepresentable {
    var viewModel: RiveViewModel
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let riveView = RiveView()
        riveView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(riveView)
        
        NSLayoutConstraint.activate([
            riveView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            riveView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            riveView.topAnchor.constraint(equalTo: view.topAnchor),
            riveView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Carregar e configurar a animação
        viewModel.setView(riveView)
        viewModel.play()
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}
