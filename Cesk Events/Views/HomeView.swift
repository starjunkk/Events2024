import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView {
            EventsView()
                .withThemeToggle()
                .tabItem {
                    Label("Eventi", systemImage: "calendar")
                }
            
            CartView()
                .withThemeToggle()
                .tabItem {
                    Label("Carrello", systemImage: "cart.fill")
                }
            
            ProfileView()
                .withThemeToggle()
                .tabItem {
                    Label("Profilo", systemImage: "person.fill")
                }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(Session.shared)
        .environmentObject(ThemeManager())
}
