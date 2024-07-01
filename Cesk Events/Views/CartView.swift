import SwiftUI

struct CartView: View {
    
    // MARK: - Variabili
    @StateObject var cart = Cart.shared
    @State private var showAlert = false
    @EnvironmentObject var themeManager: ThemeManager
    
    // MARK: - View
    var body: some View {
        NavigationView {
            ZStack {
                // Background color
                themeManager.backgroundColor
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Text("Eventi nel carrello: \(cart.items.count)")
                            .bold()
                            .font(.title)
                            .foregroundColor(themeManager.textColor)
                        
                        //Spacer()
                        
                    }
                    //.padding()
                    
                    HStack {
                        Text("Costo totale: ")
                            .foregroundColor(themeManager.textColor)
                        Text("\(Cart.shared.totalPriceInEuro)")
                            .bold()
                            .foregroundColor(themeManager.textColor)
                    }
                    .padding(.vertical)
                    
                    if cart.items.isEmpty {
                        Text("Carrello Vuoto 💔")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        Button("Svuota carrello") {
                            showAlert = true
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("Conferma"),
                                message: Text("Sei sicuro di voler svuotare il carrello?"),
                                primaryButton: .destructive(Text("Sì")) {
                                    cart.removeAll()
                                },
                                secondaryButton: .cancel(Text("No"))
                            )
                        }
                        .padding(.bottom, 16)
                        
                        List {
                            ForEach(cart.items) { event in
                                NavigationLink(destination: EventDetailView(eventToShow: event)) {
                                    HStack {
                                        NetworkImage(url: event.coverUrl)
                                            .frame(width: 90, height: 90)
                                            .cornerRadius(8)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(Color.white, lineWidth: 1)
                                            )
                                        Spacer()
                                        VStack(alignment: .leading) {
                                            Text(event.name ?? "")
                                                .foregroundColor(.black)
                                                .font(.headline)
                                            Text(event.priceInEuro)
                                                .foregroundColor(.black)
                                                .font(.subheadline)
                                        }
                                        
                                        Spacer()
                                    }
                                }
                            }
                            .onDelete { indexSet in
                                indexSet.forEach { index in
                                    let event = cart.items[index]
                                    cart.remove(item: event)
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                        .cornerRadius(16) // Arrotonda gli angoli della lista
                    }
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Carrello")
                        .bold()
                        .foregroundColor(themeManager.isDarkMode ? .white : .black)
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
    Cart.shared.add(item: Event.testEvent)
    Cart.shared.add(item: Event.testEvent)
    Cart.shared.add(item: Event.testEvent)
    Cart.shared.add(item: Event.testEvent)
    Cart.shared.add(item: Event.testEvent)
    
    return CartView()
        .environmentObject(ThemeManager())
        .environmentObject(Session.shared)
}
