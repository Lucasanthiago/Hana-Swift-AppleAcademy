//
//  PlanTioApp.swift
//  PlanTio
//
//  Created by Lucas Santos on 29/04/24.
//

import SwiftUI
import VMNotificationHandler


@main
struct PlanTioApp: App {
    
    var body: some Scene {
        WindowGroup {
            TabBarView()
                .task{
                    await VMNotificationHandler.shared.requestAuthorization()
                    try! await VMNotificationHandler.shared.scheduleNotification(title: "Hora de regar!", subtitle: "Pedro Gomes está com sede", triggerTime: .now)
//                    try! await VMNotificationHandler.shared.scheduleNotification(title: "Hora do sol!", subtitle: "Pedro Gomes está precisando de vitamina D!", triggerTime: .now)
                }
            
        }
    }
}


//testando commit
