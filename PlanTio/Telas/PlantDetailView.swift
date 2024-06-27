import SwiftUI
import PhotosUI
import PostHog

struct PlantDetailView: View {
    @EnvironmentObject var store: Store
    @ObservedObject var viewModel: PlantViewModel
    @State var isEditing = false
    @Binding var plant: Plant
    @State var saveMode: Bool
    @State private var customType: String = ""
    var onSave: (() -> Void)? // Callback for save action
    
    var body: some View {
        ScrollView{
            VStack {
                FrameImage(imageData: $plant.imageData, plantType: $plant.type, aspectRatio: 10)
                    .disabled(isEditing == false)
                    .frame(width: 393, height: 293)
                
                
                
                TextField("Nickame", text: $plant.name)
                    .font(.custom("Quicksand", size: 17, relativeTo: .body))
                    .fontWeight(.medium)
                    .padding(.leading)
                    .padding(.top)
                    .disabled(isEditing == false)
                
                
                TextField("Species", text: $plant.type)
                    .font(.custom("Quicksand", size: 28, relativeTo: .title))
                    .bold()
                    .padding(.leading)
                    .disabled(isEditing == false)
                
                
                
                VStack {
                    if plant.descriptionPlant.isEmpty {
                        Text(plant.descriptionPlant)
                    } else {
                        Text("Hana Plant Care highlights the value of detailed descriptions for proper care and healthy growth.")
                    }
                }
                
            }
            ScrollView(.horizontal){
                HStack(spacing: 20) {
                    Instructions(
                        contentText: {
                            if plant.wateringDescription.isEmpty {
                                return plant.wateringDescription
                            } else {
                                return ""
                            }
                        }(),
                        title: "Watering",
                        icon: "drop.circle.fill", iconColor: .water
                    )
                    .disabled(isEditing == false)
                    
                    Instructions(
                        contentText: {
                            if plant.sunbathingDescription.isEmpty {
                                return plant.sunbathingDescription
                            } else {
                                return ""
                            }
                        }(),
                        title: "Sunbathing",
                        icon: "sun.max.fill", iconColor: .sun
                    )
                    .disabled(isEditing == false)
                    
                Instructions(
                        contentText: {
                            if plant.poisonDescription.isEmpty {
                                return plant.bestSoilDescription
                            } else {
                                return ""
                            }
                        }(),
                        title: "Best soil",
                        icon: "leaf.circle.fill", iconColor: .soil
                    )
                    .disabled(isEditing == false)
                    
                    Instructions(
                        contentText: {
                            if plant.safeForPetDescription.isEmpty {
                                return plant.safeForPetDescription
                            } else {
                                return ""
                            }
                        }(),
                        title: "Safe for Pets",
                        icon: "pawprint.circle.fill", iconColor: .pinkButton
                    )
                    .disabled(isEditing == false)
                }
                .padding(.init(top: 20, leading: 10, bottom: 20, trailing: 0))
            }
            .scrollIndicators(.hidden)
            
            ScrollView(.horizontal){
                HStack(spacing: 20) {
                    AdditionalCards(
                        contentText: {
                            if plant.weatherDescription.isEmpty {
                                return plant.weatherDescription
                            } else {
                                return ""
                            }
                        }(),
                        title: "Weather",
                        icon: "Weather"
                    )
                    .disabled(isEditing == false)
                    
                    AdditionalCards(
                        contentText: {
                            if plant.potSizeDescription.isEmpty {
                                return plant.potSizeDescription
                            } else {
                                return ""
                            }
                        }(),
                        title: "Pot Size",
                        icon: "PotSize"
                    )
                    .disabled(isEditing == false)
                    
                    AdditionalCards(
                        contentText: {
                            if plant.poisonDescription.isEmpty {
                                return plant.poisonDescription
                            } else {
                                return ""
                            }
                        }(),
                        title: "Poison",
                        icon: "Poison"
                    )
                    .disabled(isEditing == false)
                }
                .padding(.init(top: 20, leading: 10, bottom: 20, trailing: 0))
            }
            .scrollIndicators(.hidden)

        }
        .background {
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
        .ignoresSafeArea()
        .overlay (alignment: .bottomTrailing){
            if saveMode == false {
                Button(action: {
                    isEditing.toggle()
                }) {
                    Image(isEditing ? "Done" : "Edit")
                        .shadow(color: .shadow.opacity(0.3), radius: 5, x: 0, y: 4)
                        .padding(.trailing, 20)
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .safeAreaInset(edge: .bottom, content: {
            if saveMode == true {
                Button(action: {
                    PostHogSDK.shared.capture("Newplant")
                    saveMode = false
                    onSave?()
                    isEditing = false
//                    randomInfos()
                    addPlant()
                }, label: {
                    Text("Save")
                        .font(.custom("Quicksand", size: 17, relativeTo: .body))
                        .bold()
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity, maxHeight: 56)
                        .background(Color("PinkButton"))
                        .cornerRadius(13)
                        .padding(.horizontal)
                })
            }
        })
        .onAppear {
            if plant.type.starts(with: "Other:") {
                customType = String(plant.type.dropFirst(7))
            }
        }
        .onChange(of: plant.type) { newValue in
            if newValue.starts(with: "Other:") {
                customType = String(newValue.dropFirst(7))
            } else {
                customType = ""
            }
        }
    }
    
    
//    func randomInfos() {
//        let wateringInstructionsOptions = [
//            "Keep moist between watering.\nMust not be dry between watering",
//            "Water only when the soil is dry.\nMust be dry between watering",
//            "Water when soil is half dry.\nChange water in the vase regularly."
//        ]
//        
//        let idealLightOptions = [
//            "Bright light",
//            "6 or more hours of direct sunlight per day"
//        ]
//        
//        let toleratedLightOptions = [
//            "Diffused",
//            "Direct sunlight",
//        ]
//        
//        plant.wateringInstructions = wateringInstructionsOptions.randomElement() ?? ""
//        plant.idealLight = idealLightOptions.randomElement() ?? ""
//        plant.toleratedLight = toleratedLightOptions.randomElement() ?? ""
//    }
//    
    func updatePlant() {
        plant.imageData = plant.imageData
        Task {
            do {
                try await viewModel.save(plant: plant)
            } catch {
                print("* Erro salvando Planta *")
                print(error)
            }
        }
    }
    
    func addPlant() {
        let newPlant = Plant(
            id: plant.id,
            name: plant.name,
            type: plant.type,
            wateringTime: plant.wateringTime,
            sunTime: plant.sunTime,
            watered: plant.watered,
            sunbathed: plant.sunbathed,
            imageData: plant.imageData,
            descriptionPlant:  plant.descriptionPlant,
            bestSoilDescription:  plant.bestSoilDescription,
            weatherDescription:  plant.weatherDescription,
            poisonDescription:  plant.poisonDescription,
            wateringDescription:  plant.wateringDescription,
            sunbathingDescription: plant.sunbathingDescription,
            safeForPetDescription:  plant.safeForPetDescription,
            potSizeDescription: plant.potSizeDescription
//            wateringInstructions: plant.wateringInstructions,
//            idealLight: plant.idealLight,
//            toleratedLight: plant.toleratedLight
        )
        Task {
            do {
                try await viewModel.save(plant: newPlant)
            } catch {
                print("*** Erro salvando Planta ***")
                print(error)
            }
        }
    }
}





struct PlantDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = PlantViewModel.instance
        let plant = Plant(
            name: "Example Plant",
            type: "Fern",
            wateringTime: Date(),
            sunTime: Date(),
            watered: false,
            sunbathed: false,
            imageData: Data(),
            descriptionPlant: "Hana Plant Care highlights the value of detailed descriptions for proper care and healthy growth",
            bestSoilDescription: "",
            weatherDescription: "",
            poisonDescription: "",
            wateringDescription: "",
            sunbathingDescription: "",
            safeForPetDescription: "",
            potSizeDescription: ""
        )
        
        NavigationView {
            PlantDetailView(
                viewModel: viewModel,
                isEditing: true,
                plant: .constant(plant),
                saveMode: true,
                onSave: {
                    print("Plant saved!")
                }
            )
        }
    }
}
  
