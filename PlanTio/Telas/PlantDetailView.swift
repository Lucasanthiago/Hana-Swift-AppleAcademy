import SwiftUI

struct PlantDetailView: View {
    @ObservedObject var viewModel: PlantViewModel
    @Environment(\.presentationMode) var presentationMode
    @State var plant: Plant
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?  // Estado para a imagem temporariamente selecionada
    @State private var currentDisplayImage: UIImage?
    
    var body: some View {

//            Form {
//                TextField("Nome", text: $plant.name)
//                Picker("Tipo", selection: $plant.type) {
//                    ForEach(viewModel.commonNames, id: \.self) { commonName in
//                        Text(commonName).tag(commonName)
//                    }
//                }
//
//                DatePicker("Horário para Regar", selection: $plant.wateringTime, displayedComponents: .hourAndMinute)
//                DatePicker("Horário para Tomar Sol", selection: $plant.sunTime, displayedComponents: .hourAndMinute)
//                
//                // Exibe a imagem atualmente selecionada ou a imagem já salva
//                if let displayImage = currentDisplayImage {
//                    Image(uiImage: displayImage)
//                        .resizable()
//                        .scaledToFit()
//                } else if let imageName = plant.imageName, let uiImage = UIImage(contentsOfFile: getDocumentsDirectory().appendingPathComponent(imageName).path) {
//                    Image(uiImage: uiImage)
//                        .resizable()
//                        .scaledToFit()
//                }
//                
//                Button("Escolher Imagem") {
//                    self.showingImagePicker = true
//                }
//                
//                HStack {
//                    Spacer()
//                    Button("Salvar Alterações") {
//                        saveImageIfNeeded()
//                        viewModel.updatePlant(updatedPlant: plant, wateringTime: wateringTime, sunTime: sunTime)
//                        presentationMode.wrappedValue.dismiss()
//                    }
//                    Spacer()
//                }
//            }
//            .navigationBarTitle("Detalhes da Planta", displayMode: .inline)
//            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
//                ImagePicker(selectedImage: self.$inputImage, sourceType: .photoLibrary)
//            }
        
        
        ///divisao
        
        VStack {
                    FrameImage(imageData: .constant(plant.imageData), aspectRatio: 21/9)
                        .frame(maxWidth: .infinity, alignment: .center)
        
                    VStack {
                        TextField("Name", text: $plant.name)
                            .font(.title2)
                            .padding(.horizontal)
                            .padding(.top)
        
                        Divider()
        
                        Picker("Tipo", selection: $plant.type) {
                            ForEach(viewModel.commonNames, id: \.self) { commonName in
                                Text(commonName).tag(commonName)
                            }
                        }
                        
                        .font(.subheadline)
                        .padding(.horizontal)
                        .padding(.top)
                    }
                    VStack {
                        CareInfos(content: {
        
                    }, title: "Watering", icon: "drop.circle.fill", iconColor: .cyan, date: Date())
        
                        .padding(.vertical)
                        .padding(.horizontal)
                        CareInfos(content: {
                        }, title: "Sunbathing", icon: "sun.max.fill", iconColor: .orange, date: Date())
                        .padding(.horizontal)
                    }
        
                    Button(action: {
                        saveImageIfNeeded()
                        viewModel.updatePlant(updatedPlant: plant, wateringTime: wateringTime, sunTime: sunTime)
                        presentationMode.wrappedValue.dismiss()
                    }) {
        
                        Text("Save")
                            .font(.body)
                            .bold()
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .frame(maxWidth: 56, maxHeight: .infinity, alignment: .center)
                            .foregroundColor(.white)
                            .frame(width: 377, height: 56, alignment: .top)
                            .background(Color.green)
                            .cornerRadius(13)
                            .padding()
                    }
        
                }
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(selectedImage: self.$inputImage, sourceType: .photoLibrary)
            }
        
        
    }
    
    func updatePlant() {
        plant.imageData = inputImage?.data
        Task {
            do {
                try await viewModel.save(plant: plant)
            } catch {
                print("*** Erro salvando Planta ***")
                print(error)
            }
        }
    }

    func loadImage() {
        if let inputImage = self.inputImage {
            self.currentDisplayImage = inputImage  // Atualiza a imagem para exibição imediata
            
        }
    }

//    func saveImageIfNeeded() {
//        if let inputImage = self.inputImage {
//            let imageName = UUID().uuidString + ".jpeg"
//            let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
//            if let jpegData = inputImage.jpegData(compressionQuality: 0.8) {
//                try? jpegData.write(to: imagePath)
//                plant.imageName = imageName  // Atualiza o nome da imagem somente ao salvar
//            }
//        }
//    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}


#Preview {
    PlantDetailView(viewModel: PlantViewModel(), plant: Plant(name: "aaaa", type: "cacto", wateringTime: Date(), sunTime: Date()))
}



//
//  EditPlantView.swift
//  teste
//
//  Created by izabour Azevedo on 13/05/24.
//
//import SwiftUI
//
//struct PlantDetailView: View {
//    @Binding var plant: Plant
//    @Environment(\.presentationMode) var presentationMode
//    @State private var isShowingImagePicker = false
//    @State private var pickedImage: UIImage?
//    
//    var body: some View {
//        VStack {
//                FrameImage(imageData: .constant(plant.imageData), aspectRatio: 21/9)
//                .frame(maxWidth: .infinity, alignment: .center)
//            
//            VStack {
//                TextField("Name", text: $plant.name)
//                    .font(.title2)
//                    .padding(.horizontal)
//                    .padding(.top)
//                
//                Divider()
//                
//                TextField("type", text: $plant.name)
//                    .font(.subheadline)
//                    .padding(.horizontal)
//                    .padding(.top)
//            }
//            VStack {
//                CareInfos(content: {
//                       
//            }, title: "Watering", icon: "drop.circle.fill", iconColor: .cyan, date: Date())
//                
//                .padding(.vertical)
//                .padding(.horizontal)
//                CareInfos(content: {
//                }, title: "Sunbathing", icon: "sun.max.fill", iconColor: .orange, date: Date())
//                .padding(.horizontal)
//            }
//            
//            Button(action: {
//                presentationMode.wrappedValue.dismiss()
//            }) {
//                
//                Text("Save")
//                    .font(.body)
//                    .bold()
//                    .multilineTextAlignment(.center)
//                    .foregroundColor(.white)
//                    .frame(maxWidth: 56, maxHeight: .infinity, alignment: .center)
//                    .foregroundColor(.white)
//                    .frame(width: 377, height: 56, alignment: .top)
//                    .background(Color.green)
//                    .cornerRadius(13)
//                    .padding()
//            }
//            
//        }
//    }
//    
//    func loadImage() {
//        guard let pickedImage = pickedImage else { return }
//        plant.imageData = pickedImage.jpegData(compressionQuality: 0.7)
//    }
//}


//struct EditPlantView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditPlantView(plant: .constant(PlantDetails(name: "", wateringInstructions: "", idealLight: "", toleratedLight: "", imageData: nil)))
//    }
//}

