//
//  Instructions.swift
//  PlanTio
//
//  Created by izabour Azevedo on 24/06/24.
//
import SwiftUI

struct Instructions: View {
    
    @State var contentText: String
    var title: String
    var icon: String
    var iconColor: Color
    
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .symbolRenderingMode(.multicolor)
                .foregroundStyle(iconColor)
                .font(.system(size: 40).bold())
            
            VStack(alignment: .leading, spacing: 5) {
                if contentText.isEmpty /*== true*/ {
                    Text(title) // esse empty deve ser sinalizado também na datailView
                        .font(.custom("Quicksand",
                                      size: 20, relativeTo: .title3))
                        .bold()
                    
                } else {
                    Text(title)
                        .font(.custom("Quicksand",
                                      size: 20, relativeTo: .title3))
                        .bold()
                    
                    Text(contentText)
                        .font(.custom("Quicksand",
                                      size: 15, relativeTo: .footnote))
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(Color("Cards"))
                .shadow(color: Color.shadow.opacity(0.3),
                        radius: 5, x: 0, y: 4)
        )
        
    }
}

#Preview {
    VStack {
        Instructions(contentText: "", title: "Watering", icon: "drop.circle.fill", iconColor: .water) //Ex de como vai ficar vazio dps é só sinalizar
        
        Instructions(contentText: "Even though they're diurnal, orchids benefit from the night for respiration and energy storage.", title: "Sunbathing", icon: "sun.max.fill", iconColor: .sun)
        
        Instructions(contentText: "They go well with pets, but it is advisable to avoid eating them to stop digestive problems.", title: "Safe for Pets", icon: "pawprint.circle.fill", iconColor: .pinkButton)
        
        Instructions(contentText: "Thrive in a blend of bark, wood coal and moss, ensuring optimal drainage and root health.", title: "Best soil", icon: "leaf.circle.fill", iconColor: .soil)
    }
}
