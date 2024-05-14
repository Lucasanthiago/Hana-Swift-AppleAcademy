//
//  CardsReminders.swift
//  PlanTio
//
//  Created by Lucas Santos on 13/05/24.
//

import SwiftUI

//
//  CardsReminders.swift
//  PlanTio





struct CardsReminders<Content: View>: View {
    @ViewBuilder let content: Content
    var plantName: String
    var title: String
    var time: String // CORRIGIR PARA HORÁRIO (DATE)
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
                        Text(time)
                            .font(.title)
                            .bold()
                    }
                    Spacer()
                    Toggle(isOn: $isToggled) {Text("")}
                        .tint(Color(toggleColor))
                    
                    //                    Text("Status: \(isToggled ? "Ligado" : "Desligado")")
                    
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
                    .shadow(radius: 8)
                    .opacity(0.6))
        }
    }
}

#Preview {
    VStack (spacing: 50) {
        CardsReminders (content: {
        }, plantName: "Pedro Gomes", title: "Reminder", time: "07:00", careType: "Watering", checkColor: .cyan, toggleColor: .cyan)
        CardsReminders (content: {
        }, plantName: "Ric", title: "Reminder", time: "10:00", careType: "Sunbathing", checkColor: .orange, toggleColor: .orange)
    }
}


