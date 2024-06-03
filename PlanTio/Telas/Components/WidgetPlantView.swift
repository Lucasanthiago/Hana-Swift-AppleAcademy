//
//  WidgetPlantView.swift
//  PlanTio
//
//  Created by Gabriela Azulay Lewin on 28/05/24.
//

import SwiftUI

struct WidgetPlantView: View {
    let imageHana: String
    let text: String
    let sky: String
//    @State var gradientList = [morningGradient,afternoonGradient,eveningGradient,nightGradient]
//
    
    let morningGradient = LinearGradient(
            stops: [
                Gradient.Stop(color: .morningCloudsGradient1, location: 0),
                Gradient.Stop(color: .morningCloudsGradient2, location: 1)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    
    let   afternoonGradient = LinearGradient(
            stops: [
                Gradient.Stop(color: .afternoonSkyGradient1, location: 0),
                Gradient.Stop(color: .afternoonSkyGradient2, location: 1)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    
    
    let   eveningGradient = LinearGradient(
            stops: [
                Gradient.Stop(color: .eveningCloudsGradient1, location: 0),
                Gradient.Stop(color: .eveningCloudsGradient2, location: 0.5),
                Gradient.Stop(color: .eveningCloudsGradient3, location: 1),
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    
    let   nightGradient = LinearGradient(
            stops: [
                Gradient.Stop(color: .nightSkyGradient1, location: 0),
                Gradient.Stop(color: .nightSkyGradient2, location: 1)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    
    
    var body: some View {
        HStack {
            Text(text)
            
                .font(
                    .custom("Quicksand", size: 20, relativeTo: .title3).weight(.bold)
                )
                .foregroundStyle(.white)
            
            Spacer(minLength: 12)
            
            Image(imageHana)
                .resizable()
                .scaledToFit()
                .overlay(alignment: .bottom) {
                    Image(imageHana)
                        .rotationEffect(.degrees(180))
                        .alignmentGuide(.bottom, computeValue: { _ in 0 })
                        .mask {
                            LinearGradient(
                                colors: [.black.opacity(0.3), .clear],
                                startPoint: .top,
                                endPoint: .init(x: 0.5, y: 0.15)
                            )
                            
                        }
                        .accessibilityHidden(true)
                }
                .accessibilityLabel("Hana smiling with her spring colors")
        }
        .padding(16)
        .background {
            Image(sky)
                .resizable()
                .scaledToFill()
        }
        .background {
            eveningGradient
                }
       }
    }


#Preview {
    VStack {
        WidgetPlantView(imageHana: "HanaSpring", text: "Time to water your plants!", sky: "MorningClouds")
            .background(.white)
            .clipShape(.rect(cornerRadius: 21))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.black)
        
        
        WidgetPlantView(imageHana: "HanaSpring", text: "Time to water your plants!", sky: "AfternoonSky")
            .background(.white)
            .clipShape(.rect(cornerRadius: 21))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.black)
        
        WidgetPlantView(imageHana: "HanaSpring", text: "Have you checked your plants today?", sky: "EveningClouds")
            .background(.white)
            .clipShape(.rect(cornerRadius: 21))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.black)
       
        WidgetPlantView(imageHana: "HanaSpringSleeping", text: "See you again tomorrow!", sky: "NightSky")
            .background(.white)
            .clipShape(.rect(cornerRadius: 21))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.black)
    }
}


