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
                    
                    DatePicker("Watering Time", selection: $date, displayedComponents: [.hourAndMinute])
                        .background {
                            iconColor.opacity(1).saturation(1.8)
                                .clipShape(.rect(cornerRadius: 8))
                        }
                        .environment(\.colorScheme, .dark)
                        
//                        .overlay {
//                            Color.white
//                                .clipShape(.rect(cornerRadius: 9))
//                                .blendMode(.exclusion)
//                            Color.white
//                                .clipShape(.rect(cornerRadius: 9))
//                                .blendMode(.colorDodge)
//                        }
//                        .colorInvert()
                    
                    .labelsHidden()
                    .fixedSize()
                    
                    
                }
                Divider()
            }
            content
        }
        .padding()
        .background(
        RoundedRectangle(cornerRadius: 20)
            .foregroundStyle(.white)
            .shadow(color: Color(white: 0.2).opacity(0.5), radius: 8)
        )
    }
    
}

#Preview {
    VStack {
        CareInfos(content: {
            Text("Keep moist between watering. Can be a bit dry between waterings.")
                .padding()
                   .font(.subheadline)
                   .lineLimit(2)
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
