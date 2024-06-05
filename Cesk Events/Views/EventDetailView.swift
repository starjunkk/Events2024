import SwiftUI
import MapKit
import DBNetworking
import SwiftySound

struct EventDetailView: View {
    var eventToShow: Event
    
        @State private var isOpenDescription = false
        @State private var region = MKCoordinateRegion()
        @State private var showNavigationAlert = false
        @State private var showPurchaseAlert = false
        @State private var temperature = "-"

    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    NetworkImage(url: eventToShow.coverUrl).frame(height: 300).clipped()
                    VStack(alignment: .leading) {
                        HStack{
                            HStack{
                                Image(systemName: "eye.fill")
                                Text("\(eventToShow.viewsCountv ?? 0)")
                            }
                            HStack{
                                Image(systemName: "heart.fill")
                                Text("\(eventToShow.likesCount ?? 0)")
                            }
                            HStack{
                                Image(systemName: "person.2.fill")
                                Text("\(eventToShow.attendeesCount ?? 0)")
                            }
                            HStack{
                                Image(systemName: "text.bubble.fill")
                                Text("\(eventToShow.commentsCount ?? 0)")
                            }
                        }.padding(.top, 8)
                    }
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            Text(eventToShow.name ?? "-").padding(.leading).padding(.bottom, 4).font(.title)
                                .bold()
                            Text(eventToShow.address ?? "-").padding([.leading]).font(.caption)
                        }
                        Spacer()
                        VStack{
                            Text(StringHelper.formatDate(eventToShow.date, in: "dd"))
                            Text(StringHelper.formatDate(eventToShow.date, in: "MMM").uppercased())
                        }.padding().background(Color.black).cornerRadius(16).foregroundStyle(.white).bold().padding(.trailing, 16)
                    }.padding(.bottom, 8)
                    VStack(alignment: .leading){
                        Text(eventToShow.description ?? "-")
                            .lineLimit(isOpenDescription ? nil: 6)
                            .onTapGesture {
                                withAnimation {
                                    isOpenDescription.toggle()
                                }
                            }
                            .padding(16)
                            .font(.system(size: 16))
                        HStack {
                            NetworkImage(url: eventToShow.user?.avatarUrl).frame(width: 40, height: 40).clipShape(Circle())
                            Text(eventToShow.user?.fullName ?? "-").font(.system(size: 16))
                            Spacer()
                        }.padding(16)
                        VStack(alignment: .leading) {
                            Text("Mappa")
                                .font(.title2)
                                .bold()
                            
                            Text(eventToShow.address ?? "Indirizzo mancante").font(.caption)
                            
                            Map(
                                coordinateRegion: $region
                            )
                            .frame(height:200)
                            .cornerRadius(12)
                            .onAppear {
                                //Appena compare la mappa
                                //Aggiorno il centro geografico visualizzato
                                region.center = CLLocationCoordinate2D(
                                    latitude: self.eventToShow.lat ?? 0,
                                    longitude: self.eventToShow.lng ?? 0
                                )
                                
                                region.span = MKCoordinateSpan(
                                    latitudeDelta: 0.05, longitudeDelta: 0.005
                                )
                            }
                            .simultaneousGesture(
                                TapGesture()
                                    .onEnded{
                                        self.showNavigationAlert.toggle()
                                    }
                            )
                            .alert(
                                "Vuoi navigare verso \(eventToShow.name ?? "")?",
                                isPresented: $showNavigationAlert
                            ) {
                                Button("Si") {
                                    self.openMaps()
                                }
                                Button("Non ti permettere", role: .cancel){}
                            }
                            Text("La temperatura è di:" + temperature).font(.caption)
                            .onAppear() {
                                Task {
                                    await self.fetchTemperatureData()
                                }
                            }
                            
                            Spacer()
                        }.padding(16)
                    }
                }
            }
            .overlay(
                HStack {
                    Text("\(eventToShow.priceInEuro)")
                        .padding()
                    
                    Spacer()
                    
                    Button(action: {
                        showPurchaseAlert.toggle()
                                            }) {
                        Text("Acquista ora")
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                                            }
                                                             .padding()
                                                             .alert(isPresented: $showPurchaseAlert) {
                                                                 
                                                                 DispatchQueue.main.async {
                                                                     Sound.play(file: "alert_sound.mp3")
                                                                 }
                                                                 return Alert(
                                                                     title: Text("Acquisto"),
                                                                     message: Text("Hai aggiunto l'evento al carrello \(eventToShow.priceInEuro)"),
                                                                     dismissButton: .default(Text("OK"))
                                                                 )
                                                             }
                                                         }
                                                         .background(Color.white)
                                                         .shadow(radius: 10)
                                                         .frame(maxHeight: .infinity, alignment: .bottom)
                                                     )
                                                 }
                                             }
    
    func openMaps() {
        ///L'utente ha toccato la mappa e ha alzato il dito
        LocationHelper.navigateTo(
            destinationCoordinate: CLLocationCoordinate2D(
                latitude: self.eventToShow.lat ?? 0,
                longitude: self.eventToShow.lng ?? 0
            ), destinationName: eventToShow.address ?? ""
        )
    }

    func fetchTemperatureData() async {
        ///Preparo la richiesta
        let request = DBNetworking.request(url: "https://edu.davidebalistreri.it/app/v3/temperature",
                     parameters: ["lat" : eventToShow.lat ?? 0,
                                  "lng" : eventToShow.lng ?? 0,
                                  "appid": "ied"
                                 ]
                            )
        
        /// Eseguo la richiesta e ottengo la risposta
        let response = await request.response().body
        
        ///Stampa della stringa di risposta
         self.temperature = response ?? "-"
    }
}



#Preview {
    NavigationView {
        EventDetailView( eventToShow: Event(
            id: 1,
            name: "Evento per la previw",
            
            description: "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy.",
            date: "28",
            coverUrl: "https://imgs.search.brave.com/tvYm9n_Mzx_Jsu6dpzhF39xQbySASInuQFJN5RLtWOQ/rs:fit:860:0:0/g:ce/aHR0cHM6Ly9tZWRp/YS50aW1lb3V0LmNv/bS9pbWFnZXMvMTA1/MzAyOTYyLzc1MC81/NjIvaW1hZ2UuanBn",
            
            address: "Via Michele Guadagno 29"
            
            
            
        ))
    }
}
