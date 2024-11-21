//
//  MessagingFirebaseService.swift
//  BeAnywhere
//
//  Created by Evelyn Xiao on 11/21/24.
//
import UIKit

extension MessagingViewController {
    func initItems(tripId: String, storeId: String) async {
        
        var submitterName: String = ""
        if let currentStore {
            let submitterId = currentStore.submitterId
            submitterName = await getUserName(userId: submitterId) ?? "cannot get submitter name"
            
        }
        
        self.title = "Messaging \(submitterName)"
        
        let width = self.msgView.textField.intrinsicContentSize.width + 20
        let height = self.msgView.textField.intrinsicContentSize.height + 20
        self.msgView.textField.widthAnchor.constraint(equalToConstant: width).isActive = true
        self.msgView.textField.heightAnchor.constraint(equalToConstant: height).isActive = true
        
    }
    
    func getUserName(userId: String) async -> String? {
        let userRef = database
            .collection(FirestoreUser.collectionName).document(userId)
        do {
            let userDoc = try await userRef.getDocument()
            let user = try userDoc.data(as: FirestoreUser.self)
            return user.name
        } catch {
            print("Error fetching user name: \(error)")
            return nil
        }
    }
    
    func getFoodItems(tripId: String, storeId: String) async -> [FoodItemFromDoc]? {
        print("trip: \(tripId), store: \(storeId)")
        let foodItemsCollectionRef = database
            .collection(FoodTrip.collectionName)
            .document(tripId)
            .collection(FoodStore.collectionName)
            .document(storeId)
            .collection(FoodItem.collectionName)
        
        do {
            let foodItemDocsRef = try await
                foodItemsCollectionRef.getDocuments()
            
            let foodItemDocs = try
                foodItemDocsRef.documents.map({try
                    $0.data(as: FoodItemFromDoc.self)
                })
            print("num items: \(foodItemDocs.count)")
            return foodItemDocs
        } catch {
            print("Error fetching food items: \(error)")
            return nil
        }
    }
}
