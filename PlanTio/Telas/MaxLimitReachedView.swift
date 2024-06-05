//
//  MaxLimitReachedView.swift
//  PlanTio
//
//  Created by Lucas Santos on 05/06/24.
//

import SwiftUI

struct MaxLimitReachedView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                stops: [
                    Gradient.Stop(color: .skyGradient1, location: 0),
                    Gradient.Stop(color: .skyGradient2, location: 0.3)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            Image("SunClouds")
                .resizable()
                .scaledToFit()
                .frame(width:210)
                .padding(.bottom, 580)
                .padding(.leading, 100)
            
            ZStack {
                RoundedRectangle(cornerRadius: 20.0)
                    .foregroundStyle(
                        LinearGradient(
                            stops: [
                                Gradient.Stop(color: .grassGradient1, location: 0),
                                Gradient.Stop(color: .grassGradient2, location: 1)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .overlay(alignment: .top) {
                        ZStack (alignment: .bottom){
                            
                            Image("Grass")
                            
                            Image("SadHana")
                                .background(alignment: .bottom) {
                                    Ellipse()
                                        .frame(width: 120, height: 25.0)
                                        .foregroundStyle(Color.blue.blendMode(.multiply).opacity(0.3))
                                        .alignmentGuide(.bottom, computeValue: { _ in 18 })
                                }
                                .padding(.trailing, 180)
                        }
                        .alignmentGuide(.top, computeValue: {dimension in dimension[.bottom] - 20})
                    }
                    .ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    VStack {
                        VStack(alignment: .leading, spacing: 25) {
                            Text("Maximum Limit Reached")
                                .font(.custom("Quicksand", size: 28, relativeTo: .title))
                                .bold()
                                .foregroundStyle(Color.darkGreen)
                                .colorScheme(.light)
                            
                            Text("You have reached the maximum limit of 17 plants. Consider removing some plants to add new ones.")
                                .font(.custom("Quicksand", size: 20, relativeTo: .title3))
                                .foregroundStyle(Color.lightGreen)
                                .fontWeight(.medium)
                        }
                        .padding(35)
                        .background(
                            RoundedRectangle(cornerRadius: 36)
                                .foregroundStyle(Color.cards)
                                .colorScheme(.light)
                        )
                        .padding(30)
                        
                        Button(action: {
                            // Your action here
                        }, label: {
                            Text("Go back to My Plants")
                                .font(.custom("Quicksand", size: 22, relativeTo: .title2))
                                .bold()
                                .foregroundStyle(Color.white)
                                .padding(20)
                                .padding(.horizontal, 30)
                                .background(
                                    RoundedRectangle(cornerRadius: 30)
                                        .foregroundStyle(Color.pinkButton)
                                        .colorScheme(.light)
                                )
                        })
                    }
                }
            }
            .padding(.top, 270)
        }
    }
}

#Preview {
    MaxLimitReachedView()
}

