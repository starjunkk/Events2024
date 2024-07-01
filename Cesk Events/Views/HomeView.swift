import SwiftUI

struct HomeView: View {
    @EnvironmentObject var themeManager: ThemeManager

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
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(themeManager.backgroundColor)
            
            let normalColor = UIColor(themeManager.isDarkMode ? Color.ui.grey : Color.ui.black)
            let selectedColor = UIColor(themeManager.isDarkMode ? Color.ui.aquaGreen : Color.ui.orange)
            
            appearance.stackedLayoutAppearance.normal.iconColor = normalColor
            appearance.stackedLayoutAppearance.selected.iconColor = selectedColor
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: normalColor]
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: selectedColor]
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
            
            
            for item in UITabBar.appearance().items ?? [] {
                item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -4)
                item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(Session.shared)
        .environmentObject(ThemeManager())
}
