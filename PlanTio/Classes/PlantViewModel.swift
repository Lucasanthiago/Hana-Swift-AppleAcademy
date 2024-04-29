//
//  PlantViewModel.swift
//  PlanTio
//
//  Created by Lucas Santos on 29/04/24.
//

import Foundation
import SwiftUI


class PlantViewModel: ObservableObject {
    @Published var plants: [Plant] = []
    @AppStorage("plantData") var plantData: Data = Data() {
        didSet {
            plants = (try? JSONDecoder().decode([Plant].self, from: plantData)) ?? []
        }
    }

    init() {
        plants = (try? JSONDecoder().decode([Plant].self, from: plantData)) ?? []
    }

    func addPlant(name: String, type: String, wateringTime: Date, sunTime: Date) {
        let newPlant = Plant(name: name, type: type, wateringTime: wateringTime, sunTime: sunTime)
        plants.append(newPlant)
        savePlants()
    }

    private func savePlants() {
        plantData = (try? JSONEncoder().encode(plants)) ?? Data()
    }

    func updatePlant(updatedPlant: Plant) {
        if let index = plants.firstIndex(where: { $0.id == updatedPlant.id }) {
            plants[index] = updatedPlant
            savePlants()
        }
    }
    
    func removePlant(at offsets: IndexSet) {
            plants.remove(atOffsets: offsets)
            savePlants()
        }
}
