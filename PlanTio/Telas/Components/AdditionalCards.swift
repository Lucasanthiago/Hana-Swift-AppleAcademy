//
//  AdditionalCards.swift
//  PlanTio
//
//  Created by izabour Azevedo on 27/06/24.
//

import SwiftUI

struct AdditionalCards: View {
    
    @State var contentText: String
    var title: String
    var icon: String
    
    var body: some View {
        HStack {
            Image(icon)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.custom("Quicksand", size: 20, relativeTo: .title3))
                    .bold()
                
                if !contentText.isEmpty {
                    Text(contentText)
                        .font(.custom("Quicksand", size: 15, relativeTo: .footnote))
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(Color("Cards"))
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 4)
        )
    }
}

struct AdditionalCards_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            AdditionalCards(
                contentText: "",
                title: "Weather",
                icon: "Weather"
            )
            AdditionalCards(
                contentText: "An ideal weather zone for an orchid is typically warm to mild, with good air and moderate humidity.",
                title: "Weather",
                icon: "Weather"
            )
        }
    }
}
