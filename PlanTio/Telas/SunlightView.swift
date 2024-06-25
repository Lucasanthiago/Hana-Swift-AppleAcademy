import SwiftUI

struct SunlightView: View {
    @EnvironmentObject var store: Store
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
            .font(.custom("Quicksand", size: 17, relativeTo: .body))
            .listStyle(PlainListStyle())
            .background{
                if !store.hasPurchasedHanaPlus {
                    LinearGradient(
                        stops: [
                            Gradient.Stop(color: .background, location: 0)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()

                }
                else{
                    LinearGradient(
                        stops: [
                            Gradient.Stop(color: .hanaPlusGradient1, location: -0.3),
                            Gradient.Stop(color: .hanaPlusGradient2, location: 0.56),
                            Gradient.Stop(color: .hanaPlusGradient3, location: 1.4)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()
                }
            }
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
