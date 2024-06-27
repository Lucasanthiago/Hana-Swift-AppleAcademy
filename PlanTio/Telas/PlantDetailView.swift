import SwiftUI
import PhotosUI
import PostHog

struct PlantDetailView: View {
    @StateObject var plantInfoManager: PlantInfoManager = PlantInfoManager()

    @EnvironmentObject var store: Store
    @ObservedObject var viewModel: PlantViewModel
    @State var isEditing = false
    @Binding var plant: Plant
    @State var saveMode: Bool
    @State private var customType: String = ""
    var onSave: (() -> Void)? // Callback for save action

    var body: some View {
        ScrollView {
            VStack {
                FrameImage(imageData: $plant.imageData, plantType: $plant.type, aspectRatio: 10)
                    .disabled(isEditing == false)
                    .frame(width: 393, height: 293)

                TextField("Nickname", text: $plant.name)
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
                    if !plant.descriptionPlant.isEmpty {
                        Text(plant.descriptionPlant)
                    } else {
                        Text("")
                            .font(.custom("Quicksand", size: 17, relativeTo: .body))
                    }
                }
                
            }
            ScrollView(.horizontal){
                HStack (spacing: 20){
                    SetRemindersCards(title: "Watering Reminders", icon: "alarm.fill", cardAccentColor: .water, date: $plant.wateringTime)
                    SetRemindersCards(title: "Sunbathing Reminders", icon: "alarm.fill", cardAccentColor: .sun, date: $plant.sunTime)
                    
                }
                .padding()
                .disabled(isEditing == false)
            }
            .scrollIndicators(.hidden)
            
            ScrollView(.horizontal){
                HStack(spacing: 20) {
                    Instructions(
                        contentText: {
                            if !plant.wateringDescription.isEmpty {
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
                            if !plant.sunbathingDescription.isEmpty {
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
                            if !plant.bestSoilDescription.isEmpty {
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
                            if !plant.safeForPetDescription.isEmpty {
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
                            if !plant.weatherDescription.isEmpty {
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
                            if !plant.potSizeDescription.isEmpty {
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
                            if !plant.poisonDescription.isEmpty {
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
            } else {
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
        .overlay(alignment: .bottomTrailing) {
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
        .safeAreaInset(edge: .bottom) {
            if saveMode == true {
                Button(action: {
                    Task {
                        do {
                            PostHogSDK.shared.capture("Newplant")
                            let plantInfo = try await plantInfoManager.getPlantInfo(for: plant.type)
                            updatePlantInfo(with: plantInfo)
                            saveMode = false
                            onSave?()
                            isEditing = false
                            addPlant()
                        } catch {
                            print("Error fetching plant info: \(error)")
                        }
                    }
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
        }
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

    func updatePlantInfo(with plantInfo: PlantInfo) {
        plant.safeForPetDescription = plantInfo.safeForPets
        plant.bestSoilDescription = plantInfo.bestSoil
        plant.wateringDescription = plantInfo.watering
        plant.sunbathingDescription = plantInfo.sunbathing
        plant.weatherDescription = plantInfo.weather
        plant.potSizeDescription = plantInfo.potSize
        plant.poisonDescription = plantInfo.poison
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
        )
        Task {
            do {
                try await viewModel.save(plant: newPlant)
            } catch {
                print("*** Error saving Plant ***")
                print(error)
            }
        }
    }
}





import aiXplainKit

final class PlantInfoManager: ObservableObject {
    @Published var plantInfo: PlantInfo? {
        didSet {
            if let plantInfo = plantInfo {
                print("Plant Info: \(plantInfo)")
            }
        }
    }
    @Published var isLoading: Bool = false
    
    var chatgpt35: Model? = nil
    
    init() {
        setupAiXplain()
    }
    
    private func setupAiXplain() {
        Task {
            configureAPIKey()
            await fetchModels()
        }
    }
    
    @MainActor
    func getPlantInfo(for plantType: String) async throws -> PlantInfo {
        self.isLoading = true
        
        guard let plantInfo = try await createPlantInfo(for: plantType) else {
            self.isLoading = false
            throw NSError(domain: "PlantInfoError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch plant info"])
        }
        
        self.plantInfo = plantInfo
        self.isLoading = false
        return plantInfo
    }
    
    func configureAPIKey() {
        AiXplainKit.shared.keyManager.TEAM_API_KEY = "***CHAVE-REMOVIDA***"
    }
    
    func fetchModels() async {
        let modelProvider = ModelProvider()
        self.chatgpt35 = try? await modelProvider.get("640b517694bf816d35a59125")
    }
    
    func createPlantInfo(for plantType: String) async throws -> PlantInfo? {
        guard let chatgpt35 = self.chatgpt35 else {
            return nil
        }
        
        let prompt = """
        You are an AI assistant designed to provide information about plants. Users will give you the type of plant, and you should return information about the following fields:
        Safe for Pets, Best Soil, Watering, Sunbathing, Weather, Pot Size, Poison.
        
        Do not write the names of the fields just the informations separated in lines.
        Try to make as short as possible the informations.
        Just informations on the lines not the name of the field
        
        
        examples i want you to follow:
        Non-toxic to pets
        Well-draining soil
        Regular watering, let soil dry between
        Full sun
        Thrives in warm climates
        Medium to large pot
        Thorny, can cause skin irritation
        
        
        
        examples i dont want, like this one with the field names:
        Safe for Pets: Non-toxic
        Best Soil: Well-draining
        Watering: Regularly, allow soil to dry between waterings
        Sunbathing: Full sun
        Weather: Thrives in warm climates
        Pot Size: Medium to large
        Poison: Thorny, can cause skin irritation

        Plant type: \(plantType)
        """
        
        let modelOutput = try await chatgpt35.run(["data": prompt])
        print("Model Output: \(modelOutput.output)")
        return try PlantInfo(from: modelOutput.output)
    }
}

struct PlantInfo {
    var safeForPets: String
    var bestSoil: String
    var watering: String
    var sunbathing: String
    var weather: String
    var potSize: String
    var poison: String
    
    init(from output: String) throws {
        // Parse the output string to extract the values
        let lines = output.split(separator: "\n")
        
        guard lines.count >= 7 else {
            throw NSError(domain: "ParsingError", code: 1, userInfo: nil)
        }
        
        self.safeForPets = String(lines[0])
        self.bestSoil = String(lines[1])
        self.watering = String(lines[2])
        self.sunbathing = String(lines[3])
        self.weather = String(lines[4])
        self.potSize = String(lines[5])
        self.poison = String(lines[6])
    }
}
