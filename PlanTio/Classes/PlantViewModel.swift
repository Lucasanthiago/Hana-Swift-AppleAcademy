//
//  PlantViewModel.swift
//  PlanTio
//
//  Created by Lucas Santos on 29/04/24.
//

import Foundation
import SwiftUI
import VMNotificationHandler
import PostHog

class PlantViewModel: ObservableObject {
    @Published var plants: [Plant] = []
    @Published var commonNames: [String] = []
    @AppStorage("plantData") var plantData: Data = Data() {
        didSet {
            plants = (try? JSONDecoder().decode([Plant].self, from: plantData)) ?? []
        }
    }

    init() {
        plants = (try? JSONDecoder().decode([Plant].self, from: plantData)) ?? []
        loadCommonNames()
    }
    
    func loadCommonNames() {
        guard let url = Bundle.main.url(forResource: "InfoPlants", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("Failed to load JSON")
            return
        }

        do {
            let decodedData = try JSONDecoder().decode([Welcome].self, from: data)
            let allCommonNames = decodedData.flatMap { $0.common }
            self.commonNames = Set(allCommonNames).sorted()
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
    
    func fiteredPlants(by searchText: String) -> [Plant] {
        if searchText.count < 1 { return plants }
        PostHogSDK.shared.capture("Newplant")
        return plants.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    func save(plant: Plant) async throws {
        await savePlants(appending: plant)
        await clearNotification(for: plant)

        guard await VMNotificationHandler.shared.authorizationStatus != .denied else { return }
        
        let wateringTimeMsg = "Hora de regar! 💧"
        let wateringTimeBody = "\(plant.name) está com sede."

        let sunbathTimeMsg = "Hora do sol! ☀️"
        let sunbathTimeBody = "\(plant.name) está precisando de vitamina D!"

        for index in 0..<plant.timesToWater.count {
            if index < plant.waterNotificationIDs.count && index < plant.timesToSunbathing.count && index < plant.SunNotificationIDs.count {
                let _ = try await VMNotificationHandler.shared.scheduleNotification(
                    identifier: plant.waterNotificationIDs[index],
                    title: wateringTimeMsg,
                    body: wateringTimeBody,
                    triggerTime: .at(plant.timesToWater[index])
                )

                let _ = try await VMNotificationHandler.shared.scheduleNotification(
                    identifier: plant.SunNotificationIDs[index],
                    title: sunbathTimeMsg,
                    body: sunbathTimeBody,
                    triggerTime: .at(plant.timesToSunbathing[index])
                )
            }
        }
    }

    func addPlant(_ newPlant: Plant) async {
        await savePlants(appending: newPlant)
    }

    private func savePlants(appending plant: Plant? = nil) async {
        await MainActor.run {
            if let plant {
                if let index = plants.firstIndex(where: { $0.id == plant.id }) {
                    plants[index] = plant
                } else {
                    plants.append(plant)
                }
            }
            plantData = (try? JSONEncoder().encode(plants)) ?? Data()
        }
    }

    func removePlant(at offsets: IndexSet) {
        guard let firstIndex = offsets.first, firstIndex < plants.count else { return }
        
        let plantToRemove = plants[firstIndex]
        Task {
            await clearNotification(for: plantToRemove)
            await MainActor.run {
                plants.remove(atOffsets: offsets)
                Task {
                    await savePlants()
                }
            }
        }
    }
    
    func clearNotification(for plant: Plant) async {
        await VMNotificationHandler.shared.removeNotifications(withIdentifiers: plant.notificationIDs, evenIfPending: true)
    }

    func toggleNotifications(for plant: Plant, isEnabled: Bool) async {
        if isEnabled {
            do {
                try await save(plant: plant) // Reagendar notificações
            } catch {
                print("Error enabling notifications: \(error)")
            }
        } else {
            await clearNotification(for: plant)
        }
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func loadPlants() {
        guard let url = Bundle.main.url(forResource: "InfoPlants", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("Falha ao carregar o arquivo JSON")
            return
        }
        
        let decoder = JSONDecoder()
        if let jsonData = try? decoder.decode([Plant].self, from: data) {
            self.plants = jsonData
        }
    }
    
    func getCommons() {
        guard let url = Bundle.main.url(forResource: "InfoPlants", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("Falha ao carregar o arquivo JSON")
            return
        }
        
        let decoder = JSONDecoder()
        if let plants = try? decoder.decode([Welcome].self, from: data) {
            print(plants.flatMap { $0.common })
        }
    }
}
