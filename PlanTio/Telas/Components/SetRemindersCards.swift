//
//  SetRemindersCards.swift
//  PlanTio
//
//  Created by Gabriela Azulay Lewin on 27/06/24.
//

import SwiftUI

struct SetRemindersCards: View {
    
    var title: String
    var icon: String
    var cardAccentColor: Color
    @Binding var date : Date
    @State var isToggled = true
    
    
    var body: some View {
        
        
        
           
        HStack (spacing: 20){
                    Image(systemName: icon)
                        .font(.largeTitle)
                        .foregroundStyle(cardAccentColor)
                    
                    Text(title)
                        .font(.custom("Quicksand", size: 20, relativeTo: .title3))
                        .bold()
                    
                    Spacer()
                    
                    HStack{
                        DatePicker("Watering Time", selection: $date, displayedComponents: [.hourAndMinute])
                            .background {
                                cardAccentColor.opacity(1).saturation(1.0)
                                    .clipShape(.rect(cornerRadius: 8))
                            }
                            .environment(\.colorScheme, .dark)
                        
                            .labelsHidden()
                            .fixedSize()
                        
//                        Spacer()
                        
//                        Toggle(isOn: $isToggled) {
//                            Text("Toggle Notifications")
//                        }
//                        .tint(Color(cardAccentColor))
//                        .labelsHidden()
                        //                .onChange(of: isToggled) { newValue in
                        //                    Task {
                        //                        if alarmType == .watering {
                        //                            await viewModel.toggleWateringNotifications(for: plant, isEnabled: newValue)
                        //                        } else {
                        //                            await viewModel.toggleSunbathingNotifications(for: plant, isEnabled: newValue)
                        //                        }
                        //                    }
                    }
                    
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(Color("Cards"))
                        .shadow(color: Color.shadow.opacity(0.3), radius: 5, x: 0, y: 4)
                    )
            }
            
            
            
            
            
        }
    
    
    
    




//#Preview {
//    SetRemindersCards(title: "Watering", icon: "drop.circle.fill", cardAccentColor: .water, date: wateringTime.plant)
//}
//
