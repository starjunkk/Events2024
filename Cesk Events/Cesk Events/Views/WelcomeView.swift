//
//  WelcomeView.swift
//  Cesk Events
//
//  Created by iedstudent on 21/05/24.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationView{
            VStack{
                Circle()
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
                    .padding(.bottom, 80)
                Text("Benvenuto")
                    .bold()
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                NavigationLink(destination: LoginView()) {
                    HStack{
                        Spacer()
                        Text("Accedi")
                        Spacer()
                    }
                    .bold()
                    .foregroundStyle(.white)
                    .padding()
                    .background(Color.ui.buttons)
                    .cornerRadius(8)
                    .padding()
                }
            }
        }
        
    }
}

#Preview {
    NavigationView{
        WelcomeView()
    }
}
