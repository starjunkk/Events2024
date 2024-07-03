import SwiftUI

struct ProfileView: View {
    @State private var showSafariView = false
    @EnvironmentObject var themeManager: ThemeManager
    @State var userToShow = Session.shared.loggedUser
    
    
    let lastEvent = Event(
        id: 1,
        name: "Evento per la preview",
        description: "Descrizione evento",
        date: "11 JUN",
        coverUrl: "https://imgs.search.brave.com/tvYm9n_Mzx_Jsu6dpzhF39xQbySASInuQFJN5RLtWOQ/rs:fit:860:0:0/g:ce/aHR0cHM6Ly9tZWRp/YS50aW1lb3V0LmNv/bS9pbWFnZXMvMTA1/MzAyOTYyLzc1MC81/NjIvaW1hZ2UuanBn",
        address: "Via Michele Guadagno 29"
    )
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background color
                themeManager.backgroundColor
                    .ignoresSafeArea()
                
                VStack {
                    // Avatar e informazioni utente
                    NetworkImage(url: "https://imgs.search.brave.com/UigQD9D2I-9V4xyACeddHs5jzPo_qZmO71xwUHqesF8/rs:fit:860:0:0/g:ce/aHR0cHM6Ly9mYnJl/Zi5jb20vcmVxLzIw/MjMwMjAzMC9pbWFn/ZXMvaGVhZHNob3Rz/L2RlYTY5OGQ5XzIw/MjIuanBn")
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 4)
                        )
                        .shadow(radius: 10)
                        .padding(.top, 40)
                    
                    Text(userToShow?.firstName ?? "")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(themeManager.textColor)
                        .padding(.top, 16)
                    
                    Text("Roma, Italia 📍")
                        .bold()
                        .foregroundColor(themeManager.textColor)
                        .padding(.top, 8)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Text("heyyy")
                        .foregroundColor(themeManager.textColor)
                        .padding(.top, 8)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    // Pulsanti Logout e FAQ
                    Button("Logout") {
                        withAnimation {
                            // Cancello utente dalla sessione
                            Session.shared.save(userToSave: nil)
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .padding(.top, 16)
                    
                    Button("FAQ") {
                        showSafariView = true
                    }
                    .foregroundColor(themeManager.buttonColor)
                    .bold()
                    .padding(.top, 10)
                    
                    // Ultimo evento a cui ha partecipato
                    VStack(alignment: .leading) {
                        Text("Evento in programma...")
                            .font(.title2)
                            .bold()
                            .foregroundColor(themeManager.textColor)
                            .padding(.top, 20)
                        
                        NavigationLink(destination: EventDetailView(eventToShow: lastEvent)) {
                            VStack {
                                ZStack(alignment: .topTrailing) {
                                    NetworkImage(url: lastEvent.coverUrl)
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: 200)
                                        .cornerRadius(16)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color.white, lineWidth: 1)
                                        )
                                    
                                    VStack {
                                        Text(StringHelper.formatDate(lastEvent.date, in: "dd"))
                                            .font(.system(size: 18, weight: .bold))
                                        Text(StringHelper.formatDate(lastEvent.date, in: "MMM").uppercased())
                                            .font(.system(size: 18, weight: .bold))
                                    }
                                    .padding(16)
                                    .background(Color.black.opacity(0.7))
                                    .cornerRadius(12)
                                    .foregroundColor(.white)
                                    .padding([.top, .trailing], 20)
                                    .offset(x: -10)
                                }
                                Text(lastEvent.name ?? "")
                                    .bold()
                                    .foregroundColor(themeManager.textColor)
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding()
                .sheet(isPresented: $showSafariView) {
                    SafariView(url: "https://edu.davidebalistreri.it/app/events")
                }
            }
            .navigationTitle("Profilo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Profilo")
                        .foregroundColor(themeManager.isDarkMode ? .white : .black)
                        .font(.headline)
                }
                ToolbarItem(placement: .navigationBarLeading) {
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
}

#Preview {
    Session.shared.load()
    return ProfileView()
        .environmentObject(ThemeManager())
        .environmentObject(Session.shared)
}
