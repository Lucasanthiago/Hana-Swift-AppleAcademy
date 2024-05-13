//
//  CareInfos.swift
//  PlanTio
//
//  Created by Lucas Santos on 13/05/24.
//

import SwiftUI

struct CareInfos<Content: View>: View {
    
    @ViewBuilder let content: Content
    var title : String
    var icon : String
    var iconColor : Color
    @State var date : Date
    
    
    var body: some View {
        VStack {
            VStack {
                HStack{
                    Image(systemName: icon)
                        .padding(.leading)
                        .foregroundStyle(iconColor)
                    Text(title)
                    
                        .font(.title3)
                        .bold()
                    Spacer()
                    
                    DatePicker("", selection: Binding(get: {
                        date
                    }, set: { date in
                        self.date = date
                    }), displayedComponents: [.hourAndMinute])
                    
                }
                Divider()
            }
            content
        }
        .padding()
        .background(
        RoundedRectangle(cornerRadius: 20)
            .foregroundStyle(.white)
            .shadow(radius: 20)
        )
    }
    
}

#Preview {
    VStack {
        CareInfos(content: {
            Text("Keep moist between watering.\nCan be a bit dry between waterings.")
                .padding()
                   .font(.subheadline)
                   .lineLimit(1)
        }, title: "Watering", icon: "drop.circle.fill", iconColor: .cyan, date: Date())
        
        .padding(.vertical)
        CareInfos(content: {
            HStack {
                IdealAndToleratedLight(content: {
                },title: "Ideal light", icon: "sun.min.fill", iconColor: .black, description: "Bright light")
                .padding()
                HStack {
                    IdealAndToleratedLight(content: {
                    },title: "Tolerated light", icon: "sun.max.fill", iconColor: .black, description: "Direct sunlight")
                }
                .padding(.trailing, 50)
                .padding(10)
            }
        }, title: "Sunbathing", icon: "sun.max.fill", iconColor: .orange, date: Date())
    }
    
}
