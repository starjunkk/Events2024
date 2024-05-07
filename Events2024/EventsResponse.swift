//
//  EventsResponse.swift
//  Events2024
//
//  Created by iedstudent on 07/05/24.
//

import Foundation

// Rappresenta la struttura a cui risponde l'API degli eventi.

struct EventsResponse : Codable {
    
    var data: [Event]?
    
    //var error
}
