import SwiftUI

struct AddPlantView: View {
    @State var newPlant = Plant(name: "", type: "", wateringTime: .now, sunTime: .now, wateringInstructions: "", idealLight: "", toleratedLight: "")
    @State var isEditing = true
    var body: some View {
        VStack {
                   if isEditing {
                       PlantDetailView(viewModel: PlantViewModel(), isEditing: isEditing, plant: $newPlant, saveMode: true, onSave: {
                           // Ação ao salvar
                           isEditing = true// Desativa o modo de edição após salvar
                       })
                   } else {
                       PlantDetailView(viewModel: PlantViewModel(), isEditing: isEditing, plant: $newPlant, saveMode: false, onSave: nil)
                   }
               }
        
           }
    
//        PlantDetailView(isEditing: true, plant: $newPlant, saveMode: true)
//    }
    // Assim que add o tipo  wateringInstructions, idealLight e toleratedLight
//    @ObservedObject var viewModel: PlantViewModel
//    @Environment(\.presentationMode) var presentationMode
//    @State private var name: String = ""
//    @State private var type: String = ""
//    @State  var wateringTime: Date = Date()
//    @State  var sunTime: Date = Date()
//    @State private var showingImagePicker = false
//    @State private var inputImage: UIImage?
//    @State var plant: Plant
//    
//    @State  var selectedCommonName: String = ""
//
//    
//    var body: some View {
////        NavigationView {
//            Form {
//                TextField("Nome", text: $name)
//                Picker("Tipo", selection: $plant.type) {
//                    ForEach(viewModel.commonNames, id: \.self) { commonName in
//                        Text(commonName).tag(commonName)
//                    }
//                }
//
//                DatePicker("Horário para Regar", selection: $wateringTime, displayedComponents: .hourAndMinute)
//                DatePicker("Horário para Tomar Sol", selection: $sunTime, displayedComponents: .hourAndMinute)
//                Button("Escolher Imagem") {
//                    self.showingImagePicker = true
//                }
//                if inputImage != nil {
//                    Image(uiImage: inputImage!)
//                        .resizable()
//                        .scaledToFit()
//                }
//                HStack {
//                    Spacer()
//                    Button("Salvar") {
//                        addPlant()
//                        presentationMode.wrappedValue.dismiss()
//                    }
//                    Spacer()
//                }
//            }
//            .navigationBarTitle("Adicionar Planta", displayMode: .inline)
//            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
//                ImagePicker(selectedImage: self.$inputImage, sourceType: .photoLibrary)
//            }
////        }
//    }
//    
//    func addPlant() {
////        let newPlant = Plant(name: name, type: selectedCommonName, wateringTime: wateringTime, sunTime: sunTime, imageData: inputImage?.data)
////        Task {
////            do {
////                try await viewModel.save(plant: newPlant)
////            } catch {
////                print("*** Erro salvando Planta ***")
////                print(error)
////            }
////        }
//    }
//
//    func loadImage() {
//        // A imagem já está no estado inputImage, pronta para ser salva com os detalhes da planta.
//    }
}
