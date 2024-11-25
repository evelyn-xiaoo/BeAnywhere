//
//  UserItemsFirebaseService.swift
//  BeAnywhere
//
//  Created by Evelyn Xiao on 11/21/24.
//

import UIKit

extension UserItemsViewController {
    func initFoodItems(tripId: String, storeId: String) async {
        if let foodItems = await getFoodItems(tripId: tripId, storeId: storeId) {
            self.selectedItems = foodItems
            print("items size = \(selectedItems.count)")
            DispatchQueue.main.async {
                self.userItemsView.itemsTable.reloadData()
            }
        }
        else {
            print("failed to fetch food items.")
        }
        
        var submitterName: String = ""
        if let store {
            let submitterId = store.submitterId
            submitterName = await getUserName(userId: submitterId) ?? "cannot get submitter name"

        }
        
        print(submitterName)
        self.userItemsView.didPay.setTitle("Did you pay \(submitterName)?", for: .normal)
        let buttonWidth = self.userItemsView.didPay.intrinsicContentSize.width + 20
        let buttonHeight = self.userItemsView.didPay.intrinsicContentSize.height + 20
        
        self.userItemsView.didPay.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        self.userItemsView.didPay.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        
        if selectedItems.isEmpty {
            let selectItemsVC = SelectItemsViewController()
        selectItemsVC.store = store
        selectItemsVC.tripId = self.tripId
        selectItemsVC.delegate = self
            self.navigationController?.pushViewController(selectItemsVC, animated: true)
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
            if let currUser = firebaseAuth.currentUser {
                let filteredFoodItems = foodItemDocs.filter {
                    $0.payerUserIds.contains(currUser.uid)
                }
                print("num selected items: \(filteredFoodItems.count)")
                return filteredFoodItems
            }
            return nil
            
        } catch {
            print("Error fetching food items: \(error)")
            return nil
        }
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
}
