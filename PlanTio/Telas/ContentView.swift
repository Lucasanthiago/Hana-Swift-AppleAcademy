import SwiftUI
import PostHog
import RiveRuntime

//struct Host<Content: View>: UIViewControllerRepresentable {
//
//    let contentView: Content
//    @State var vc = UINavigationController()
//    func makeUIViewController(context: Context) -> UIViewController {
//
//      print("oi?")
////        vc =
//        let n = UIHostingController(rootView: contentView)
//        vc.addChild(n)
//        vc.navigationBar.topItem?.title = "oi?!"
//        vc.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.blue]
//        vc.navigationItem.largeTitleDisplayMode = .always
////        vc.title = "oi"
//        vc.navigationBar.prefersLargeTitles = true
////        vc.navigationBar.barTintColor = .green
//        vc.isNavigationBarHidden = false
//        vc.setNavigationBarHidden(false, animated: false)
//        let l = UILabel()
//        l.text = "abcd"
//        l.sizeToFit()
//        vc.navigationBar.barTintColor = .red
//        vc.navigationItem.titleView = l
//        let color = Color.green
//        let size = 24.0
//        let fontName = "Arial"
//        var uiFont: UIFont = UIFont(name: fontName, size: size ) ?? UIFont.systemFont(ofSize: 12)
//        let uiColor = UIColor(color)
//
//        var paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.alignment = .left
//        uiFont = UIFont(descriptor: uiFont.fontDescriptor.withSymbolicTraits(.traitBold)!, size: size)
//
//        UINavigationBar.appearance().titleTextAttributes = [
//            .paragraphStyle: paragraphStyle
//            //            .font: uiFont, .foregroundColor: uiColor
//        ]
//        UINavigationBar.appearance().largeTitleTextAttributes = [.font: uiFont, .foregroundColor: uiColor ]
//        return vc
//    }
//
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
//
//    }
//}
extension View {
    
    func navigationBarTitleTextFont(fontName: String, size: CGFloat, color: Color) -> some View {
        var uiFont: UIFont = UIFont(name: fontName, size: size ) ?? UIFont.systemFont(ofSize: 12)
        let uiColor = UIColor(color)
        
        //        var paragraphStyle = NSMutableParagraphStyle()
        //        paragraphStyle.alignment = .left
        uiFont = UIFont(descriptor: uiFont.fontDescriptor.withSymbolicTraits(.traitBold)!, size: size)
        
        UINavigationBar.appearance().titleTextAttributes = [
            //            .paragraphStyle: paragraphStyle
            .font: uiFont, .foregroundColor: UIColor.clear
        ]
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: uiFont, .foregroundColor: uiColor ]
        ////        UINavigationBar.appearance().prefersLargeTitles = false
        //        let titleLabel = UILabel()
        ////                titleLabel.textColor = color
        //                titleLabel.text = "abcd"
        //                titleLabel.textAlignment = .left
        //                titleLabel.translatesAutoresizingMaskIntoConstraints = false
        //
        //        let top = UIApplication.shared.topViewController()!
        //            top.navigationItem.titleView = titleLabel
        //        let l = UILabel()
        //        l.text = "a"
        //        print(UIApplication.shared.topViewController()!.parent)
        //        UIApplication.shared.topViewController()!.presentedViewController!.navigationController!.navigationBar.barTintColor = .red
        //                guard let containerView = UIApplication.shared.topViewController()!.navigationItem.titleView!.superview else {
        //                    print("a")
        //                    return self }
        //
        //                // NOTE: This always seems to be 0. Huh??
        //                let leftBarItemWidth = UIApplication.shared.topViewController()!.navigationItem.leftBarButtonItems!.reduce(0, { $0 + $1.width })
        //
        //                NSLayoutConstraint.activate([
        //                    titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
        //                    titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        //                    titleLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor,
        //                                                     constant: (leftBarItemWidth ?? 0) + 10),
        //                    titleLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor)
        //                ])
        return self
    }
}

struct ContentView: View {
    
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
            .background(Color.background)
            .navigationBarTitle("My Plants")
            .navigationBarItems(
                trailing:
                    HStack{
                        if !hasUpgraded {
                            UpgradeButton(showingUpgrade: $showingUpgrade)
                        }
                        
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
            .sheet(isPresented: $showingAddPlant) {
                AddPlantView(viewModel: viewModel)
            }
            .sheet(isPresented: $navigateToLimitReached) {
                LimitReachedView(viewModel: viewModel, hasUpgraded: $hasUpgraded)
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
    ContentView(viewModel: PlantViewModel())
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


#Preview {
    UpgradeButton(showingUpgrade: .constant(true))
    //        .scaleEffect(3)
}
//extension UIApplication {
//    func topViewController() -> UIViewController? {
//        var topViewController: UIViewController? = nil
//        if #available(iOS 13, *) {
//            for scene in connectedScenes {
//                if let windowScene = scene as? UIWindowScene {
//                    for window in windowScene.windows {
//                        if window.isKeyWindow {
//                            topViewController = window.rootViewController
//                        }
//                    }
//                }
//            }
//        } else {
//            topViewController = keyWindow?.rootViewController
//        }
//        while true {
//            if let presented = topViewController?.presentedViewController {
//                topViewController = presented
//            } else if let navController = topViewController as? UINavigationController {
//                topViewController = navController.topViewController
//            } else if let tabBarController = topViewController as? UITabBarController {
//                topViewController = tabBarController.selectedViewController
//            } else {
//                // Handle any other third party container in `else if` if required
//                break
//            }
//        }
//        return topViewController
//    }
//}
