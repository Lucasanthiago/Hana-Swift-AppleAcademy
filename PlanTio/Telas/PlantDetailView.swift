import SwiftUI
import PostHog

struct PlantDetailView: View {
    @ObservedObject var viewModel: PlantViewModel
    @State var isEditing = false
    @Binding var plant: Plant
    @State var saveMode: Bool
    var onSave: (() -> Void)? // Callback para ação de salvar
    
    
    var body: some View {
        ZStack{
            VStack {
                FrameImage(imageData: $plant.imageData, aspectRatio: 21/9)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .disabled(isEditing == false)
                
                
                
               
                
                VStack {
                    HStack{
                        TextField("Name", text: $plant.name)
                            .padding(.top, -20)
                            .font(.custom("Quicksand", size: 22))
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .disabled(isEditing == false)
                        Button(action: {}, label: {
                            
                            HStack {
                                Image(systemName:"arrow.counterclockwise.circle.fill")
                                Text("Care History")
                                    .font(.custom("Quicksand", size: 17))
                                    .fontWeight(.bold)
                            }
                            .foregroundColor(Color(.white))
                            .frame(width: 150,height: 38)
                            .background(Color("PinkButton"))
                            .cornerRadius(13)
                            .padding()
                        })
                    }
                    Divider()
                    HStack {
                        Text("Species")
                            .foregroundColor(.gray)
                            .font(.custom("Quicksand", size: 17))
                            .fontWeight(.medium)
                        Spacer()
                        Picker("Tipo", selection: $plant.type) {
                            ForEach(viewModel.commonNames, id: \.self) { commonName in
                                Text(commonName).tag(commonName)
                            }
                        }
                        .disabled(isEditing == false)
                        .pickerStyle(MenuPickerStyle())
                    }
                    .padding(.horizontal, 16)
                    .listStyle(PlainListStyle())
                    .padding(.top, 5)
                    ScrollView {
                        VStack {
                            CareInfos(content: {
                                if plant.wateringInstructions.isEmpty == false {
                                    Text(plant.wateringInstructions)
                                        .padding()
                                        .font(.custom("Quicksand", size: 15))
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
                                        //                                    .fixedSize()
                                        .fixedSize(horizontal: false, vertical: true)// Impede a quebra de linha
                                    }
                                    if plant.idealLight.isEmpty == false{
                                        IdealAndToleratedLight(content: {
                                        }, title: "Tolerated light", icon: "sun.max.fill", iconColor: (Color("NormalText")), description: plant.toleratedLight)
                                        .padding(.horizontal, 18)
                                        .padding(.vertical, 10)
                                        //                                    .fixedSize() // Impede a quebra de linha
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
                        }) {
                            Image( isEditing ? "Done" : "Edit")
                            
                        }
                        }
                }
            }.padding()
        }
        .safeAreaInset(edge: .bottom, content: {
            if saveMode == true {
                Button(action: {
                    
                    PostHogSDK.shared.capture("Newplant")
                    saveMode = false
                    onSave?()
                    isEditing = false
                    randomInfos()
                    addPlant()
                    
                    
                    //                    }
                }, label: { // TODO: resolver save verdadeiro, e aparecer na view
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
//        if saveMode == false{
//            Button(action: {
//                isEditing.toggle()
//                //                        updatePlant()
//            }) {
//                Image( isEditing ? "Done" : "Edit")
//                    .background(Color("Background"))
//            }
//        }

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

//    struct TelaDetalhe_Previews: PreviewProvider {
//        @State static var imageData: Data? = nil // Ligação para os dados da imagem
//
//        static var previews: some View {
//            let plantDetails = PlantDetails(name: "Plant Name", wateringInstructions: "Keep moist between watering.Can be a bit dry between waterings.", idealLight: "Bright light", toleratedLight: "Direct sunlight")
//            return TelaDetalhe(plant: plantDetails)
//        }
//    }


