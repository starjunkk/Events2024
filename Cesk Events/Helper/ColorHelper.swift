import SwiftUI

extension Color {
    static let ui = Color.UI()
    
    struct UI {
        let buttons = Color("ButtonsColor")
        let lines = Color("GreyLine")
        let aquaGreen = Color(red: 0.0, green: 0.75, blue: 0.75)
        let black = Color(red: 0.0, green: 0.0, blue: 0.0)
        let white = Color(red: 1.0, green: 1.0, blue: 1.0)
        let grey = Color(red: 0.4, green: 0.4, blue: 0.4)
        let orange = Color(red: 1.0, green: 0.5, blue: 0.0) 
    }
}
