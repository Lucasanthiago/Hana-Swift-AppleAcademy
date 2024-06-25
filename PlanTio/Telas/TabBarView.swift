//
//  TabBarView.swift
//  PlanTio
//
//  Created by Lucas Santos on 29/04/24.
//

import SwiftUI
import VMNotificationHandler

struct TabBarView: View {
    @StateObject var viewModel = PlantViewModel.instance

    var body: some View {
        TabView {
            ContentView(viewModel: viewModel)
                .tabItem {
                    Label("My Plants", image: "hana.flower.fill")
                }
                .toolbarBackground(.ultraThinMaterial, for: .tabBar)
            
            WateringView(viewModel: viewModel)
                .tabItem {
                    Label("Watering", systemImage: "drop.circle.fill")
                }
                .toolbarBackground(.ultraThinMaterial, for: .tabBar)
            
            SunlightView(viewModel: viewModel)
                .tabItem {
                    Label("Sunbathing", systemImage: "sun.horizon.fill")
                }
                .toolbarBackground(.ultraThinMaterial, for: .tabBar)
        }
        .onAppear{
            viewModel.getCommons()
            
        }
        
//        .task{
//            
//            await VMNotificationHandler.shared.requestAuthorization()
//            for plant in viewModel.plants{
//                
//                try! await VMNotificationHandler.shared.scheduleNotification(title: "Hora de regar!", subtitle: "Pedro Gomes está com sede", triggerTime: .after(0.5))
//               
//                try! await
//                    VMNotificationHandler.shared.scheduleNotification(title: "Hora do sol!", subtitle: "Pedro Gomes está precisando de vitamina D!", triggerTime: .after(0.5))
//            }
            
//                    try! await VMNotificationHandler.shared.scheduleNotification(title: "Hora do sol!", subtitle: "Pedro Gomes está precisando de vitamina D!", triggerTime: .now)
//        }
       
    }
}


#Preview {
    TabBarView()
}

