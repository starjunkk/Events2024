//
//  HomeView.swift
//  Cesk Events
//
//  Created by iedstudent on 04/06/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView {
            EventsView()
                .tabItem {
                    Label("Eventi", systemImage: "calendar")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profilo", systemImage: "person.fill")
                }
        }
    }
}

#Preview {
    HomeView()
}
