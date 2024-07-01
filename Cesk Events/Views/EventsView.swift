import SwiftUI
import DBNetworking

struct EventsView: View {
    
    //MARK: - VARIABILI
    @State var eventsToShow: [Event] = []
    @State var selectedEvent: Event?
    
    // visualizzazione di default: Lista
    @State var isList = true
    
    @EnvironmentObject var themeManager: ThemeManager
    
    // MARK: - VIEW
    var body: some View {
        NavigationView {
            ZStack {
                // Background color
                themeManager.backgroundColor
                    .ignoresSafeArea()
                
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: isList ? 300 : 150))
                    ], spacing: 16) {
                        ForEach(self.eventsToShow) { event in
                            
                            // UI di ogni elemento
                            NavigationLink(destination: EventDetailView(eventToShow: event)) {
                                VStack {
                                    ZStack(alignment: .topTrailing) {
                                        NetworkImage(url: event.coverUrl)
                                            .frame(height: 310)
                                            .cornerRadius(16)
                                            .clipShape(Rectangle())
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .stroke(Color.white, lineWidth: 1)
                                            )
                                            .padding(.all, 4)
                                        
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
                                        .offset(x: -10)
                                    }
                                    Text(event.name ?? "")
                                        .bold()
                                        .foregroundColor(themeManager.textColor)
                                    Text(event.priceInEuro)
                                        .foregroundColor(themeManager.isDarkMode ? Color.ui.aquaGreen : Color.ui.orange)
                                        .font(.headline)
                                }
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(PlainButtonStyle())
                            .onTapGesture {
                                selectedEvent = event
                            }
                        }
                    }
                    .padding(.horizontal, 8) // Aggiungi padding orizzontale attorno alla griglia
                    .onAppear {
                        Task {
                            await fetchEvents()
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Homepage")
                            .foregroundColor(themeManager.isDarkMode ? Color.ui.aquaGreen : Color.ui.orange)
                            .font(.headline)
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            themeManager.isDarkMode.toggle()
                        }) {
                            Image(systemName: themeManager.isDarkMode ? "sun.max.fill" : "moon.fill")
                                .foregroundColor(themeManager.buttonColor)
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            withAnimation { self.isList.toggle() }
                            // Switch tra lista e griglia
                        } label: {
                            Image(systemName: isList ? "square.grid.2x2" : "rectangle.grid.1x2")
                                .foregroundColor(themeManager.buttonColor) // Applica il colore del tema all'icona
                        }
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
        .environmentObject(ThemeManager())
        .environmentObject(Session.shared)
}
