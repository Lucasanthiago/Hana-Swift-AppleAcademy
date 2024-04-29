//
//  AlarmView.swift
//  PlanTio
//
//  Created by Lucas Santos on 29/04/24.
//

import SwiftUI

struct AlarmView: View {
    var plant: Plant
    var type: AlarmType

    var body: some View {
        HStack {
            Image(systemName: type == .watering ? "drop.circle.fill" : "sun.max.fill")
                .foregroundColor(type == .watering ? .blue : .yellow)
            VStack(alignment: .leading) {
                Text(type == .watering ? "Regar" : "Tomar Sol")
                Text("\(type == .watering ? plant.wateringTime : plant.sunTime, formatter: dateFormatter)")
                    .font(.subheadline)
            }
        }
    }
}

enum AlarmType {
    case watering, sunlight
}
