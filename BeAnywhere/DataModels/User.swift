//
//  User.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 10/25/24.
//

import Foundation
struct FirestoreUser: Codable {
    var name:String
    var email:String
    var avatarURL:String
    static var collectionName:String = "users"
    
    init( name: String, email: String, avatarURL: String) {
        self.name = name
        self.email = email
        self.avatarURL = avatarURL
    }
}
