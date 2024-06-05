//
//  PrimaryButtonStyle.swift
//  Cesk Events
//
//  Created by iedstudent on 04/06/24.
//

import SwiftUI



struct PrimaryButtonStyle: ButtonStyle {

    func makeBody(configuration: Configuration) -> some View {

        HStack{

            Spacer()

            configuration.label

            Spacer()

        }

        .bold()

        .foregroundStyle(.white)

        .padding()

        .background(Color.ui.buttons)

        .cornerRadius(16)

        .padding()

        .scaleEffect(configuration.isPressed ? 0.97 : 1.0)

        .animation(.easeOut(duration: 0.1), value: configuration.isPressed)

    }

    

}
