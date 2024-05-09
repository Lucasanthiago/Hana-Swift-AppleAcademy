//
//  Plant.swift
//  PlanTio
//
//  Created by Lucas Santos on 29/04/24.
//

import Foundation
import VMNotificationHandler

struct Plant: Codable, Identifiable {
    let id = UUID()
    var name: String
    var type: String
    var wateringTime: Date
    var sunTime: Date
    var imageName: String? // Nome do arquivo da imagem local
    var notificationIDs : [VMNotificationHandler.NotificationIdentifier] = []
    var watered: Bool = false
    var sunbathed: Bool = false
    //     adicionar um id de notificação para conseguir apagar aqls que forem adicionadas
}
