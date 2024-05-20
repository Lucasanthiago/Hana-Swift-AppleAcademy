import SwiftUI

struct PlantDetailView: View {
    @ObservedObject var viewModel: PlantViewModel
    @State var isEditing = false
    @Binding var plant: Plant
    @State var saveMode: Bool
    var onSave: (() -> Void)? // Callback para ação de salvar
    
    
    var body: some View {
        VStack {
            FrameImage(imageData: $plant.imageData, aspectRatio: 21/9)
                .frame(maxWidth: .infinity, alignment: .center)
                .disabled(isEditing == false)
            VStack {
                HStack{
                    TextField("Name", text: $plant.name)
                        .padding(.top, -20)
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .disabled(isEditing == false)
                    Button(action: {}, label: {
                        
                        HStack {
                            Image(systemName:"arrow.counterclockwise.circle.fill")
                            Text("Care History")
                            
                        }
                        .foregroundColor(.white)
                        .frame(width: 143,height: 38)
                        .background(Color.green)
                        .cornerRadius(13)
                        .padding()
                        .padding(.top, -10)
                    })
                }
                Divider()
                HStack {
                    Text("Type")
                        .foregroundColor(.gray)
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
                                    .font(.subheadline)
                            }
                        }, title: "Watering", icon: "drop.circle.fill", iconColor: .cyan, date: Date())
                        .padding(.vertical)
                        .padding(.horizontal)
                        
                        CareInfos(content: {
                            HStack {
                                if plant.idealLight.isEmpty == false{
                                    IdealAndToleratedLight(content: {
                                    }, title: "Ideal light", icon: "sun.min.fill", iconColor: .black, description: plant.idealLight)
                                    .padding()
                                    .fixedSize() // Impede a quebra de linha
                                }
                                if plant.idealLight.isEmpty == false{
                                    IdealAndToleratedLight(content: {
                                    }, title: "Tolerated light", icon: "sun.max.fill", iconColor: .black, description: plant.toleratedLight)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .fixedSize() // Impede a quebra de linha
                                }
                            }
                            .padding(.leading, 10)
                            .padding(.trailing, 10)
                        }, title: "Sunbathing", icon: "sun.max.fill", iconColor: .orange, date: Date())
                        .padding(.horizontal)
                        
                    }
                    
                    .disabled(isEditing == false)
                }
            }
        }
        .safeAreaInset(edge: .bottom, content: {
            if saveMode == true {
                Button(action: {
                        saveMode = false
                        onSave?()
                        isEditing = false
//                    }
                }, label: { // TODO: resolver save verdadeiro, e aparecer na view
                    Text("Save")
                        .font(.body)
                        .bold()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: 56)
                        .background(Color.green)
                        .cornerRadius(13)
                        .padding(.horizontal)
                })
            }
        })
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                if saveMode == false{
                    Button(action: {
                        isEditing.toggle()
                    }) {
                        
                        Text(isEditing ? "Done" : "Edit")
                    }
                    .font(.body)
                    .bold()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: 56)
                    .background(Color.green)
                    .cornerRadius(13)
                    .padding(.horizontal)
                    Spacer()
                }
            }
        })
        //
        
    }
    //
    
    //    func addPlant() {
    //        let newPlant = Plant(
    //            id: plant.id,
    //            name: plant.name,
    //            type: plant.type,
    //            wateringTime: plant.wateringTime,
    //            sunTime: plant.sunTime,
    //            watered: plant.watered,
    //            sunbathed: plant.sunbathed,
    //            imageData: plant.imageData,
    //            wateringInstructions: plant.wateringInstructions,
    //            idealLight: plant.idealLight,
    //            toleratedLight: plant.toleratedLight
    //        )
    //        Task {
    //            do {
    //                try await viewModel.save(plant: newPlant)
    //            } catch {
    //                print("*** Erro salvando Planta ***")
    //                print(error)
    //            }
    //        }
    //    }
}

//    struct TelaDetalhe_Previews: PreviewProvider {
//        @State static var imageData: Data? = nil // Ligação para os dados da imagem
//
//        static var previews: some View {
//            let plantDetails = PlantDetails(name: "Plant Name", wateringInstructions: "Keep moist between watering.Can be a bit dry between waterings.", idealLight: "Bright light", toleratedLight: "Direct sunlight")
//            return TelaDetalhe(plant: plantDetails)
//        }
//    }


