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

    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        ZStack {
            // Background color
            themeManager.backgroundColor
                .ignoresSafeArea()
            
            VStack {
                ScrollView {
                    VStack {
                        NetworkImage(url: eventToShow.coverUrl)
                            .frame(height: 300)
                            .clipped()
                        VStack(alignment: .leading) {
                            HStack {
                                HStack {
                                    Image(systemName: "eye.fill")
                                        .foregroundColor(themeManager.buttonColor)
                                    Text("\(eventToShow.viewsCount ?? 0)")
                                        .foregroundColor(themeManager.textColor)
                                }
                                HStack {
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(themeManager.buttonColor)
                                    Text("\(eventToShow.likesCount ?? 0)")
                                        .foregroundColor(themeManager.textColor)
                                }
                                HStack {
                                    Image(systemName: "person.2.fill")
                                        .foregroundColor(themeManager.buttonColor)
                                    Text("\(eventToShow.attendeesCount ?? 0)")
                                        .foregroundColor(themeManager.textColor)
                                }
                                HStack {
                                    Image(systemName: "text.bubble.fill")
                                        .foregroundColor(themeManager.buttonColor)
                                    Text("\(eventToShow.commentsCount ?? 0)")
                                        .foregroundColor(themeManager.textColor)
                                }
                            }
                            .padding(.top, 8)
                        }
                        HStack(alignment: .top) {
                            VStack(alignment: .leading) {
                                Text(eventToShow.name ?? "-")
                                    .padding(.leading)
                                    .padding(.bottom, 4)
                                    .font(.title)
                                    .bold()
                                    .foregroundColor(themeManager.textColor)
                                Text(eventToShow.address ?? "-")
                                    .padding([.leading])
                                    .font(.headline)
                                    .foregroundColor(themeManager.textColor)
                            }
                            Spacer()
                            VStack {
                                Text(StringHelper.formatDate(eventToShow.date, in: "dd"))
                                Text(StringHelper.formatDate(eventToShow.date, in: "MMM").uppercased())
                            }
                            .padding()
                            .background(Color.black)
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white, lineWidth: 1)
                            )
                            .foregroundStyle(.white)
                            .bold()
                            .padding(.trailing, 16)
                        }
                        .padding(.bottom, 8)
                        VStack(alignment: .leading) {
                            Text(eventToShow.description ?? "-")
                                .lineLimit(isOpenDescription ? nil : 6)
                                .onTapGesture {
                                    withAnimation {
                                        isOpenDescription.toggle()
                                    }
                                }
                                .padding(16)
                                .font(.system(size: 16))
                                .foregroundColor(themeManager.textColor)
                            HStack {
                                NetworkImage(url: eventToShow.user?.avatarUrl)
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                Text(eventToShow.user?.fullName ?? "-")
                                    .font(.system(size: 16))
                                    .foregroundColor(themeManager.textColor)
                                Spacer()
                            }
                            .padding(16)
                            VStack(alignment: .leading) {
                                Text("Mappa")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(themeManager.textColor)
                                
                                Text(eventToShow.address ?? "Indirizzo mancante")
                                    .font(.caption)
                                    .foregroundColor(themeManager.textColor)
                                
                                Map(coordinateRegion: $region)
                                    .frame(height: 200)
                                    .cornerRadius(12)
                                    .onAppear {
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
                                            .onEnded {
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
                                        Button("Non ti permettere", role: .cancel) {}
                                    }
                                Text("La temperatura è di: " + temperature)
                                    .font(.subheadline)
                                    .foregroundColor(themeManager.textColor)
                                    .onAppear {
                                        Task {
                                            await self.fetchTemperatureData()
                                        }
                                    }
                                Spacer()
                            }
                            .padding(16)
                        }
                    }
                }
                .overlay(
                    HStack {
                        Text("\(eventToShow.priceInEuro)")
                            .padding()
                            .foregroundColor(themeManager.textColor)
                        
                        Spacer()
                        
                        Button(action: {
                            Cart.shared.add(item: self.eventToShow)
                            showPurchaseAlert.toggle()
                        }) {
                            Text("Acquista ora")
                                .bold()
                                .foregroundColor(.white)
                                .padding()
                                .background(themeManager.isDarkMode ? Color.ui.aquaGreen : Color.ui.orange)
                                .cornerRadius(8)
                        }
                        .padding()
                        .alert(isPresented: $showPurchaseAlert) {
                            DispatchQueue.main.async {
                                Sound.play(file: "alert_sound.mp3")
                            }
                            return Alert(
                                title: Text("Acquisto"),
                                message: Text("Hai aggiunto l'evento al carrello"),
                                dismissButton: .default(Text("OK"))
                            )
                        }
                    }
                    .background(themeManager.backgroundColor)
                    .shadow(radius: 10)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                )
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        themeManager.isDarkMode.toggle()
                    }) {
                        Image(systemName: themeManager.isDarkMode ? "sun.max.fill" : "moon.fill")
                            .foregroundColor(themeManager.buttonColor)
                    }
                }
            }
        }
    }

    func openMaps() {
        LocationHelper.navigateTo(
            destinationCoordinate: CLLocationCoordinate2D(
                latitude: self.eventToShow.lat ?? 0,
                longitude: self.eventToShow.lng ?? 0
            ), destinationName: eventToShow.address ?? ""
        )
    }

    func fetchTemperatureData() async {
        let request = DBNetworking.request(url: "https://edu.davidebalistreri.it/app/v3/temperature",
                                           parameters: ["lat": eventToShow.lat ?? 0,
                                                        "lng": eventToShow.lng ?? 0,
                                                        "appid": "ied"])
        let response = await request.response().body
        self.temperature = response ?? "-"
    }
}

#Preview {
    NavigationView {
        EventDetailView(eventToShow: Event(
            id: 1,
            name: "Evento per la preview",
            description: "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy.",
            date: "11 JUN",
            coverUrl: "https://imgs.search.brave.com/tvYm9n_Mzx_Jsu6dpzhF39xQbySASInuQFJN5RLtWOQ/rs:fit:860:0:0/g:ce/aHR0cHM6Ly9tZWRp/YS50aW1lb3V0LmNv/bS9pbWFnZXMvMTA1/MzAyOTYyLzc1MC81/NjIvaW1hZ2UuanBn",
            address: "Via Michele Guadagno 29"
        ))
        .environmentObject(ThemeManager())
    }
}
