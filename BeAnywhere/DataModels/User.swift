//
//  User.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 10/25/24.
//

import Foundation
struct User{
    var name:String
    var username:String
    var venmo: String
    var email:String
    var photoURL:URL?
    
    init(name: String, email: String, username: String, venmo: String, URL: URL?) {
        self.name = name
        self.username = username
        self.venmo = venmo
        self.email = email
        self.photoURL = URL
    }
    
}
