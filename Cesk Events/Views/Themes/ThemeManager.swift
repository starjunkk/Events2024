import SwiftUI

class ThemeManager: ObservableObject {
    @Published var isDarkMode: Bool = false
    
    var buttonColor: Color {
        return isDarkMode ? Color.ui.aquaGreen : Color.orange
    }
    
    var textColor: Color {
        return isDarkMode ? Color.white : Color.black
    }
    
    var backgroundColor: Color {
        return isDarkMode ? Color.black : Color(uiColor: .systemGray6)
    }
    
    var textFieldBackgroundColor: Color {
        return isDarkMode ? Color.black : Color.white
    }
    
    var textFieldBorderColor: Color {
        return isDarkMode ? Color.white : Color.gray
    }
    
    var textFieldTextColor: Color {
        return isDarkMode ? Color.white : Color.black
    }
    
    var textFieldPlaceholderColor: Color {
        return isDarkMode ? Color.gray : Color(uiColor: .lightGray)
    }
    
    var navigationTitleColor: UIColor {
        return isDarkMode ? .white : .black
    }
}
