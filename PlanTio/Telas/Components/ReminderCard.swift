//
//  ReminderCard.swift
//  PlanTio
//
//  Created by Lucas Santos on 14/05/24.
//


import SwiftUI




struct ReminderCard<Content: View>: View {
    @ViewBuilder let content: Content
    var plantName: String
    var title: String
    var time: Date // CORRIGIR PARA HORÁRIO (DATE)
    var careType: String
    var checkColor: Color
    var toggleColor: Color
    @State var isToggled = false
    @State var isDone = false
    
    
    var body: some View {
        VStack(alignment: .leading){
            Text(plantName)
                .font(.title3)
                .bold()
                .foregroundStyle(Color.gray)
                .padding(.leading)
            
            VStack{
                HStack {
                    VStack (alignment: .leading) {
                        Text(title)
                        Text("\(time)")
                          
                    }
                    Spacer()
                    Toggle(isOn: $isToggled) {Text("Toggle Notifications")}
                        .tint(Color(toggleColor))
                        .labelsHidden()
                    
                                        
                    
                }
                Divider()
                HStack {
                    Text(careType)
                        .font(.title2)
                        .bold()
                    
                    Spacer()
                    
                    Button(action: {
                        isDone.toggle()
                    }) {
                        Image(systemName: isDone ? "checkmark.circle.fill" : "circle")
                            .font(.title)
                            .foregroundColor(checkColor)
                    }
                }
                .padding(.top)
            }
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.white)
                    .shadow(color: Color(white: 0.2).opacity(0.5), radius: 8))
        }
    }
}

#Preview {
    VStack (spacing: 50) {
        ReminderCard (content: {
        }, plantName: "Pedro Gomes", title: "Reminder", time: Date(), careType: "Watering", checkColor: .cyan, toggleColor: .cyan)
        ReminderCard (content: {
        }, plantName: "Ric", title: "Reminder", time: Date(), careType: "Sunbathing", checkColor: .orange, toggleColor: .orange)
    }
}


