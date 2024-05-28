//
//  ReminderCard.swift
//  PlanTio
//
//  Created by Lucas Santos on 14/05/24.
//


import SwiftUI
import PostHog



struct ReminderCard<Content: View>: View {
    @ViewBuilder let content: Content
    var plantName: String
    var title: String
    var time: Date // CORRIGIR PARA HORÁRIO (DATE)
    var careType: String
    var checkColor: Color
    var toggleColor: Color
    @State var isToggled = true
    @State var isDone = false
    
    var body: some View {
        VStack(alignment: .leading){
            Text(plantName)
                .font(.custom("Quicksand", size: 20))
                .bold()
                .foregroundStyle(Color.gray)
                .padding(.leading)
            
            
            VStack{
                HStack {
                    VStack (alignment: .leading) {
                        Text(title)
                            .font(.custom("Quicksand", size: 15))
                        Text("\(time, formatter: dateFormatter)")
                            .font(.custom("Quicksand", size: 28))
                            .fontWeight(.medium)
                    }
                    Spacer()
                    Toggle(isOn: $isToggled) {
                        Text("Toggle Notifications")}
                        .tint(Color(toggleColor))
                        .labelsHidden()
                    
                                        
                    
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
                }
                .padding(.top)
            }
            .onChange(of: isToggled) { oldValue, newValue in
                PostHogSDK.shared.capture("ToggleUsed")
                
            }
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color("Cards"))
                    .shadow(color: .shadow.opacity(0.3), radius: 5, x: 0, y: 4))
        }
    }
}

#Preview {
    VStack (spacing: 50) {
        ReminderCard (content: {
        }, plantName: "Pedro Gomes", title: "Reminder", time: Date(), careType: "Watered", checkColor: (Color("Water")), toggleColor: (Color("Water")))
        ReminderCard (content: {
        }, plantName: "Ric", title: "Reminder", time: Date(), careType: "Sunbathed", checkColor: (Color("Sun")), toggleColor: (Color("Sun")))
    }
}


