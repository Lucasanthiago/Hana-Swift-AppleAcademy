import SwiftUI
import PostHog
import RiveRuntime


struct ContentView: View {
    @EnvironmentObject var store: Store
    @State private var navigateToAddPlant = false
    @ObservedObject var viewModel: PlantViewModel
    @State private var showingAddPlant = false
    @State private var navigateToLimitReached = false
    @State private var navigateToMaxLimitReached = false
    @State var searchText = ""
    @State private var selectedPlant: Plant? = nil
    @State private var showingUpgrade = false
    @State private var hasUpgraded = false
    
    var filteredPlants: [Plant] { viewModel.fiteredPlants(by: searchText) }
    
    var body: some View {
        
        NavigationStack {
            List {
                TimelineView(.everyMinute) { _ in
                    let openingViewModel = RiveViewModel(fileName: "Opening")
                    RiveAnimationView(primaryFileName: "Mix_", secondaryFileName: "Sadly_", openingViewModel: openingViewModel)
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                
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
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic))
            .font(.custom("Quicksand", size: 17, relativeTo: .body))
            .listStyle(.plain)
            .navigationBarTitleTextFont(fontName: "Quicksand", size: 34, color: .titleText)
            .background(
                Color.background            )
            .navigationBarTitle("My Plants")
            .navigationBarItems(
                trailing:
                    HStack{
                        if viewModel.maxPlantCount == viewModel.globalDefaultPlantCount {
                            if !hasUpgraded {
                                UpgradeButton(showingUpgrade: $showingUpgrade)
                            }
                            else {
                                
                            }
                            
                        }
                        
                        Button(action: {
                            print("globalStore.hasPurchasedHanaPlus:", store.hasPurchasedHanaPlus)
                            
                            if viewModel.maxPlantCountNotReached { // Se não atigi limite, tudo bem
                                showingAddPlant = true
                            } else {
                                if store.hasPurchasedHanaPlus { // se já comprei, o limite geral foi atingido
                                    navigateToMaxLimitReached = true
                                } else { // Se não compre, compra
                                    navigateToLimitReached = true
                                }
                                
                                
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
            .sheet(isPresented: $showingAddPlant) {
                AddPlantView(viewModel: viewModel)
            }
            .sheet(isPresented: $navigateToLimitReached) {
                LimitReachedView(viewModel: viewModel)
            }
            .sheet(isPresented: $navigateToMaxLimitReached) {
                MaxLimitReachedView()
            }
            .sheet(isPresented: $showingUpgrade) {
                UpgradeView(viewModel: viewModel, hasUpgraded: $hasUpgraded)
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
    //    Host(contentView:
    ContentView(viewModel: PlantViewModel.instance)
    //    )
        .ignoresSafeArea()
}


struct UpgradeButton: View {

    @Binding var showingUpgrade: Bool
    @State private var appeared = false
    var body: some View {
        Button(action: {
            showingUpgrade = true
        }, label: {
            Text("upgrade")
                .font(.custom("Quicksand", size: 15, relativeTo: .subheadline))
                .bold()
                .foregroundStyle(Color.white)
                .padding(.top, 3.5)
                .padding(.bottom, 5)
                .padding(.horizontal)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(Color.pinkButton)
                        .overlay (alignment: .topLeading) {
                            Image("Sparkle")
                                .alignmentGuide(.top, computeValue: { dimension in
                                    dimension[.bottom] - 12})
                                .scaleEffect(appeared ? 1 : 0)
                                .animation(
                                    .default.delay(0.1).delay(1).repeatForever(),
                                    value: appeared
                                )
                        }
                        .overlay (alignment: .bottomTrailing) {
                            Image("SparkleSmall")
                                .alignmentGuide(.bottom, computeValue: { dimension in
                                    dimension[.top] + 12 })
                                .scaleEffect(appeared ? 1 : 0, anchor: .leading)
                                .animation(
                                    .default.delay(1).repeatForever(),
                                    value: appeared
                                )
                        }
                )
        })
        .onAppear {
            appeared = true
        }
    }
}


extension View {
    
    func navigationBarTitleTextFont(fontName: String, size: CGFloat, color: Color) -> some View {
        var uiFont: UIFont = UIFont(name: fontName, size: size ) ?? UIFont.systemFont(ofSize: 12)
        let uiColor = UIColor(color)
        uiFont = UIFont(descriptor: uiFont.fontDescriptor.withSymbolicTraits(.traitBold)!, size: size)
        
        UINavigationBar.appearance().titleTextAttributes = [
            .font: uiFont, .foregroundColor: UIColor.clear
        ]
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: uiFont, .foregroundColor: uiColor ]
        return self
    }
}



#Preview {
    UpgradeButton(showingUpgrade: .constant(true))
}

