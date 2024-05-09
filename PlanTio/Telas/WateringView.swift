//
//  WateringView.swift
//  PlanTio
//
//  Created by Lucas Santos on 29/04/24.
//

import SwiftUI

struct WateringView: View {
    @ObservedObject var viewModel: PlantViewModel
    @State private var showingAddPlant = false
    @State var searchText = ""
    
    var body: some View {
        
        NavigationView{
            
            List {
                if viewModel.plants.isEmpty { noPlantsToWater }
                else { wateringList }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .listStyle(PlainListStyle())
            .background(Color("Background"))
            .navigationBarTitle("Watering")
            
        }
        .sheet(isPresented: $showingAddPlant) {
            AddPlantView(viewModel: viewModel,plant: Plant(name: "aaaa", type: "cacto", wateringTime: Date(), sunTime: Date()))
        }
        
    }
    
    @ViewBuilder
    var wateringList: some View {
        ForEach(viewModel.plants) { plant in
            AlarmView(plant: plant, type: .watering)
            
        }
    }

    @ViewBuilder
    var noPlantsToWater: some View {
        CustomContentUnavailableView(iconName: "leaf",
                                        title: "No Plants Yet",
                                        desciption: "Watering reminders will appear here as you add your plants.",
                                        buttonName: "Add new plant",
                                        action: {showingAddPlant = true})
        }

    
}
    




