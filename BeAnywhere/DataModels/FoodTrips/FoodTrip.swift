//
//  FoodTrip.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 11/4/24.
//

import Foundation
struct FoodTrip: Codable{
    var id:String
    var groupName:String
    var location:String
    var members:[FirestoreUser]
    var photoURL:String?
    static var collectionName:String = "food_trips"
    
    init(id:String, groupName: String, location: String, members: [FirestoreUser], photoURL:String?) {
        self.id = id
        self.groupName = groupName
        self.location = location
        self.members = members
        self.photoURL = photoURL
    }
    
    init( doc: FoodTripFromDoc, members: [FirestoreUser])  {
        self.id = doc.id
        self.groupName = doc.groupName
        self.location = doc.location
        self.photoURL = doc.photoURL
        self.members = members
    }
    
    // MARK: to save a trip data into Firestore
    func toMap() -> [String:Any]{
        var map:[String:Any] = [:]
        map["groupName"] = groupName
        map["location"] = location
        map["memberIds"] = members.map{$0.id}
        map["photoURL"] = photoURL
        map["id"] = id
        return map
    }
    enum FirebaseError: Error {
        case unknownError
    }
}

// MARK: used to parse the Firestore food trip collection document
struct FoodTripFromDoc: Codable {
    var id:String
    var groupName:String
    var location:String
    var memberIds:[String]
    var photoURL:String?
    
    
    init(id:String, groupName: String, location: String, memberIds: [String], photoURL:String?) {
        self.id = id
        self.groupName = groupName
        self.location = location
        self.memberIds = memberIds
        self.photoURL = photoURL
    }
}
