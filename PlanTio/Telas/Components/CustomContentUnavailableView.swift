//
//  CustomContentUnavailableView.swift
//  PlanTio
//
//  Created by Gabriela Azulay Lewin on 08/05/24.
//

import SwiftUI

struct CustomContentUnavailableView: View {
    let iconName:String
    let title:String
    let desciption:String
    let buttonName:String
    let action:()->Void
    
    var body: some View {
        ContentUnavailableView {
            ContentUnavailableView(title, systemImage: iconName,
                                   description: Text("\n"+desciption))
            .padding(.bottom, -20)
            .padding(.horizontal, -15)
        } actions: {
            Button  {
                action()
            } label: {
                Text(buttonName)
                    .foregroundStyle(Color.accentColor)
            }

        }
    }
}

//#Preview {
//    CustomContentUnavailableView()
//}
