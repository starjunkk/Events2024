//
//  PrimaryTextFieldStyle.swift
//  Cesk Events
//
//  Created by iedstudent on 04/06/24.
//

import SwiftUI

struct PrimaryTextFieldStyle: TextFieldStyle {
    func _body(configuration : TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.ui.lines, lineWidth: 0.5)
            }
    }
}

