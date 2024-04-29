//
//  TabBarView.swift
//  PlanTio
//
//  Created by Lucas Santos on 29/04/24.
//

import SwiftUI

struct TabBarView: View {
    @StateObject var viewModel = PlantViewModel()

    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("Plantas", systemImage: "leaf")
                }
            
            WateringView(viewModel: viewModel)
                .tabItem {
                    Label("Watering", systemImage: "drop.circle.fill")
                }
            
            SunlightView(viewModel: viewModel)
                .tabItem {
                    Label("Sunligth", systemImage: "sun.max.fill")
                }
        }
    }
}


#Preview {
    TabBarView()
}

