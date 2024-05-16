import SwiftUI

struct PlantDetailView: View {
    @State private var isEditing = false
    @Binding var plant: Plant
    
    var body: some View {
            VStack {
                FrameImage(imageData: $plant.imageData, aspectRatio: 21/9)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .disabled(isEditing == false)
                VStack {
                    HStack{
                        TextField("Nome", text: $plant.name)
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
                        .padding(.top, -10)
                    
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
                                    IdealAndToleratedLight(content: {
                                    }, title: "Tolerated light", icon: "sun.max.fill", iconColor: .black, description: plant.toleratedLight)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .fixedSize() // Impede a quebra de linha
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
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button(action: {
                    isEditing.toggle()
                }) {
                    
                    Text(isEditing ? "Done" : "Edit")
                }
            )
        
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


