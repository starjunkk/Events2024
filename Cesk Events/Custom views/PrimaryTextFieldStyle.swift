import SwiftUI

struct PrimaryTextFieldStyle: TextFieldStyle {
    @EnvironmentObject var themeManager: ThemeManager
    
    var cornerRadius: CGFloat = 10
    var shadowRadius: CGFloat = 5

    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(themeManager.textFieldBackgroundColor)
            .cornerRadius(cornerRadius)
            .shadow(color: Color.black.opacity(0.1), radius: shadowRadius, x: 0, y: 3)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(themeManager.textFieldBorderColor, lineWidth: 1)
            )
            .foregroundColor(themeManager.textFieldTextColor)
    }
}
