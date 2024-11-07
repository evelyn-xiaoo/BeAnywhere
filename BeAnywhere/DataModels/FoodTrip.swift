//
//  FoodTrip.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 11/4/24.
//

import Foundation
struct FoodTrip: Codable{
    var groupName:String
    var location:String
    var members:[FirestoreUser]
    static var collectionName:String = "food_trips"
    
    init(groupName: String, location: String, members: [FirestoreUser]) {
        self.groupName = groupName
        self.location = location
        self.members = members
    }
}
