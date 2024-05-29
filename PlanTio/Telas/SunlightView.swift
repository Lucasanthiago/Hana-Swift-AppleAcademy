import SwiftUI

struct SunlightView: View {
    @ObservedObject var viewModel: PlantViewModel
    @State private var showingAddPlant = false
    @State var searchText = ""
    
    var body: some View {
        NavigationView {
            List {
                if filteredPlants.isEmpty {
                    noPlantsToSunbathe
                } else {
                    sunbathingList
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .font(.custom("Quicksand", size: 17))
            .listStyle(PlainListStyle())
            .background(Color("Background"))
            .navigationBarTitle("Sunbathing")
            .background(
                NavigationLink(destination: AddPlantView(viewModel: viewModel), isActive: $showingAddPlant) {
                    EmptyView()
                }
            )
        }
    }
    
    var filteredPlants: [Plant] {
        if searchText.isEmpty {
            return viewModel.plants
        } else {
            return viewModel.plants.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    @ViewBuilder
    var sunbathingList: some View {
        ForEach(filteredPlants) { plant in
            AlarmView(viewModel: viewModel, plant: plant, type: .sunlight)
        }
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }

    @ViewBuilder
    var noPlantsToSunbathe: some View {
        CustomContentUnavailableView(iconName: "hana.flower.fill",
                                     title: "No Plants Yet",
                                     desciption: "Sunbathing reminders will appear here as you add your plants.",
                                     buttonName: "Add new plant",
                                     action: { showingAddPlant = true })
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
}
