import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            EventsView()
                .tabItem {
                    Label("Eventi", systemImage: "calendar")
                }
            
            CartView()
                .tabItem {
                    Label("Carrello", systemImage: "cart.fill")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profilo", systemImage: "person.fill")
                }
        }
    }
}

#Preview {
    MainView()
        .environmentObject(ThemeManager())
}
