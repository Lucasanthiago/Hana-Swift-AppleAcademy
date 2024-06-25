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
    @State  var showPrimaryAnimation = true
    @State private var tapCount = 0
    let openingViewModel: RiveViewModel

    init(primaryFileName: String, secondaryFileName: String, openingViewModel: RiveViewModel, currentDayPeriod: DayPeriod? = nil) {
       
        self.openingViewModel = openingViewModel
        let currentHour = Calendar.current.component(.hour, from: .now)
        var currentCalculatedPeriod = DayPeriod.night
        for relevantHour in relevantHours {
            if relevantHour.hour <= currentHour {
                currentCalculatedPeriod = relevantHour.dayPeriod
            }
        }
        let primary = primaryFileName + (currentDayPeriod ?? currentCalculatedPeriod).rawValue
        let secondary = secondaryFileName + (currentDayPeriod ?? currentCalculatedPeriod).rawValue
//        print(primary, secondary)
        _riveViewModel = StateObject(wrappedValue: RiveViewModel(fileName: primary))
        _secondaryRiveViewModel = StateObject(wrappedValue: RiveViewModel(fileName: secondary))
    }

    let relevantHours: [(dayPeriod: DayPeriod, hour: Int)] = [
        (.morning, 5),
        (.afternoon, 11),
        (.evening, 17),
        (.night, 19)
    ]

    enum DayPeriod: String {
        case morning = "Morning"
        case afternoon = "Afternoon"
        case evening = "Evening"
        case night = "Night"
    }

    var body: some View {
        VStack {
               // Seu código existente para a nova animação "opening"
               if !showPrimaryAnimation {
                   RiveViewContainer(viewModel: openingViewModel)
                       .frame(width: 100, height: 100)
                       .opacity(showPrimaryAnimation ? 0 : 1)
               }

               // Seus códigos existentes...
               RiveViewContainer(viewModel: showPrimaryAnimation ? riveViewModel : secondaryRiveViewModel)
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
//                
           }
       }
    private func setupRive() {
        riveViewModel.setInput("hover", value: false)
        riveViewModel.setInput("reset", value: false)
    }

    private func handlePrimaryAnimationTap() {
        tapCount += 1
        print("Tap count: \(tapCount)")
        riveViewModel.triggerInput("click")
        if tapCount == 3 {
            tapCount = 0 // Reset tap count after third click
        }
    }

    private func handleLongPress(isPressing: Bool) {
        if isPressing {
            withAnimation(.easeInOut(duration: 3.5)) {
                showPrimaryAnimation = false
            }
        } else {
            // Adjust the delay before returning to the primary animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
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

#Preview {
    VStack {
        let openingViewModel = RiveViewModel(fileName: "Opening")
        RiveAnimationView(primaryFileName: "Mix_", secondaryFileName: "Sadly_", openingViewModel: openingViewModel, currentDayPeriod: .morning)
        RiveAnimationView(primaryFileName: "Mix_", secondaryFileName: "Sadly_", openingViewModel: openingViewModel, currentDayPeriod: .afternoon)
        RiveAnimationView(primaryFileName: "Mix_", secondaryFileName: "Sadly_", openingViewModel: openingViewModel, currentDayPeriod: .evening)
        RiveAnimationView(primaryFileName: "Mix_", secondaryFileName: "Sadly_", openingViewModel: openingViewModel, currentDayPeriod: .night)
    }
}
