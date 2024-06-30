import SwiftUI

@main
struct Cesk_EventsApp: App {
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var session = Session.shared
    
    var body: some Scene {
        WindowGroup {
            SplashView()
                .environmentObject(themeManager)
                .environmentObject(session)
        }
    }
}
