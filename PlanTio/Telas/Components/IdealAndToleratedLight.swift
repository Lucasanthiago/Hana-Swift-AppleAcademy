//
//  IdealAndToleratedLight.swift
//  PlanTio
//
//  Created by Lucas Santos on 13/05/24.
//

import SwiftUI

import SwiftUI

struct IdealAndToleratedLight<Content: View>: View {
    @ViewBuilder let content: Content
    var title : String
    var icon : String
    var iconColor : Color
    var description :String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(iconColor)
                Text(title)
                    .font(.custom("Quicksand", size: 15, relativeTo: .subheadline))
                    .bold()
            }
            Text(description)
                .padding(.leading, 27.5)
                .font(.custom("Quicksand", size: 15, relativeTo: .subheadline))
        }
        
    }
}

#Preview {
    VStack {
        HStack {
            IdealAndToleratedLight(content: {
            },title: "Ideal light", icon: "sun.min.fill", iconColor: .black, description: "Bright light")
            .padding()
            HStack {
                IdealAndToleratedLight(content: {
                },title: "Tolerated light", icon: "sun.max.fill", iconColor: .black, description: "Direct sunlight")
            }
        }
    }
}
