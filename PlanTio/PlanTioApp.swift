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
    
    var body: some Scene {
        WindowGroup {
            TabBarView()
        
            
            
        }
    }
}


//testando commit
