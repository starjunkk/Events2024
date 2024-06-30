//
//  CartView.swift
//  Cesk Events
//
//  Created by iedstudent on 11/06/24.
//

import SwiftUI

struct CartView: View {
    
    // MARK: - Variabili
    
    // Il carrello va salvato fuori dal body,
    // così SwiftuI riesce ad aggiornare la view automaticamente
    @StateObject var cart = Cart.shared
    @State private var showAlert = false
    
    
    // MARK: - View
    
    var body: some View {
        
        NavigationView {
            VStack {
                Text("Eventi nel carrello: \(cart.items.count)")
                
                HStack {
                    Text("Costo totale: ")
                    Text("\(Cart.shared.totalPriceInEuro)")
                }
                
                if cart.items.isEmpty {
                                    Text("Carrello Vuoto")
                                        .foregroundColor(.gray)
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
                                    
                                    List {
                                        ForEach(cart.items) { event in
                                            NavigationLink(destination: EventDetailView(eventToShow: event)) {
                                                HStack {
                                                    Text(event.name ?? "")
                                                    Spacer()
                                                    Text(event.priceInEuro)
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
                                }
                            }
                            .navigationTitle("Carrello")
                            .navigationBarTitleDisplayMode(.inline)
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
                }
