import SwiftUI
import PostHog

struct ReminderCard<Content: View>: View {
    @ViewBuilder let content: Content
    var plant: Plant
    var viewModel: PlantViewModel
    var title: String
    var time: Date
    var careType: String
    var checkColor: Color
    var toggleColor: Color
    var alarmType: AlarmType
    @State var isToggled = true
    @State var isDone = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(plant.name)
                .font(.custom("Quicksand", size: 20))
                .bold()
                .foregroundStyle(Color.gray)
                .padding(.leading)
            
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text(title)
                            .font(.custom("Quicksand", size: 15))
                        Text("\(time, formatter: dateFormatter)")
                            .font(.custom("Quicksand", size: 28))
                            .fontWeight(.medium)
                    }
                    Spacer()
                    Toggle(isOn: $isToggled) {
                        Text("Toggle Notifications")
                    }
                    .tint(Color(toggleColor))
                    .labelsHidden()
                    .onChange(of: isToggled) { newValue in
                        Task {
                            if alarmType == .watering {
                                await viewModel.toggleWateringNotifications(for: plant, isEnabled: newValue)
                            } else {
                                await viewModel.toggleSunbathingNotifications(for: plant, isEnabled: newValue)
                            }
                        }
                        PostHogSDK.shared.capture("ToggleUsed")
                    }
                }
                Divider()
                HStack {
                    Text(careType)
                        .font(.custom("Quicksand", size: 22))
                        .bold()
                    
                    Spacer()
                    
                    Button(action: {
                        isDone.toggle()
                        PostHogSDK.shared.capture("CheckUsed")
                    }) {
                        Image(systemName: isDone ? "checkmark.circle.fill" : "circle")
                            .font(.title)
                            .foregroundColor(checkColor)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.top)
            }
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color("Cards"))
                    .shadow(color: .shadow.opacity(0.3), radius: 5, x: 0, y: 4)
            )
        }
    }
}
