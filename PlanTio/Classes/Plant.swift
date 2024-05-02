//
//  Plant.swift
//  PlanTio
//
//  Created by Lucas Santos on 29/04/24.
//

import Foundation


struct Plant: Codable, Identifiable {
    let id = UUID()
    var name: String
    var type: String
    var wateringTime: Date  // Horário específico para regar
    var sunTime: Date       // Horário específico para tomar sol
    // criar um notificationId
}
