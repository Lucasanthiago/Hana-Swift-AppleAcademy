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
//            .navigationBarItems(
//                trailing: NavigationLink(destination: AddPlantView(viewModel: viewModel, plant: Plant(name: "", type: "", wateringTime: Date(), sunTime: Date())), isActive: $showingAddPlant) {
//                }
//            )
            // FIXME: precisa passar a view nova de add e desbilitar após existir alguma planta no card
            
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
    

