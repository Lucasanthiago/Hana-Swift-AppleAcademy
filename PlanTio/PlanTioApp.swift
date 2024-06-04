//
//  PlanTioApp.swift
//  PlanTio
//
//  Created by Lucas Santos on 29/04/24.
//

import SwiftUI
import VMNotificationHandler
import PostHog

@main
struct PlanTioApp: App {
    
    init(){
        let POSTHOG_API_KEY = "***CHAVE-REMOVIDA***"
        let POSTHOG_HOST = "https://us.i.posthog.com"
        
        let config = PostHogConfig(apiKey: POSTHOG_API_KEY, host: POSTHOG_HOST)
        PostHogSDK.shared.setup(config)
        
    }
    var body : some Scene {
        WindowGroup{
            TabBarView()
        }
        
    }
//    var body: some Scene {
//        WindowGroup {
//            //            TabBarView()
//            WidgetPlantView(imageHana: "HanaSpring", text: "Time to water your plants!", sky: "MorningClouds")
//                .frame(width: 338, height: 158)
//            
//            WidgetPlantView(imageHana: "HanaSpring", text: "Time to water your plants!", sky: "AfternoonSky")
//                .frame(width: 338, height: 158)
//            
//            WidgetPlantView(imageHana: "HanaSpring", text: "Have you checked your plants today?", sky: "EveningClouds")
//                .frame(width: 338, height: 158)
//            
//            WidgetPlantView(imageHana: "HanaSpringSleeping", text: "See you again tomorrow!", sky: "NightSky")
//                .frame(width: 338, height: 158)
//        }
//    }
    
    
    //testando commit
}
