//
//  EventItemView.swift
//  Cesk Events
//
//  Created by iedstudent on 05/06/24.
//

import SwiftUI

struct EventItemView: View {
    
    var event: Event
    
    var isList: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .bottom) {
                NetworkImage(url: event.coverUrl)
                    .frame(height: isList ? 300 : 150)
                    .clipped()
                    .cornerRadius(8)
                
              
                Rectangle()
                    .fill(Color.black.opacity(0.5))
                    .frame(height: 40)
                    .overlay(
                        Text(event.name ?? "")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8),
                        alignment: .leading
                    )
            }
        }
        .padding(.horizontal, 8)
        .contentShape(Rectangle())
    }
}

#Preview {
    EventItemView(event: Event(name: "Ciao"), isList: true)
}
