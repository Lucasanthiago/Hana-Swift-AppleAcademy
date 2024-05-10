//
//  ContentView.swift
//  PlanTio
//
//  Created by Lucas Santos on 29/04/24.
//

import SwiftUI



struct ContentView: View {
    @State private var navigateToAddPlant = false

    @ObservedObject var viewModel: PlantViewModel
    @State private var showingAddPlant = false
    @State var searchText = ""
    var filteredPlants:[Plant] {viewModel.fiteredPlants(by: searchText)}
    
    
    
    var body: some View {
        NavigationView {
            List {
                if filteredPlants.isEmpty { noPlants }
                else { plantList }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .listStyle(PlainListStyle())
            .background(Color("Background"))
            .navigationBarTitle("My Plants")
            .navigationBarItems(
                trailing: NavigationLink(destination: AddPlantView(viewModel: viewModel, plant: Plant(name: "", type: "", wateringTime: Date(), sunTime: Date())), isActive: $showingAddPlant) {
                    Image(systemName: "plus")
                }
            )
        }
    }
    

    @ViewBuilder
    var plantList: some View {
        ForEach(filteredPlants) { plant in
            NavigationLink(destination: PlantDetailView(viewModel: viewModel, plant: plant)) {
                
                HStack{
                    VStack(alignment: .leading) {
                        Text(plant.name).font(.title3).bold()
                        Text(plant.type)
                        
                    }
                    .padding(.top)
                    .padding(.bottom)
                    
                    Spacer()
                    
                    HStack(spacing: 10){
                        Image(systemName: "drop.circle.fill")
                            .foregroundStyle(Color.cyan)
                            .font(.title)
                        
                        Image(systemName: "sun.max.fill")
                            .foregroundStyle(Color.orange)
                            .font(.title)
                    }
                }
            }
        }
        .onDelete(perform: viewModel.removePlant(at:))
    }
    
    @ViewBuilder
    var noPlants: some View {
        
      

        if viewModel.plants.isEmpty {
            CustomContentUnavailableView(iconName: "leaf",
                                         title: "No Plants Yet",
                                         desciption: "Your plants will appear here.",
                                         buttonName: "Add new plant",
                                         action: {showingAddPlant = true})
            
        } else {
            CustomContentUnavailableView(iconName: "exclamationmark.triangle",
                                         title: "No plants named \"\(searchText)\"",
                                         desciption: "Would you like to add a new plant?",
                                         buttonName: "Add new plant",
                                         action: {showingAddPlant = true})
        }
    }

    
}


//    @ViewBuilder
//    var noPlants: some View {
//        ContentUnavailableView {
//            ContentUnavailableView("No Plants Yet", systemImage: "leaf")
//        } description: {
//            Text("Your plants will appear here.")
//        } actions: {
//            Button  {
//                showingAddPlant = true
//            } label: {
//                Text("Add new plant")
//                    .foregroundStyle(Color.accentColor)
//            }
//
//        }
//    }


#Preview {
    ContentView(viewModel: PlantViewModel())
}


