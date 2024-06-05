//
//  ColorHelper.swift
//  Cesk Events
//
//  Created by iedstudent on 21/05/24.
//

import SwiftUI

extension Color {
    
    ///Estendiamo la lista di colori
    static let ui = Color.UI()
    
    
    ///Aggiungiamo la lista dei colori custom
    struct UI {
        let buttons = Color("ButtonsColor")
        let lines = Color("GreyLine")
    }
}
