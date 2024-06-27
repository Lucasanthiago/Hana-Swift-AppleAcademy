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
                    CareInfos(content: {
                        if plant.wateringInstructions.isEmpty == false {
                            Text(plant.wateringInstructions)
                                .padding()
                                .font(.custom("Quicksand", size: 15, relativeTo: .subheadline))
                                .fontWeight(.medium)
                        }
                    }, title: "Watering", icon: "drop.circle.fill", iconColor: (Color("Water")), date: $plant.wateringTime)
                    .padding(.vertical)
                    .padding(.horizontal)

                    CareInfos(content: {
                        HStack(alignment: .center) {
                            if plant.idealLight.isEmpty == false {
                                IdealAndToleratedLight(content: {
                                }, title: "Ideal light", icon: "sun.min.fill", iconColor: (Color("NormalText")), description: plant.idealLight)
                                .padding()
                                .fixedSize(horizontal: false, vertical: true)
                            }
                            if plant.toleratedLight.isEmpty == false {
                                IdealAndToleratedLight(content: {
                                }, title: "Tolerated light", icon: "sun.max.fill", iconColor: (Color("NormalText")), description: plant.toleratedLight)
                                .padding(.horizontal, 18)
                                .padding(.vertical, 10)
                                .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        .padding(.leading, 10)
                        .padding(.trailing, 10)
                    }, title: "Sunbathing", icon: "sun.max.fill", iconColor: Color("Sun"), date: $plant.sunTime)
                    .padding(.horizontal)
                }
                .disabled(isEditing == false)
            }
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
                            randomInfos()
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
        plant.safeForPets = plantInfo.safeForPets
        plant.bestSoil = plantInfo.bestSoil
        plant.wateringInstructions = plantInfo.watering
        plant.sunbathing = plantInfo.sunbathing
        plant.weather = plantInfo.weather
        plant.potSize = plantInfo.potSize
        plant.poison = plantInfo.poison
    }

    func randomInfos() {
        let wateringInstructionsOptions = [
            "Keep moist between watering.\nMust not be dry between watering",
            "Water only when the soil is dry.\nMust be dry between watering",
            "Water when soil is half dry.\nChange water in the vase regularly."
        ]

        let idealLightOptions = [
            "Bright light",
            "6 or more hours of direct sunlight per day"
        ]

        let toleratedLightOptions = [
            "Diffused",
            "Direct sunlight",
        ]

        plant.wateringInstructions = wateringInstructionsOptions.randomElement() ?? ""
        plant.idealLight = idealLightOptions.randomElement() ?? ""
        plant.toleratedLight = toleratedLightOptions.randomElement() ?? ""
    }

    func updatePlant() {
        plant.imageData = plant.imageData
        Task {
            do {
                try await viewModel.save(plant: plant)
            } catch {
                print("* Error saving Plant *")
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
            wateringInstructions: plant.wateringInstructions,
            idealLight: plant.idealLight,
            toleratedLight: plant.toleratedLight,
            safeForPets: plant.safeForPets,
            bestSoil: plant.bestSoil,
            sunbathing: plant.sunbathing,
            weather: plant.weather,
            potSize: plant.potSize,
            poison: plant.poison
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
