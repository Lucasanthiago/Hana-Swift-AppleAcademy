//
//  WateringView.swift
//  PlanTio
//
//  Created by Lucas Santos on 29/04/24.
//

import SwiftUI

struct WateringView: View {
    @ObservedObject var viewModel: PlantViewModel

    var body: some View {
        List {
            ForEach(viewModel.plants) { plant in
                Section(header: Text(plant.name)) {
                    AlarmView(plant: plant, type: .watering)
                }
            }
        }
        .navigationBarTitle("Regar Plantas")
    }
}


