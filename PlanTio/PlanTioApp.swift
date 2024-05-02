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
//                    try! await VMNotificationHandler.shared.scheduleNotification(title: "PLANTA", triggerTime: .at(Date()))
                }
            
        }
    }
}


//testando commit
