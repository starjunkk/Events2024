//
//  EventModel.swift
//  Events2024
//
//  Created by iedstudent on 07/05/24.
//

import Foundation

struct Event: Codable, Identifiable {
    
    var  id: Int?
    
    var name: String?
    
    var coverUrl: String?
    
    var date: String?
    
    var price: Int?
    
    // MARK - User
    
    var user: User?
    
    var viewsCount: Int?
    
    var attendeesCount: Int?
    
    
}
