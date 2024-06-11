//
//  EventsView.swift
//  Cesk Events
//
//  Created by iedstudent on 07/05/24.
//

import SwiftUI
import DBNetworking

struct EventsView: View {
    
    //MARK: - VARIABILI
    @State var eventsToShow: [Event] = []
    @State var selectedEvent: Event?
    
    //visualizzazione di defaul: Lista
    @State var isList = true
    
    // MARK: - VIEW
      var body: some View {
          NavigationView {
              ScrollView {
                  LazyVGrid(columns: [
                      GridItem(.adaptive(minimum: isList ? 300 : 150))
                  ], spacing: 0) {
                      ForEach(self.eventsToShow) { event in
                          
                          // UI di ogni elemento
                          NavigationLink(destination: EventDetailView(eventToShow: event)) {
                              VStack {
                                  ZStack {
                                      NetworkImage(url: event.coverUrl)
                                          .frame(height: 200)
                                          .clipShape(Rectangle())
                                          .padding(10)
                                      
                                      
                                      Rectangle()
                                          .foregroundStyle(.clear)
                                          .background(
                                              LinearGradient(
                                                  colors: [Color.ui.buttons.opacity(0.1), Color.clear],
                                                  startPoint: .bottom,
                                                  endPoint: .top
                                              )
                                          )
                                  }
                                  Text(event.name ?? "")
                                  Text(event.date ?? "")
                                  
                                
                                  Text(event.priceInEuro)
                                      .font(.subheadline)
                                      .foregroundColor(.gray)
                                      .padding(.top, 5)
                              }
                              .contentShape(Rectangle())
                          }
                          .buttonStyle(PlainButtonStyle())
                          .onTapGesture {
                              selectedEvent = event
                          }
                      }
                  }
                  .navigationTitle("Homepage")
                  .navigationBarTitleDisplayMode(.inline)
                  .onAppear {
                      Task {
                          await fetchEvents()

                      }
                  }
              }
              .toolbar {
                  ToolbarItem(placement: .topBarTrailing) {
                      Button {
                          withAnimation { self.isList.toggle() }
                          // Switch tra lista e griglia
                      } label: {
                          Image(systemName: isList ? "square.grid.2x2" : "rectangle.grid.1x2")
                      }
                  }
              }
              // Barra fissa in basso
              
          }
      }
    
    //MARK: - FUNZIONI
    func fetchEvents() async{
        
        ///1 Preparo la richiesta
        let request = DBNetworking.request(url: "https://edu.davidebalistreri.it/app/v3/events")
        
        ///2 Eseguo la richiesta e ottengo una risposta
        let response = await request.response(
            type: EventsResponse.self
        ).body
        
        self.eventsToShow = response?.data ?? []
    }
}

#Preview {
    EventsView()
}
