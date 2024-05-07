//
//  ContentView.swift
//  Events2024
//
//  Created by iedstudent on 07/05/24.
//

import SwiftUI

struct SplashView: View {
    
    @State var isAnimating = false
    @State var isAnimationDone = false
    
    var body: some View {
        VStack {
            if isAnimationDone == false {
                ZStack {
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                    .font(.largeTitle).bold()
                    .scaleEffect(isAnimating ? 1 : 10)
                    .opacity(isAnimating ? 1 : 0)
            }
            .onAppear{
                withAnimation(.bouncy(duration: 1)){
                    self.isAnimating = true
                }
                Task {
                    try? await Task.sleep(nanoseconds: 10_000_000_00)
                    
                    // Animazione completata, vado alla home
                    
                    self.isAnimationDone = true
                }
        }
            } else {
                EventsView()
            }
        }
    }
}

//Metti fade a fine animazione

#Preview {
    SplashView()
}
