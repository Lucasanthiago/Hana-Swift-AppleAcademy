import SwiftUI
import VMNotificationHandler
import PostHog

@main
struct PlanTioApp: App {
    @StateObject private var store = Store()
    @StateObject private var viewModel = PlantViewModel()
    @State private var showSplashArt = true

    init(){
        let POSTHOG_API_KEY = "***CHAVE-REMOVIDA***"
        let POSTHOG_HOST = "https://us.i.posthog.com"
        
        let config = PostHogConfig(apiKey: POSTHOG_API_KEY, host: POSTHOG_HOST)
        PostHogSDK.shared.setup(config)
    }

    var body: some Scene {
        WindowGroup {
            if showSplashArt {
                SplashArtView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                            withAnimation {
                                showSplashArt = false
                            }
                        }
                    }
            } else {
                TabBarView()
                    .environmentObject(store)
                    .environmentObject(viewModel)
            }
        }
    }
}
