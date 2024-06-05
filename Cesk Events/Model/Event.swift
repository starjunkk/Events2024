//
//  EventModel.swift
//  Cesk Events
//
//  Created by iedstudent on 07/05/24.
//

import Foundation

struct Event: Codable, Identifiable {
    
    
    var id: Int?
    
    var name: String?
    var description: String?
    var shortDescription: String?
    
    var date: String?
    var coverUrl:String?
    var price: Int?
    var address: String?
    var lat: Double?
    var lng: Double?
    
    
    var user: User?
    
    
    var viewsCountv: Int?
    var attendeesCount: Int?
    var likesCount: Int?
    var commentsCount: Int?
    
    var createdAt: String?
    var updatedAt: String?
    
}

extension Event {
    
    var priceInEuro: String {
        // Controllo se il biglietto ha un prezzo
        if price == nil || price! <= 0 {
            return "Gratis"
            
        }
        var priceDouble = Double(price!)
        // Converto i centesimi in euro
        priceDouble = priceDouble / 100
        
        var priceFormatted = String(format: "%.2f €", priceDouble)
        
        priceFormatted = priceFormatted.replacingOccurrences(of: ".", with: ",")
        
        return priceFormatted
    }
}
