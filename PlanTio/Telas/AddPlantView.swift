import SwiftUI

struct AddPlantView: View {
    @ObservedObject var viewModel: PlantViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String = ""
    @State private var type: String = ""
    @State  var wateringTime: Date = Date()
    @State  var sunTime: Date = Date()
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State var plant: Plant
    
    @State  var selectedCommonName: String = ""

    
    var body: some View {
//        NavigationView {
            Form {
                TextField("Nome", text: $name)
                Picker("Tipo", selection: $selectedCommonName) {
                                    ForEach(viewModel.commonNames, id: \.self) { commonName in
                                        Text(commonName).tag(commonName)
                                    }
                                }
                DatePicker("Horário para Regar", selection: $wateringTime, displayedComponents: .hourAndMinute)
                DatePicker("Horário para Tomar Sol", selection: $sunTime, displayedComponents: .hourAndMinute)
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
                        viewModel.addPlant(name: name, type: selectedCommonName, wateringTime: wateringTime, sunTime: sunTime, image: inputImage)
                        presentationMode.wrappedValue.dismiss()
                    }
                    Spacer()
                }
            }
            .navigationBarTitle("Adicionar Planta", displayMode: .inline)
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(selectedImage: self.$inputImage, sourceType: .photoLibrary)
            }
//        }
    }

    func loadImage() {
        // A imagem já está no estado inputImage, pronta para ser salva com os detalhes da planta.
    }
}
