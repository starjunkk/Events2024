import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    @EnvironmentObject var themeManager: ThemeManager
    
    var foreground = Color.white
    var cornerRadius: CGFloat = 20
    var shadowRadius: CGFloat = 10
    var width: CGFloat? = nil

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: width)
            .padding()
            .foregroundColor(foreground)
            .background(themeManager.buttonColor)
            .cornerRadius(cornerRadius)
            .shadow(color: Color.black.opacity(0.1), radius: shadowRadius, x: 0, y: 5)
            .scaleEffect(configuration.isPressed ? 0.90 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
