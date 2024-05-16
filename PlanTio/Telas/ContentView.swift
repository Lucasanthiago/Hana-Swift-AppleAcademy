


import SwiftUI

struct ContentView: View {
    @State private var navigateToAddPlant = false

    @ObservedObject var viewModel: PlantViewModel
    @State private var showingAddPlant = false
    @State var searchText = ""
    @State private var selectedPlant: Plant? = nil
    
    var filteredPlants: [Plant] { viewModel.fiteredPlants(by: searchText) }
    
    var body: some View {
        NavigationView {
            List {
                if filteredPlants.isEmpty {
                    noPlants
                } else {
                    ForEach(filteredPlants) { plant in
                        Button(action: {
                            selectedPlant = plant
                        }) {
                            HStack {
                                ListPlantCard(content: {}, plantName: plant.name, plantSpecies: plant.type)
                            }
                        }
                    }
                    .onDelete(perform: viewModel.removePlant(at:))
                }
            }
            .padding(.top)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .listStyle(PlainListStyle())
            .background(Color("Background"))
            .navigationBarTitle("My Plants")
            .navigationBarItems(
                trailing: NavigationLink(destination: AddPlantView(viewModel: viewModel, plant: Plant(name: "", type: "", wateringTime: Date(), sunTime: Date())), isActive: $showingAddPlant) {
                    Image(systemName: "plus")
                }
            )
            .background(
                NavigationLink(destination: selectedPlant.map { PlantDetailView(viewModel: viewModel, plant: $0) }, isActive: Binding(
                    get: { selectedPlant != nil },
                    set: { if !$0 { selectedPlant = nil } }
                )) {
                    EmptyView()
                }
            )
        }
    }
    
    @ViewBuilder
    var noPlants: some View {
        if viewModel.plants.isEmpty {
            CustomContentUnavailableView(iconName: "leaf",
                                         title: "No Plants Yet",
                                         desciption: "Your plants will appear here.",
                                         buttonName: "Add new plant",
                                         action: { showingAddPlant = true })
        } else {
            CustomContentUnavailableView(iconName: "exclamationmark.triangle",
                                         title: "No plants named \"\(searchText)\"",
                                         desciption: "Would you like to add a new plant?",
                                         buttonName: "Add new plant",
                                         action: { showingAddPlant = true })
        }
    }
}

#Preview {
    ContentView(viewModel: PlantViewModel())
}
