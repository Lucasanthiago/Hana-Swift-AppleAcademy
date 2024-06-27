import SwiftUI


struct AddPlantView: View {
    @ObservedObject var viewModel: PlantViewModel
    @State var newPlant = Plant(name: "", type: "", wateringTime: Date(), sunTime: Date(), descriptionPlant: "", bestSoilDescription: "", weatherDescription: "", poisonDescription: "", wateringDescription: "", sunbathingDescription: "", safeForPetDescription: "", potSizeDescription: "")
    @State var isEditing = true

    var body: some View {
        VStack {
            if isEditing {
                PlantDetailView(
                    viewModel: viewModel,
                    isEditing: isEditing,
                    plant: $newPlant,
                    saveMode: true,
                    onSave: {
                        Task {
                            await viewModel.addPlant(newPlant)
                            isEditing = false // Deactivates edit mode after saving
                        }
                    }
                )
            } else {
                PlantDetailView(
                    viewModel: viewModel,
                    isEditing: isEditing,
                    plant: $newPlant,
                    saveMode: false,
                    onSave: nil
                )
            }
        }
    }
}
