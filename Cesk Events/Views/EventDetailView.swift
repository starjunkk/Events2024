//
//  EventDetailView.swift
//  Cesk Events
//
//  Created by iedstudent on 14/05/24.
//

import SwiftUI
import MapKit
import DBNetworking


struct EventDetailView: View {
    
    var eventToShow: Event
    
    @State var region = MKCoordinateRegion()
    
    @State var showNavigationAlert = false
    
    @State var temperature = "caricamento..."
    
    @State var isOpenDescription = false
    
    
    var body: some View {
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
                            Image(systemName: "eye.fill")
                            Text("\(eventToShow.likesCount ?? 0)")
                        }
                        HStack{
                            Image(systemName: "eye.fill")
                            Text("\(eventToShow.attendeesCount ?? 0)")
                        }
                        HStack{
                            Image(systemName: "eye.fill")
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
                    }.padding().background(.black).cornerRadius(16).foregroundStyle(.white).bold().padding(.trailing, 16)
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
                        NetworkImage(url: eventToShow.user?.avatarUrl).frame(width: 40, height: 40).clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
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
    func fetchTemperatureData() async{
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
            
            description: "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. ",
            date: "28",
            coverUrl: "https://lh3.googleusercontent.com/proxy/4973GJPvdYPfiMuI9O-MRKtPAKcXrhKPFNkXUBK0Pg-bDBI40daBGPXk1Yuqr-cEZd3j-LdrVqHbSLTZqAXQZFuBt-9nSLC4iwD-bNmuTWgBEUVpMGJ4S3HDvy8CyOemg1PY",
            
            address: "Via Michele Guadagno 29"
            
            
        ))
    }
}
