import SwiftUI
import PostHog

struct PlantDetailView: View {
    @ObservedObject var viewModel: PlantViewModel
    @State var isEditing = false
    @Binding var plant: Plant
    @State var saveMode: Bool
    @State private var customType: String = ""
    var onSave: (() -> Void)? // Callback for save action
    
    var body: some View {
        ZStack{
            VStack {
                FrameImage(imageData: $plant.imageData, aspectRatio: 21/9)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .disabled(isEditing == false)
                
                VStack {
                    HStack{
                        TextField("Name", text: $plant.name)
                            .padding(.top, 0)
                            .font(.custom("Quicksand", size: 22, relativeTo: .title2))
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .disabled(isEditing == false)
                       
                    }
                    Divider()
                    HStack {
                        Text("Species")
                            .foregroundColor(.gray)
                            .font(.custom("Quicksand", size: 17, relativeTo: .body))
                            .fontWeight(.medium)
                        Spacer()
                        Picker("Type", selection: $plant.type) {
                            ForEach(viewModel.commonNames + ["Other"], id: \.self) { commonName in
                                Text(commonName).tag(commonName)
                            }
                        }
                        .disabled(isEditing == false)
                        .pickerStyle(MenuPickerStyle())
                    }
                    .padding(.horizontal, 16)
                    .listStyle(PlainListStyle())
                    .padding(.top, 5)
                    
                    if plant.type.starts(with: "Other") {
                        TextField("Enter custom type", text: $customType)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal, 16)
                            .disabled(isEditing == false)
                            .onChange(of: customType) { newValue in
                                if plant.type.starts(with: "Other:") {
                                    plant.type = "Other: \(newValue)"
                                }
                            }
                    }
                    
                    ScrollView {
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
                                HStack (alignment: .top) {
                                    if plant.idealLight.isEmpty == false{
                                        IdealAndToleratedLight(content: {
                                        }, title: "Ideal light", icon: "sun.min.fill", iconColor: (Color("NormalText")), description: plant.idealLight)
                                        .padding()
                                        .fixedSize(horizontal: false, vertical: true)
                                    }
                                    if plant.idealLight.isEmpty == false{
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
            }
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    if saveMode == false {
                        Button(action: {
                            isEditing.toggle()
                            if plant.type == "Other" {
                                plant.type = "Other: \(customType)"
                                
                            }
                        }) {
                            Image( isEditing ? "Done" : "Edit")
                                .shadow(color: .shadow.opacity(0.3), radius: 5, x: 0, y: 4)
                        }
                    }
                }
            }.padding()
        }
        .toolbar(.hidden, for: .tabBar)
        .safeAreaInset(edge: .bottom, content: {
            if saveMode == true {
                Button(action: {
                    PostHogSDK.shared.capture("Newplant")
                    if plant.type == "Other" {
                        plant.type = "Other: \(customType)"
                    }
                    saveMode = false
                    onSave?()
                    isEditing = false
                    if plant.type == "Other: \(customType)" {
                        print("eu")
                    } else{
                        randomInfos()

                    }
                        
                    addPlant()
                }, label: {
                    Text("Save")
                        .font(.body)
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
        .background(Color("Background"))
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

