//
//  Debtor.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 11/4/24.
//

import Foundation
enum PaymentStatus: String {
    case pending = "Pending"
    case paid = "Paid"
    case dispute = "Dispute"
}

struct Debtor {
    var id:String
    var user:FirestoreUser
    var dateCreated:Date
    var paymentStatus: PaymentStatus
    
    static var collectionName:String = "debtors"
    
    init(id:String, user:FirestoreUser, dateCreated:Date, paymentStatus: PaymentStatus){
        self.id = id
        self.user = user
        self.dateCreated = dateCreated
        self.paymentStatus = paymentStatus
    }
    
    init( doc: DebtorFromDoc, user: FirestoreUser)  {
        self.id = doc.id
        self.user = user
        self.dateCreated = doc.dateCreated
        self.paymentStatus = PaymentStatus(rawValue: doc.paymentStatus)!
    }
    
    // MARK: to save a debtor data into Firestore
    func toMap() -> [String:Any]{
        var map:[String:Any] = [:]
        map["userId"] = user.id
        map["dateCreated"] = Date( timeIntervalSince1970: dateCreated.timeIntervalSince1970)
        map["paymentStatus"] = paymentStatus.rawValue
        map["id"] = id
        
        return map
    }
}

// MARK: used to parse the Firestore debtor collection document
struct DebtorFromDoc: Codable {
    var id:String
    var userId: String
    var dateCreated: Date
    var paymentStatus: String
    
    
    init(id: String, userId: String, dateCreated: Date, paymentStatus: String) {
        self.id = id
        self.userId = userId
        self.dateCreated = dateCreated
        self.paymentStatus = paymentStatus
    }
}
