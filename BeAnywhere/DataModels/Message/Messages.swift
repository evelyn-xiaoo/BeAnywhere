//
//  Messages.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 12/2/24.
//

import Foundation

struct Message: Codable {
    var id: String
    var content:String
    var dateCreated:Date
    var submitter: FirestoreUser
    
    
    static var collectionName:String = "messages"
    
    init(id: String, content:String, dateCreated:Date, submitter: FirestoreUser) {
        self.id = id
        self.content = content
        self.dateCreated = dateCreated
        self.submitter = submitter
    }
    
    init(doc: MessageFromDoc, submitter: FirestoreUser) {
        self.id = doc.id
        self.dateCreated = doc.dateCreated
        self.submitter = submitter
        self.content = doc.content
    }
    
    // MARK: to save a message data into Firestore
    func toMap() -> [String:Any]{
        var map:[String:Any] = [:]
        map["id"] = id
        map["content"] = content
        map["dateCreated"] = Date( timeIntervalSince1970: dateCreated.timeIntervalSince1970)
        map["submitterId"] = submitter.id
        
        return map
    }
    
    enum FirebaseError: Error {
        case unknownError
    }
    
}

// MARK: used to parse the Firestore message collection document
struct MessageFromDoc: Codable {
    let id: String
    let content:String
    let dateCreated:Date
    let submitterId:String
    
    init(id: String, content:String, dateCreated:Date, submitterId:String) {
        self.id = id
        self.content = content
        self.dateCreated = dateCreated
        self.submitterId = submitterId
    }
}
