//
//  PrimaryButtonStyle.swift
//  Cesk Events
//
//  Created by iedstudent on 04/06/24.
//

import SwiftUI



struct PrimaryButtonStyle: ButtonStyle {
    // MARK: - Variabili
    
    var foreground = Color.white
    var background = Color.ui.buttons
    var padding: CGFloat = 16
    var scaleEffect = 0.95
    
    
    // MARK: - Body

    func makeBody(configuration: Configuration) -> some View {

        HStack{

            Spacer()

            configuration.label

            Spacer()

        }

        .bold()

        .foregroundStyle(foreground)

        .padding()

        .background(background)

        .cornerRadius(16)

        .padding(padding)

        .scaleEffect(configuration.isPressed ? 0.97 : 1.0)

        .animation(.easeOut(duration: 0.1), value: configuration.isPressed)

    }

    

}
