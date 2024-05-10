//
//  PlantViewModel.swift
//  PlanTio
//
//  Created by Lucas Santos on 29/04/24.
//

import Foundation
import SwiftUI
import VMNotificationHandler


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
            // Flatten all common names and remove duplicates
            let allCommonNames = decodedData.flatMap { $0.common }
            self.commonNames = Set(allCommonNames).sorted()  // Convert to Set to remove duplicates, then back to Array
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
    
    func fiteredPlants(by searchText: String)-> [Plant] {
        if searchText.count < 3 {return plants}
        return plants.filter({$0.name.localizedCaseInsensitiveContains(searchText)})
    }
    
    func save(plant:Plant) async throws {
        await savePlants(appending: plant)
        await clearNotification(for: plant)

        guard await VMNotificationHandler.shared.authorizationStatus != .denied else { return }
        
        let wateringTimeMsg = "Hora de regar! 💧"
        let wateringTimeBody = "\(plant.name) está com sede."

        let sunbathTimeMsg = "Hora do sol! ☀️"
        let sunbathTimeBody = "\(plant.name) está precisando de vitamina D!"

        for index in 0..<plant.timesToWater.count {
            let _ = try await VMNotificationHandler.shared.scheduleNotification(
                identifier: plant.waterNotificationIDs[index],
                title: wateringTimeMsg,
                body: wateringTimeBody,
                triggerTime: .at(plant.timesToWater[index]))

            let _ = try await VMNotificationHandler.shared.scheduleNotification(
                identifier: plant.SunNotificationIDs[index],
                title: sunbathTimeMsg,
                body: sunbathTimeBody,
                triggerTime: .at(plant.timesToSunbathing[index]))

        }
    }

    private func savePlants(appending plant:Plant? = nil) async {
        
        await MainActor.run{
            if let plant {
                
                
                if let index = plants.firstIndex(where: {$0.id == plant.id}) {
                    plants[index] = plant
                    
                } else {
                    plants.append(plant)
                }
            }
            
            plantData = (try? JSONEncoder().encode(plants)) ?? Data()
        }
        
    }
    
//    func callMain(index: Int, ids: [VMNotificationHandler.NotificationIdentifier]) async {
//        await MainActor.run {
//            
//            savePlants()
//        }
//    }

//    func updatePlant(updatedPlant: Plant, wateringTime: Date, sunTime: Date) {
//        //plants[index].name
//        
//        if let index = plants.firstIndex(where: { $0.id == updatedPlant.id }) {
//            plants[index] = updatedPlant
//            Task {
//                await VMNotificationHandler.shared.removeNotifications(withIdentifiers:plants[index].notificationIDs, evenIfPending: true)
//                await MainActor.run {
//                    plants[index].notificationIDs = []
//                }
//                var ids : [VMNotificationHandler.NotificationIdentifier] = []
//                
//                let timesToWater =  Date.getDaysUntil(date: Calendar.current.date(byAdding: .weekday, value: 1, to: Date())!, startDate: wateringTime, weekdays: [1,2,3,4,5,6,7])
//                    .map {$0.addingTimeInterval(5)}
//                let timesToSunbathing = Date.getDaysUntil(date: Calendar.current.date(byAdding: .weekday, value: 1, to: Date())!, startDate: sunTime, weekdays: [1,2,3,4,5,6,7])
//                    .map {$0.addingTimeInterval(5)}
//               
//                for time in timesToWater {
//                    let notificationID = try await VMNotificationHandler.shared.scheduleNotification(title: "Hora de regar! 💧", body:" \(plants[index].name) está com sede.", triggerTime: .at(time))
//                    ids.append(notificationID)
//                    
//                }
//                
//                for time in timesToSunbathing {
//                    let notificationID = try await VMNotificationHandler.shared.scheduleNotification(title: "Hora do sol! ☀️", body: "\(plants[index].name) está precisando de vitamina D!", triggerTime: .at(time))
//                    ids.append(notificationID)
//                    
//                }
//                await callMain(index: index, ids: ids)
//
//            }
//        }
//    }
    
    func removePlant(at offsets: IndexSet) {
        guard let firstIndex = offsets.first else { return }
        
        // Acesse a planta antes de removê-la
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
        
    
    func clearNotification(for plant:Plant) async {
        await VMNotificationHandler.shared.removeNotifications(withIdentifiers:plant.notificationIDs, evenIfPending: true)
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
                print(plants.flatMap {$0.common})
                
            }
        }

}

