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
    var dateCreated:Date
    var dateEnded:Date?
    var isTerminated:Bool
    
    static var collectionName:String = "food_trips"
    
    init(id:String, groupName: String, location: String, members: [FirestoreUser], photoURL:String?, dateCreated: Date, dateEnded: Date?, isTerminated: Bool) {
        self.id = id
        self.groupName = groupName
        self.location = location
        self.members = members
        self.photoURL = photoURL
        self.dateCreated = dateCreated
        self.dateEnded = dateEnded
        self.isTerminated = isTerminated
    }
    
    init( doc: FoodTripFromDoc, members: [FirestoreUser])  {
        self.id = doc.id
        self.groupName = doc.groupName
        self.location = doc.location
        self.photoURL = doc.photoURL
        self.members = members
        self.dateCreated = doc.dateCreated
        self.dateEnded = doc.dateEnded
        self.isTerminated = doc.isTerminated
    }
    
    // MARK: to save a trip data into Firestore
    func toMap() -> [String:Any]{
        var map:[String:Any] = [:]
        map["dateCreated"] = Date( timeIntervalSince1970: dateCreated.timeIntervalSince1970)
        map["isTerminated"] = isTerminated
        map["groupName"] = groupName
        map["location"] = location
        map["memberIds"] = members.map{$0.id}
        map["id"] = id
        
        if let dateEnded {
            map["dateEnded"] = dateEnded.timeIntervalSince1970
        }
        
        if let photoURL {
            map["photoURL"] = photoURL
        }
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
    var dateCreated:Date
    var isTerminated:Bool
    var dateEnded:Date?
    
    
    init(id:String, groupName: String, location: String, memberIds: [String], photoURL:String?, dateCreated:Date, isTerminated:Bool, dateEnded:Date?) {
        self.id = id
        self.groupName = groupName
        self.location = location
        self.memberIds = memberIds
        self.photoURL = photoURL
        self.dateCreated = dateCreated
        self.isTerminated = isTerminated
        self.dateEnded = dateEnded
    }
}
