import SwiftUI

struct PlantDetailView: View {
    @ObservedObject var viewModel: PlantViewModel
    @Environment(\.presentationMode) var presentationMode
    @State var plant: Plant
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?  // Estado para a imagem temporariamente selecionada
    @State private var currentDisplayImage: UIImage?
    
    var body: some View {
//        NavigationView {
            Form {
                TextField("Nome", text: $plant.name)
                Picker("Tipo", selection: $plant.type) {
                    ForEach(viewModel.commonNames, id: \.self) { commonName in
                        Text(commonName).tag(commonName)
                    }
                }

                DatePicker("Horário para Regar", selection: $plant.wateringTime, displayedComponents: .hourAndMinute)
                    .tag(plant.id)
                DatePicker("Horário para Tomar Sol", selection: $plant.sunTime, displayedComponents: .hourAndMinute)
                    .tag(plant.id)
                
                // Exibe a imagem atualmente selecionada ou a imagem já salva
                if let displayImage = currentDisplayImage {
                    Image(uiImage: displayImage)
                        .resizable()
                        .scaledToFit()
                } else if let imageData = plant.imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                }
                
                Button("Escolher Imagem") {
                    self.showingImagePicker = true
                }
                
                HStack {
                    Spacer()
                    Button("Salvar Alterações") {
                        updatePlant()
                        presentationMode.wrappedValue.dismiss()
//                        print(plant.wateringTime.description)
                    }
                    Spacer()
                }
            }
            .navigationBarTitle("Detalhes da Planta", displayMode: .inline)
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(selectedImage: self.$inputImage, sourceType: .photoLibrary)
            }
//        }
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


//#Preview {
//    PlantDetailView(viewModel: PlantViewModel(), plant: Plant(name: "aaaa", type: "cacto", wateringTime: Date(), sunTime: Date()))
//}
