import SwiftUI

struct ThemeToggleModifier: ViewModifier {
    @EnvironmentObject var themeManager: ThemeManager
    // EnvironmentObject è una proprietà speciale in SwiftUI che consente di condividere dati a livello di applicazione in modo semplice e reattivo tra diverse viste.

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        themeManager.isDarkMode.toggle()
                    }) {
                        Image(systemName: themeManager.isDarkMode ? "sun.max.fill" : "moon.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(themeManager.buttonColor)
                    }
                }
            }
    }
}

extension View {
    func withThemeToggle() -> some View {
        self.modifier(ThemeToggleModifier())
    }
}
