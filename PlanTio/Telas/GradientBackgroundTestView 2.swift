//
//  GradientBackgroundTestView.swift
//  PlanTio
//
//  Created by Gabriela Azulay Lewin on 19/06/24.
//

import SwiftUI

struct GradientBackgroundTestView: View {
    var body: some View {
        LinearGradient(
            stops: [
                Gradient.Stop(color: .hanaPlusGradient1, location: -0.3),
                Gradient.Stop(color: .hanaPlusGradient2, location: 0.56),
                Gradient.Stop(color: .hanaPlusGradient3, location: 1.4)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

#Preview {
    GradientBackgroundTestView()
}
