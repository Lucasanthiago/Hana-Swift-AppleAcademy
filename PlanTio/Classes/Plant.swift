import Foundation
import VMNotificationHandler

struct Plant: Codable, Identifiable, Hashable {
    static let weekDays = [1, 2, 3, 4, 5, 6, 7]
    
    var id = UUID()
    var name: String
    var type: String
    var wateringTime: Date
    var sunTime: Date
    
    var waterNotificationIDs : [VMNotificationHandler.NotificationIdentifier] { Self.weekDays.map{id.uuidString+"_\($0)W"} }
    var SunNotificationIDs   : [VMNotificationHandler.NotificationIdentifier] { Self.weekDays.map{id.uuidString+"_\($0)S"} }
    var notificationIDs      : [VMNotificationHandler.NotificationIdentifier] {waterNotificationIDs + SunNotificationIDs}
 
    var watered: Bool = false
    var sunbathed: Bool = false
    var imageData:Data?
    var descriptionPlant: String
    var bestSoilDescription: String
    var weatherDescription: String
    var poisonDescription: String
    var wateringDescription: String
    var sunbathingDescription: String
    var safeForPetDescription: String
    var potSizeDescription: String
    
    var timesToWater:[Date] { Date.weekTimes(for: wateringTime, weekdays: Self.weekDays) }
    var timesToSunbathing:[Date] { Date.weekTimes(for: sunTime, weekdays: Self.weekDays) }
}
