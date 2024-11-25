//
//  FoodStore.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 11/4/24.
//

import Foundation
struct FoodStore {
    var id:String
    var storeName:String
    var address:String
    var submitter:FirestoreUser
    var dateCreated:Date
    var recipeImage:String
    var foodItems:[FoodItem]
    var debtors:[Debtor]
    
    static var collectionName:String = "food_stores"
    static var submitterField: String = "submitter_id"
    
    init(id:String, storeName:String, address:String, submitter:FirestoreUser, dateCreated:Date, recipeImage:String, foodItems:[FoodItem], debtors:[Debtor]){
        self.id = id
        self.storeName = storeName
        self.address = address
        self.submitter = submitter
        self.dateCreated = dateCreated
        self.recipeImage = recipeImage
        self.foodItems = foodItems
        self.debtors = debtors
    }
    
    // MARK: Initialize food store by fetching debtors and food items from its Firestore subcollection
    init( doc: FoodStoreFromDoc, debtors: [Debtor], submitter: FirestoreUser, foodItems: [FoodItem])  {
        self.id = doc.id
        self.dateCreated = doc.dateCreated
        self.storeName = doc.storeName
        self.address = doc.address
        self.submitter = submitter
        self.debtors = debtors
        self.recipeImage = doc.recipeImage
        self.foodItems = foodItems
        
    }
    
    // MARK: to save a trip data into Firestore
    func toMap() -> [String:Any]{
        var map:[String:Any] = [:]
        map["dateCreated"] = Date( timeIntervalSince1970: dateCreated.timeIntervalSince1970)
        map["storeName"] = storeName
        map["address"] = address
        map["recipeImage"] = recipeImage
        map["submitterId"] = submitter.id
        map["id"] = id
        
        return map
    }
    
    enum FirebaseError: Error {
        case unknownError
    }
}

// MARK: used to parse the Firestore food store collection document
struct FoodStoreFromDoc: Codable {
    var id:String
    var storeName:String
    var address:String
    var recipeImage:String
    var dateCreated:Date
    var submitterId: String
    
    
    init(id: String, storeName: String, address: String, recipeImage: String, dateCreated: Date, submitterId: String) {
        self.id = id
        self.storeName = storeName
        self.address = address
        self.recipeImage = recipeImage
        self.dateCreated = dateCreated
        self.submitterId = submitterId
    }
}

// MARK: used to save food item image data before the new food store form submission
struct FoodStoreInForm {
    var id:String
    var storeName:String
    var address:String
    var submitter:FirestoreUser
    var dateCreated:Date
    var recipeImage:String
    var foodItems:[FoodItemInForm]
    var debtors:[Debtor]
    
    init(id: String, storeName: String, address: String, submitter: FirestoreUser, dateCreated: Date, recipeImage: String, foodItems: [FoodItemInForm], debtors: [Debtor]) {
        self.id = id
        self.storeName = storeName
        self.address = address
        self.submitter = submitter
        self.dateCreated = dateCreated
        self.recipeImage = recipeImage
        self.foodItems = foodItems
        self.debtors = debtors
    }
}
