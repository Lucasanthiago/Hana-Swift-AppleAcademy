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
    @AppStorage("plantData") var plantData: Data = Data() {
        didSet {
            plants = (try? JSONDecoder().decode([Plant].self, from: plantData)) ?? []
        }
    }

    init() {
        plants = (try? JSONDecoder().decode([Plant].self, from: plantData)) ?? []
        
    }

    func addPlant(name: String, type: String, wateringTime: Date, sunTime: Date, image: UIImage?) {
        var imageName: String? = nil
        if let image = image {
            imageName = UUID().uuidString + ".jpeg"
            let imagePath = getDocumentsDirectory().appendingPathComponent(imageName!)
            if let jpegData = image.jpegData(compressionQuality: 0.8) {
                try? jpegData.write(to: imagePath)
            }
        }
        
        
        
        //notificacao kaua
                
        
        let timesToWater =  Date.getDaysUntil(date: Calendar.current.date(byAdding: .weekday, value: 1, to: Date())!, startDate: wateringTime, weekdays: [1,2,3,4,5,6,7])
            .map {$0.addingTimeInterval(5)}
        let timesToSunbathing = Date.getDaysUntil(date: Calendar.current.date(byAdding: .weekday, value: 1, to: Date())!, startDate: sunTime, weekdays: [1,2,3,4,5,6,7])
            .map {$0.addingTimeInterval(5)}
        Task { [imageName] in
            if await VMNotificationHandler.shared.authorizationStatus != .denied {
            
           
                
                var ids : [VMNotificationHandler.NotificationIdentifier] = []
                
                for time in timesToWater {
                    //                print(time.formatted(.dateTime.day().hour().minute().second()))
                    //                print(time.timeIntervalSince1970 - Date().timeIntervalSince1970)
                    let notificationID = try await VMNotificationHandler.shared.scheduleNotification(title: "Hora de regar! 💧", body:"\(name) está com sede.", triggerTime:
                            .at(time) /*.after(time.timeIntervalSince1970 - Date().timeIntervalSince1970)*/)
                    ids.append(notificationID)
                    
                }
                
                for time in timesToSunbathing {
                    let notificationID = try await VMNotificationHandler.shared.scheduleNotification(title: "Hora do sol! ☀️", body: "\(name) está precisando de vitamina D!", triggerTime: .at(time))
                    ids.append(notificationID)
                    
                }
                await MainActor.run { [ids] in
                    let newPlant = Plant(name: name, type: type, wateringTime: wateringTime, sunTime: sunTime, imageName: imageName, notificationIDs: ids)
                    plants.append(newPlant)
                    savePlants()
                }
            }
            else {
                let newPlant = Plant(name: name, type: type, wateringTime: wateringTime, sunTime: sunTime, imageName: imageName, notificationIDs: [])
                await MainActor.run {
                    plants.append(newPlant)
                    savePlants()
                }
            }
        }
        
        
    
        
    }


    private func savePlants() {
        plantData = (try? JSONEncoder().encode(plants)) ?? Data()
    }
    
    func callMain(index: Int, ids: [VMNotificationHandler.NotificationIdentifier]) async {
        await MainActor.run {
            plants[index].notificationIDs = ids
            savePlants()
        }
    }

    func updatePlant(updatedPlant: Plant, wateringTime: Date, sunTime: Date) {
        //plants[index].name
        
        if let index = plants.firstIndex(where: { $0.id == updatedPlant.id }) {
            plants[index] = updatedPlant
            Task {
                await VMNotificationHandler.shared.removeNotifications(withIdentifiers:plants[index].notificationIDs, evenIfPending: true)
                await MainActor.run {
                    plants[index].notificationIDs = []
                }
                var ids : [VMNotificationHandler.NotificationIdentifier] = []
                
                let timesToWater =  Date.getDaysUntil(date: Calendar.current.date(byAdding: .weekday, value: 1, to: Date())!, startDate: wateringTime, weekdays: [1,2,3,4,5,6,7])
                    .map {$0.addingTimeInterval(5)}
                let timesToSunbathing = Date.getDaysUntil(date: Calendar.current.date(byAdding: .weekday, value: 1, to: Date())!, startDate: sunTime, weekdays: [1,2,3,4,5,6,7])
                    .map {$0.addingTimeInterval(5)}
               
                for time in timesToWater {
                    let notificationID = try await VMNotificationHandler.shared.scheduleNotification(title: "Hora de regar! 💧", body:" \(plants[index].name) está com sede.", triggerTime: .at(time))
                    ids.append(notificationID)
                    
                }
                
                for time in timesToSunbathing {
                    let notificationID = try await VMNotificationHandler.shared.scheduleNotification(title: "Hora do sol! ☀️", body: "\(plants[index].name) está precisando de vitamina D!", triggerTime: .at(time))
                    ids.append(notificationID)
                    
                }
                await callMain(index: index, ids: ids)

            }
        }
    }
    
    func removePlant(at offsets: IndexSet) {
        guard let firstIndex = offsets.first else {
            return
        }
        
        // Acesse a planta antes de removê-la
        let plantToRemove = plants[firstIndex]
        Task {
            await VMNotificationHandler.shared.removeNotifications(withIdentifiers:plantToRemove.notificationIDs, evenIfPending: true)
            await MainActor.run {
                plants.remove(atOffsets: offsets)
                savePlants()
            }
        }
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

}
extension Date{
    static func getDaysUntil(date endDate: Date, startDate: Date, weekdays:[Int]) -> [Date]{
        var currentDate = startDate
        var dates: [Date] = []
        
        while currentDate < endDate{
            let weekday = Calendar.current.component(.weekday, from: currentDate)
            if weekdays.contains(weekday) {
                dates.append(currentDate)
            }
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }
        return dates
    }
}
