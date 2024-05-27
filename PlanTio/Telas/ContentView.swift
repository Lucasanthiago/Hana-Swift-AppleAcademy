


import SwiftUI
import PostHog


struct ContentView: View {
    @State private var navigateToAddPlant = false
    
    @ObservedObject var viewModel: PlantViewModel
    @State private var showingAddPlant = false
    @State var searchText = ""
    @State private var selectedPlant: Plant? = nil
    
    var filteredPlants: [Plant] { viewModel.fiteredPlants(by: searchText) }
    
    var body: some View {
        NavigationStack {
            List {
                if filteredPlants.isEmpty {
                    noPlants
                } else {
                    ForEach(filteredPlants) { plant in
                        ZStack{
                            ListPlantCard(content: {}, plantName: plant.name, plantSpecies: plant.type)
                                
                        NavigationLink(value:  plant) {
                                
                               EmptyView()
                            }
                        .opacity(0.0)
                        .contentShape(Rectangle())
                        }
                        
                        //
                    }
                    //                    }
                    .onDelete(perform: viewModel.removePlant(at:))
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    
                    
                }
            }
            
            .padding(.top)
            .navigationDestination(for: Plant.self) { plant in
                if let index = viewModel.plants.firstIndex(where: { $0.id == plant.id }) {
                    PlantDetailView(
                        viewModel: viewModel,
                        plant: $viewModel.plants[index],
                        saveMode: false
                    )
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always)).font(.custom("Quicksand", size: 17))
            
            .listStyle(.plain)
            .background(Color("Background"))
            .navigationBarTitle("My Plants")
            .navigationBarItems(
                trailing: NavigationLink(destination: AddPlantView(viewModel: viewModel)) {
                    Image(systemName: "plus")
                }
            )
            .navigationDestination(isPresented: $showingAddPlant) {
                
                            AddPlantView(viewModel: viewModel)
                        }
        }
    }
    
    @ViewBuilder
    var noPlants: some View {
        if viewModel.plants.isEmpty {
            CustomContentUnavailableView(iconName: "hana.flower.fill",
                                         title: "No Plants Yet",
                                         desciption: "Your plants will appear here.",
                                         buttonName: "Add new plant",
                                         action: { showingAddPlant = true }
            )
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
        } else {
            CustomContentUnavailableView(iconName: "exclamationmark.triangle",
                                         title: "No plants named \"\(searchText)\"",
                                         desciption: "Would you like to add a new plant?",
                                         buttonName: "Add new plant",
                                         action: { showingAddPlant = true }
            )
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
        }
    }
}

#Preview {
    ContentView(viewModel: PlantViewModel())
}
//            .background(
//                VStack {
//                    EmptyView()
//                    if selectedPlant != nil {
//                        NavigationLink(destination: PlantDetailView(viewModel: viewModel,
//                                                                    plant: Binding<Plant>(self.$selectedPlant)!),
//                                       isActive: Binding<Bool>(
//                                        get: { self.selectedPlant != nil },
//                                        set: { _ in self.selectedPlant = nil }
//                                       )) {
//                                           EmptyView()
//                                       }
//                    }
//                }
//            )
