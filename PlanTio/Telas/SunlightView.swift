//
//  SunlightView.swift
//  PlanTio
//
//  Created by Lucas Santos on 29/04/24.
//

import SwiftUI

struct SunlightView: View {
    @ObservedObject var viewModel: PlantViewModel
    @State private var showingAddPlant = false
    @State var searchText = ""
    
    var body: some View {
        
        NavigationView{
            
            List {
                if viewModel.plants.isEmpty { noPlantsToSunbathe }
                else { sunbathingList }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .listStyle(PlainListStyle())
            .background(Color("Background"))
            .navigationBarTitle("Sunbathing")
            
        }
        .sheet(isPresented: $showingAddPlant) {
            AddPlantView(viewModel: viewModel,plant: Plant(name: "aaaa", type: "cacto", wateringTime: Date(), sunTime: Date()))
        }
        
    }
    
    @ViewBuilder
    var sunbathingList: some View {
        ForEach(viewModel.plants) { plant in
            //                            Section(header: Text(plant.name)) {
            AlarmView(plant: plant, type: .sunlight)
            
        }
    }

        @ViewBuilder
        var noPlantsToSunbathe: some View {
            CustomContentUnavailableView(iconName: "leaf",
                                         title: "No Plants Yet",
                                         desciption: "Sunbathing reminders will appear here as you add your plants.",
                                         buttonName: "Add new plant",
                                         action: {showingAddPlant = true})
        }

    
}
    

