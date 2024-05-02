


import SwiftUI

struct PlantDetailView: View {
    @ObservedObject var viewModel: PlantViewModel
    @Environment(\.presentationMode) var presentationMode
    @State var plant: Plant

    var body: some View {
        NavigationView {
            Form {
                TextField("Nome", text: $plant.name)
                TextField("Tipo", text: $plant.type)
                DatePicker("Horário para Regar", selection: $plant.wateringTime, displayedComponents: .hourAndMinute)
                DatePicker("Horário para Tomar Sol", selection: $plant.sunTime, displayedComponents: .hourAndMinute)
                HStack {
                    Spacer()
                    Button("Salvar Alterações") {
                        viewModel.updatePlant(updatedPlant: plant)
                        presentationMode.wrappedValue.dismiss()
                        print(plant.wateringTime.description)
                    }
                    Spacer()
                }
            }
            .navigationBarTitle("Detalhes da Planta", displayMode: .inline)
        }
    }
}


#Preview {
    PlantDetailView(viewModel: PlantViewModel(), plant: Plant(name: "aaaa", type: "cacto", wateringTime: Date(), sunTime: Date()))
}
