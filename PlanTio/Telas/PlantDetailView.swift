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
                
                
                
                TextField("Name", text: $plant.name)
                    .font(.custom("Quicksand", size: 17, relativeTo: .body))
                    .padding(.leading)
                    .padding(.top)
                    .disabled(isEditing == false)
                
                
                TextField("Type", text: $plant.type)
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
                
                
            }}
        .ignoresSafeArea()
        
        VStack {
            
            HStack {
                Spacer()
                if saveMode == false {
                    Button(action: {
                        isEditing.toggle()
                    }) {
                        Image(isEditing ? "Done" : "Edit")
                            .shadow(color: .shadow.opacity(0.3), radius: 5, x: 0, y: 4)
                    }
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
                    randomInfos()
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
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.red))
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
            wateringInstructions: plant.wateringInstructions,
            idealLight: plant.idealLight,
            toleratedLight: plant.toleratedLight
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





// Preview
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
            wateringInstructions: "Water regularly.",
            idealLight: "Bright light",
            toleratedLight: "Low light"
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
