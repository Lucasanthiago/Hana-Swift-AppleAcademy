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
                .foregroundColor(type == .watering ? .cyan : .orange)
                .font(.title3)
            VStack(alignment: .leading) {
//                Text(type == .watering ? "Regar" : "Tomar Sol")
                Text(plant.name)
                    .font(.title3).bold()
                Text("\(type == .watering ? plant.wateringTime : plant.sunTime, formatter: dateFormatter)")
            }
        }
    }
}

enum AlarmType {
    case watering, sunlight
}
