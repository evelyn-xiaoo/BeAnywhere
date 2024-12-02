//
//  FoodItem.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 11/4/24.
//

import Foundation
import UIKit

struct FoodItem: Codable{
    var id:String
    var name:String
    var price:Double
    var payers:[FirestoreUser]
    var foodImage:String
    
    static var collectionName:String = "food_items"
    
    init (id:String, name:String, price:Double, payers: [FirestoreUser], foodImage:String){
        self.id = id
        self.name = name
        self.price = price
        self.payers = payers
        self.foodImage = foodImage
    }
    
    init( doc: FoodItemFromDoc, payers: [FirestoreUser])  {
        self.id = doc.id
        self.name = doc.name
        self.price = doc.price
        self.foodImage = doc.foodImageUrl
        self.payers = payers
    }
    
    // MARK: to save a food item data into Firestore
    func toMap() -> [String:Any]{
        var map:[String:Any] = [:]
        map["name"] = name
        map["price"] = price
        map["payerUserIds"] = payers.map({$0.id})
        map["foodImageUrl"] = foodImage
        map["id"] = id
        
        return map
    }
}

// MARK: used to parse the Firestore food item collection document
struct FoodItemFromDoc: Codable {
    var id:String
    var name:String
    var price:Double
    var payerUserIds: [String]
    var foodImageUrl:String
    
    
    init(id: String, name: String, price: Double, payerUserIds: [String], foodImageUrl: String) {
        self.id = id
        self.name = name
        self.price = price
        self.payerUserIds = payerUserIds
        self.foodImageUrl = foodImageUrl
    }
}

// MARK: used to save food item image data before the new food store form submission
struct FoodItemInForm {
    var id:String
    var name:String
    var price:Double
    var payers:[FirestoreUser]
    var foodImage: UIImage?
    var imageUrlToLoad:String?
    
    init(id: String, name: String, price: Double, payers: [FirestoreUser], foodImage: UIImage? = nil, imageUrlToLoad:String? = nil) {
        self.id = id
        self.name = name
        self.price = price
        self.payers = payers
        self.foodImage = foodImage
        self.imageUrlToLoad = imageUrlToLoad
    }
}
