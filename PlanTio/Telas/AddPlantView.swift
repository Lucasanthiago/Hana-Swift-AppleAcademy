import SwiftUI

struct AddPlantView: View {
    @ObservedObject var viewModel: PlantViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String = ""
    @State private var type: String = ""
    @State private var wateringTime: Date = Date()
    @State private var sunTime: Date = Date()
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State var plant: Plant
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Nome", text: $name)
                TextField("Tipo", text: $type)
                DatePicker("Horário para Regar", selection: $plant.wateringTime, displayedComponents: .hourAndMinute)
                DatePicker("Horário para Tomar Sol", selection: $plant.sunTime, displayedComponents: .hourAndMinute)
                Button("Escolher Imagem") {
                    self.showingImagePicker = true
                }
                if inputImage != nil {
                    Image(uiImage: inputImage!)
                        .resizable()
                        .scaledToFit()
                }
                HStack {
                    Spacer()
                    Button("Salvar") {
                        viewModel.addPlant(name: name, type: type, wateringTime: wateringTime, sunTime: sunTime, image: inputImage)
                        presentationMode.wrappedValue.dismiss()
                        print(plant.wateringTime.description)
                        print(plant.sunTime.description)

                    }
                    Spacer()
                }
            }
            .navigationBarTitle("Adicionar Planta", displayMode: .inline)
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(selectedImage: self.$inputImage, sourceType: .photoLibrary)
            }
        }
    }

    func loadImage() {
        // A imagem já está no estado inputImage, pronta para ser salva com os detalhes da planta.
    }
}
