import SwiftUI
import DBNetworking

struct EventsView: View {
    
    //MARK: - VARIABILI
    @State var eventsToShow: [Event] = []
    @State var selectedEvent: Event?
    
    // visualizzazione di default: Lista
    @State var isList = true
    
    // MARK: - VIEW
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: isList ? 300 : 150))
                ], spacing: 12) {
                    ForEach(self.eventsToShow) { event in
                        
                        // UI di ogni elemento
                        NavigationLink(destination: EventDetailView(eventToShow: event)) {
                            VStack {
                                ZStack(alignment: .topTrailing) {
                                    NetworkImage(url: event.coverUrl)
                                        .frame(height: 310)
                                        .cornerRadius(16)
                                        .clipShape(Rectangle())
                                        .padding(.leading, isList ? 16 : 8)
                                        .padding(.trailing, isList ? 16 : 8)
                                        .padding(.top, 6)
                                        .padding(.bottom, 4)
                                    
                                    VStack {
                                        Text(StringHelper.formatDate(event.date, in: "dd"))
                                            .font(.system(size: 18, weight: .bold))
                                        Text(StringHelper.formatDate(event.date, in: "MMM").uppercased())
                                            .font(.system(size: 18, weight: .bold))
                                    }
                                    .padding(16)
                                    .background(Color.black.opacity(0.7))
                                    .cornerRadius(12)
                                    .foregroundColor(.white)
                                    .padding([.top, .trailing], 20)
                                    .offset(x: -10) // Sposta la VStack leggermente a sinistra
                                }
                                Text(event.name ?? "")
                                    .bold()
                                Text(event.priceInEuro)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
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
        }
    }
    
    //MARK: - FUNZIONI
    func fetchEvents() async {
        
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
