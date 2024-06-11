//
//  EventsResponse.swift
//  Cesk Events
//
//  Created by iedstudent on 07/05/24.
//

import Foundation



///Rappresenta la struttura in cui risponde l'API della lista eventi
struct EventsResponse: Codable {
    
    var data: [Event]?
    
    //var: error
    
}
