//
//  Plant.swift
//  PlanTio
//
//  Created by Lucas Santos on 29/04/24.
//

import Foundation
import VMNotificationHandler

struct Plant: Codable, Identifiable {
    static let weekDays = [1,2,3,4,5,6,7]
    
    var id = UUID()
    var name: String
    var type: String
    var wateringTime: Date
    var sunTime: Date
//    var imageName:String {id.uuidString + ".jpeg"} // Nome do arquivo da imagem local
    var waterNotificationIDs : [VMNotificationHandler.NotificationIdentifier] { Self.weekDays.map{id.uuidString+"_\($0)W"} }
    var SunNotificationIDs   : [VMNotificationHandler.NotificationIdentifier] { Self.weekDays.map{id.uuidString+"_\($0)S"} }
    var notificationIDs      : [VMNotificationHandler.NotificationIdentifier] {waterNotificationIDs + SunNotificationIDs}
    var watered: Bool = false
    var sunbathed: Bool = false
    var imageData:Data?
    //     adicionar um id de notificação para conseguir apagar aqls que forem adicionadas
    
    
    var timesToWater:[Date] { Date.weekTimes(for: wateringTime, weekdays: Self.weekDays) }
    var timesToSunbathing:[Date] { Date.weekTimes(for: sunTime, weekdays: Self.weekDays) }
    

}
