//
//  User.swift
//  Cesk Events
//
//  Created by iedstudent on 07/05/24.
//

import Foundation

struct User: Codable, Identifiable {
    
    
            var id:Int?
    
            var email: String?
    
            var firstName: String?
    
            var lastName: String?
    
            var avatarUrl: String?
    
            var birthDate: String?
    
            var city: String?
    
            var bio: String?
    
            var eventsCount: Int?
    
            var followersCount: Int?
    
            var followingCount: Int?

            var authToken: String?
}


extension User {
    var fullName: String {
        let first = firstName ?? ""
        let last = lastName ?? ""
        return "\(first) \(last)".trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
