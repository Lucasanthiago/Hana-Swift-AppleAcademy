//
//  CardsReminders.swift
//  PlanTio
//
//  Created by Gabriela Azulay Lewin on 10/05/24.
//

import SwiftUI




struct CardsReminders<Content: View>: View {
    @ViewBuilder let content: Content
    var plantName: String
    var title: String
    var time: String // CORRIGIR PARA HORÁRIO (DATE)
    var careType: String
    var checkColor: Color
    var toggleColor: Color
    @State  var isToggled = false

    
    
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
                    Toggle(isOn: $isToggled) {
                                    Text("")
                                }
//                    Text("Status: \(isToggled ? "Ligado" : "Desligado")")
            
                }
                Divider()
                HStack {
                    Text(careType)
                        .font(.title2)
                        .bold()
                        .padding(.top)
                    Spacer()
                    //Checkbox
                }
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
    CardsReminders (content: {
    }, plantName: "PedroGomes", title: "Reminder", time: "07:00", careType: "Watering", checkColor: .cyan, toggleColor: .cyan)
}
