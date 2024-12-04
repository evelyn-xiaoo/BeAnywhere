//
//  Chats.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 12/2/24.
//

import Foundation

struct Chat: Codable {
    var id: String
    var storePayer:FirestoreUser
    var dateCreated: Date

    static var collectionName:String = "chats"
    
    init(id: String, storePayer:FirestoreUser, dateCreated: Date) {
        self.id = id
        self.storePayer = storePayer
        self.dateCreated = dateCreated
    }
    
    init(doc: ChatFromDoc, storePayer: FirestoreUser) {
        self.id = doc.id
        self.storePayer = storePayer
        self.dateCreated = doc.dateCreated
    }
    
    // MARK: to save a chat data into Firestore
    func toMap() -> [String:Any]{
        var map:[String:Any] = [:]
        map["storePayerId"] = storePayer.id
        map["dateCreated"] = Date( timeIntervalSince1970: dateCreated.timeIntervalSince1970)
        map["id"] = id
        
        return map
    }
}

// MARK: used to parse the Firestore chat collection document
struct ChatFromDoc: Codable {
    var id: String
    var storePayerId:String
    var dateCreated: Date
    
    init(id: String, storePayerId:String, dateCreated: Date) {
        self.id = id
        self.storePayerId = storePayerId
        self.dateCreated = dateCreated
    }
}
