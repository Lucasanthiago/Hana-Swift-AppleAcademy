//
//  ListPlantCard.swift
//  PlanTio
//
//  Created by Lucas Santos on 15/05/24.
//

//
//  PlantListCard.swift
//  PlanTio
//
//  Created by Gabriela Azulay Lewin on 15/05/24.
//

import SwiftUI

struct ListPlantCard<Content: View>: View {
    @ViewBuilder let content: Content
    var plantName: String
    var plantSpecies: String
    
    
    
    var body: some View {
        HStack {
            VStack (alignment: .leading){
                Text(plantName)
                    .font(.custom("Quicksand", size: 22))
                    .bold()
                    .foregroundStyle(Color("NormalText"))
                Text(plantSpecies)
                    .font(.custom("Quicksand", size: 17))
                    .foregroundStyle(Color("NormalText"))
            }
            Spacer()
        }
        .padding(30)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(Color("Cards"))
                .shadow(color: .shadow.opacity(0.3), radius: 5, x: 0, y: 4))
    }
}

#Preview {
    ListPlantCard (content: {
    }, plantName: "Pedro Gomes", plantSpecies: "Cactus")
}
