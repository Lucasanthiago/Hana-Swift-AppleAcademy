import SwiftUI

struct AlarmView: View {
    var viewModel: PlantViewModel
    var plant: Plant
    var type: AlarmType

    var body: some View {
        HStack {
            ReminderCard(content: {
            }, plant: plant, viewModel: viewModel, title: "Reminder", time: type == .watering ? plant.wateringTime : plant.sunTime,
                          careType: type == .watering ? "Watered" : "Sunbathed",
                          toggleColor: type == .watering ? Color("Water") : Color("Sun"),
                          alarmType: type)
        }
    }
}

enum AlarmType {
    case watering, sunlight
}
