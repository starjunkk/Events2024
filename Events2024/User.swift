//
//  User.swift
//  Events2024
//
//  Created by iedstudent on 07/05/24.
//

import Foundation



struct User: Codable, Identifiable {



    var id: Int?

    

    var email: String?

    var firstName: String?

    var lastName: String?

    var avatarUrl: String?

    

    var birthDate: String?

    var city: String?

    var bio: String?

    var eventsCount: Int?

    var follwesCount: String?

    var followingCount: Double?



}
