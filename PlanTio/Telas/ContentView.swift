//
//  ContentView.swift
//  PlanTio
//
//  Created by Lucas Santos on 29/04/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: PlantViewModel
    @State private var showingAddPlant = false  // No longer needed if using direct navigation

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.plants) { plant in
                    NavigationLink(destination: PlantDetailView(viewModel: viewModel, plant: plant)) {
                        VStack(alignment: .leading) {
                            Text(plant.name).font(.headline)
                            Text(plant.type)
                        }
                    }
                }
                .onDelete(perform: viewModel.removePlant(at:))
            }
            .navigationBarTitle("Plantas")
            .navigationBarItems(
                trailing: NavigationLink(destination: AddPlantView(viewModel: viewModel, plant: Plant(name: "", type: "", wateringTime: Date(), sunTime: Date()))) {
                    Image(systemName: "plus")
                }
            )
        }
    }
}


#Preview {
    ContentView(viewModel: PlantViewModel())
}


