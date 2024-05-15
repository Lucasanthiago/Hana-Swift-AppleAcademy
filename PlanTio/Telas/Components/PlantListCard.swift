//
//  PlantListCard.swift
//  PlanTio
//
//  Created by Gabriela Azulay Lewin on 15/05/24.
//

import SwiftUI

struct PlantListCard<Content: View>: View {
    @ViewBuilder let content: Content
    var plantName: String
    var plantSpecies: String
    
    
    
    var body: some View {
        HStack {
            VStack (alignment: .leading){
                Text(plantName)
                    .font(.title2)
                    .bold()
                Text(plantSpecies)
            }
            Spacer()
        }
        .padding(30)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.white)
                .shadow(color: Color(white: 0.2).opacity(0.5), radius: 8))
    }
}

#Preview {
    PlantListCard (content: {
    }, plantName: "Pedro Gomes", plantSpecies: "Cactus")
}
