//
//  Plant.swift
//  PlanTio
//
//  Created by Lucas Santos on 29/04/24.
//


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
    var imageData: Data?
    var wateringInstructions: String // Fetched from API
    var idealLight: String // Fetched from API
    var toleratedLight: String // Fetched from API
    
    // New variables to store additional plant info
    var safeForPets: String // Fetched from API
    var bestSoil: String // Fetched from API
    var sunbathing: String // Fetched from API
    var weather: String // Fetched from API
    var potSize: String // Fetched from API
    var poison: String // Fetched from API

    var timesToWater: [Date] { Date.weekTimes(for: wateringTime, weekdays: Self.weekDays) }
    var timesToSunbathing: [Date] { Date.weekTimes(for: sunTime, weekdays: Self.weekDays) }
}
