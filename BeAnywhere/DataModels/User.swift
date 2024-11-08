//
//  User.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 10/25/24.
//

import Foundation
struct FirestoreUser: Codable {
    var id: String
    var name:String
    var email:String
    var avatarURL:String
    var venmo: String
    var username: String
    static var collectionName:String = "users"
    
    init(id: String, name: String, email: String, avatarURL: String, venmo: String, username: String) {
        self.id = id
        self.name = name
        self.email = email
        self.avatarURL = avatarURL
        self.venmo = venmo
        self.username = username
    }
}
