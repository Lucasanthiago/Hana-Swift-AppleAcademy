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
                .font(.custom("Quicksand", size: 17))
                .listStyle(.plain)
            }
            .background(Color("Background").ignoresSafeArea())
            .navigationBarTitle("My Plants")
            .navigationBarItems(
                trailing: Button(action: {
                    if viewModel.plants.count < viewModel.maxPlantCount {
                        showingAddPlant = true
                    } else if viewModel.maxPlantCount == 5 {
                        navigateToLimitReached = true
                    } else if viewModel.plants.count >= 17 {
                        navigateToMaxLimitReached = true
                    }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .bold()
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
            .navigationDestination(isPresented: $navigateToLimitReached) {
                LimitReachedView(viewModel: viewModel)
            }
            .navigationDestination(isPresented: $navigateToMaxLimitReached) {
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




struct MaxLimitReachedView: View {
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color("Cards"))
                        .frame(width: 400, height: 300)
                        .cornerRadius(10)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Maximum Limit Reached")
                                .font(.custom("Quicksand", size: 25))
                                .bold()
                                .padding(.bottom, 15)
                            
                            Text("You have reached the maximum limit of 17 plants.")
                                .font(.custom("Quicksand", size: 15))
                                .padding(.bottom, 5)
                            Text("Consider removing some plants to add new ones.")
                                .font(.custom("Quicksand", size: 15))
                                .padding(.bottom, 2)
                        }
                        .padding()
                        Spacer()
                        
                        Image(systemName: "exclamationmark.triangle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.yellow)
                    }
                    .frame(width: 380)
                }
            }
            .navigationTitle("Limit Reached")
        }
        .background(Color("Background").ignoresSafeArea())
    }
}

#Preview {
    MaxLimitReachedView()
}
