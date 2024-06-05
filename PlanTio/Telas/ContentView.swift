import SwiftUI
import PostHog

struct ContentView: View {
    @State private var navigateToAddPlant = false
    @ObservedObject var viewModel: PlantViewModel
    @State private var showingAddPlant = false
    @State private var navigateToLimitReached = false
    @State private var navigateToMaxLimitReached = false
    @State var searchText = ""
    @State private var selectedPlant: Plant? = nil
    
    var filteredPlants: [Plant] { viewModel.fiteredPlants(by: searchText) }
    
    var body: some View {
        NavigationStack {
            VStack{
                RiveAnimationView(primaryFileName: "hana", secondaryFileName: "sad")
                    .shadow(color: .shadow.opacity(0.3), radius: 5, x: 0, y: 4)
                    .background(Color("Background"))
                
                List {
                    if filteredPlants.isEmpty {
                        noPlants
                    } else {
                        ForEach(filteredPlants) { plant in
                            ZStack{
                                ListPlantCard(content: {}, plantName: plant.name, plantSpecies: plant.type)
                                
                                NavigationLink(value: plant) {
                                    EmptyView()
                                }
                                .opacity(0.0)
                                .contentShape(Rectangle())
                            }
                        }
                        .onDelete(perform: viewModel.removePlant(at:))
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                }
                .padding(.top)
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
                .font(.custom("Quicksand", size: 17, relativeTo: .body))
                .listStyle(.plain)
            }
            .background(Color("Background").ignoresSafeArea())
            .navigationBarTitle("My Plants")
            .navigationBarItems(
                trailing:
                    HStack{
                        Button(action: {
                            // Your upgrade action here
                            
                        }, label: {
                            Text("upgrade")
                                .font(.custom("Quicksand", size: 15, relativeTo: .subheadline))
                                .bold()
                                .foregroundStyle(Color.white)
                                .padding(.vertical, 5)
                                .padding(.horizontal)
                                .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundStyle(Color.pinkButton)
                                    .overlay (alignment: .topLeading) {
                                        Image("Sparkle")
                                            .alignmentGuide(.top, computeValue: { dimension in
                                                dimension[.bottom] - 12})
                                    }
                                    .overlay (alignment: .bottomTrailing) {
                                        Image("SparkleSmall")
                                            .alignmentGuide(.bottom, computeValue: { dimension in
                                                dimension[.top] + 12})
                                    }
                                )
                        })
                        
                        Button(action: {
                            if viewModel.plants.count < viewModel.maxPlantCount {
                                showingAddPlant = true
                            } else if viewModel.maxPlantCount == 5 {
                                navigateToLimitReached = true
                            } else if viewModel.plants.count >= 17 {
                                navigateToMaxLimitReached = true
                            }
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title3)
                                .bold()
                        }
                    }
            )
            .navigationDestination(for: Plant.self) { plant in
                if let index = viewModel.plants.firstIndex(where: { $0.id == plant.id }) {
                    PlantDetailView(
                        viewModel: viewModel,
                        plant: $viewModel.plants[index],
                        saveMode: false
                    )
                }
            }
            .onChange(of: searchText, { oldValue, newValue in
                PostHogSDK.shared.capture("searchUsed")
            })
            .navigationDestination(isPresented: $showingAddPlant) {
                            AddPlantView(viewModel: viewModel)
            }
            .sheet(isPresented: $navigateToLimitReached) {
                LimitReachedView(viewModel: viewModel)
            }
            .sheet(isPresented: $navigateToMaxLimitReached) {
                MaxLimitReachedView()
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
