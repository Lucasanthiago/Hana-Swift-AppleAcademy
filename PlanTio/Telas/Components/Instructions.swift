//
//  Instructions.swift
//  PlanTio
//
//  Created by izabour Azevedo on 24/06/24.
//

import SwiftUI

struct Instructions<Content: View>: View {
    
    @ViewBuilder let content: Content
    var title : String
    var icon : String
    var iconColor : Color
    
    
    var body: some View {
        VStack {
            VStack {
                HStack{
                    Image(systemName: icon)
                        .padding(.leading)
                        .foregroundStyle(iconColor)
                        .font(.custom("", size: 60).bold())
                    
                    Text(title)
                        .font(.custom("Quicksand", size: 20, relativeTo: .title3))
                        .bold()
                    
                    Spacer()
                        .environment(\.colorScheme, .dark)
                    
                    
                }
            }
            
            content
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(Color("Cards"))
                .shadow(color: .shadow.opacity(0.3), radius: 5, x: 0, y: 4)
        )

    }
    
    
}

#Preview {
    Instructions(content: {
        VStack { Text("They usually need to be used once a week to allow the soil to dry out between waterings ")
                .font(.custom("Quicksand", size: 15 , relativeTo: .footnote ))
                .frame(maxWidth: .infinity)
        } }, title: "Watering",
                 icon: "drop.circle.fill",
                 iconColor: .cyan)
    .padding()
}
