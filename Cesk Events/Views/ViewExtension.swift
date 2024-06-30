import SwiftUI

extension View {
    func navigationBarTitleTextColor(_ color: UIColor) -> some View {
        self.modifier(NavigationBarTitleColorModifier(color: color))
    }
}

struct NavigationBarTitleColorModifier: ViewModifier {
    var color: UIColor

    func body(content: Content) -> some View {
        content
            .onAppear {
                let appearance = UINavigationBarAppearance()
                appearance.largeTitleTextAttributes = [.foregroundColor: color]
                appearance.titleTextAttributes = [.foregroundColor: color]
                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
            }
    }
}
