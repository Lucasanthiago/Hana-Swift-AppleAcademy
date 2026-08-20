import SwiftUI
import VMNotificationHandler
import PostHog

@main
struct PlanTioApp: App {
    @StateObject private var store = Store.instance
    @StateObject private var viewModel = PlantViewModel.instance
    @State private var showSplashArt = true

    init(){
        let POSTHOG_API_KEY = AppSecrets.postHog
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
//                                print(store.hasPurchasedHanaPlus)
                            }
                        }
                    }
            } else {
//                Host(contentView:
                TabBarView()
//                     )
                    .environmentObject(store)
                    .environmentObject(viewModel)
            }
        }
    }
}
