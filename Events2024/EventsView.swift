//
//  EventsView.swift
//  Events2024
//
//  Created by  on 07/05/24.
//

import SwiftUI
import DBNetworking

struct EventsView: View {
    
    @State var isList = true
    
    @State var eventsToShow: [Event] = [
    ]
    
    
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: isList ? 300 : 150))
                ], spacing: 16)
                    {
                    
                    ForEach(self.eventsToShow) {
                        event in
                        
                        //UI di ogni elemento
                        VStack {
                            NetworkImage(url: event.coverUrl)
                                .frame(height: 100)
                                .clipped()
                                .padding(EdgeInsets())
                            Text(event.name ?? "")
                        }
                    }
                }
                .navigationTitle("Homepage")
                .navigationBarTitleDisplayMode(.inline)
            .onAppear { Task {await fetchEvents()} }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing)
                {
                    Button{
                        self.isList.toggle()
                    }
                
                //switcha tra vista griglia e lista
                label: {
                    Image(systemName:  isList ? "rectangle.grid.1x2" : "square.grid.2x2")
                    }
                }
            }
        }
    }

    // MARK - Funzioni
    
    func fetchEvents() async {
        
        //1. Preparo la richiesta
        let request = DBNetworking.request(
            url: "https://edu.davidebalistreri.it/app/v3/events")
        
        //2. Eseguo a richiesta e ottengo la risposta
        let response = await request.response(
            type: EventsResponse.self).body
        
        self.eventsToShow = response?.data ?? []
    }
}

#Preview {
    EventsView()
}
