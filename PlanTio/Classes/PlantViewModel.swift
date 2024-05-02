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
        let newPlant = Plant(name: name, type: type, wateringTime: wateringTime, sunTime: sunTime, imageName: imageName)
        plants.append(newPlant)
        savePlants()
        
        
        //notificacao kaua
                
        
        let timesToWater =  Date.getDaysUntil(date: Calendar.current.date(byAdding: .year, value: 1, to: Date())!, startDate: wateringTime, weekdays: [1,2,3,4,5,6,7])
        let timesToSunbathing = Date.getDaysUntil(date: Calendar.current.date(byAdding: .year, value: 1, to: Date())!, startDate: sunTime, weekdays: [1,2,3,4,5,6,7])
        
//        Task {
//            try await VMNotificationHandler.shared.removeNotifications(withIdentifiers: <#T##[String]#>)
//
//            let x = try await VMNotificationHandler.shared.scheduleNotification(identifier:title:subtitle:body:silenced:triggerTime:repeats:userInfo:)
//        }
        
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
