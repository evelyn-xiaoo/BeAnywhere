//
//  TripDetailsFirebaseService.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 11/3/24.
//

import Foundation
import FirebaseAuth

extension TripDetailsScreenController {
    func initFoodStores(tripId: String) async {
        self.showActivityIndicator()
        let foodStores = await getFoodStores(tripId: tripId)
        
        if (foodStores == nil) {
            self.hideActivityIndicator()
            self.showErrorAlert(message: "Cannot get food stores. Please try again later.")
            return
        }
        
        do {
            try await setFoodItems(foodStores: foodStores!, tripId: tripId)
            self.hideActivityIndicator()
        } catch {
            self.hideActivityIndicator()
            self.showErrorAlert(message: "Cannot get food stores. Please try again later.")
        }
    }
    
    func getFoodStores(tripId: String) async -> [FoodStoreFromDoc]? {
        let foodStoresCollectionRef = database
            .collection(FoodTrip.collectionName)
            .document(tripId)
            .collection(FoodStore.collectionName)
        do {
            let foodStoreDocsRef = try await foodStoresCollectionRef.getDocuments()
            let foodStoreDocs = try foodStoreDocsRef.documents.map({try $0.data(as: FoodStoreFromDoc.self)})
            return foodStoreDocs
        } catch {
            return nil
        }
    }
    
    // MARK: get food item from each food store and update the controller food stores variable
    func setFoodItems(foodStores: [FoodStoreFromDoc], tripId: String) async throws {
        self.storePaidByMe.removeAll()
        for foodStore in foodStores{
            let foodItemsCollectionRef = database
                .collection(FoodTrip.collectionName)
                .document(tripId)
                .collection(FoodStore.collectionName)
                .document(foodStore.id)
                .collection(FoodItem.collectionName)
            var foodItems: [FoodItem] = []
            do {
                let foodItemDocsRef = try await foodItemsCollectionRef.getDocuments()
                let foodItemDocs = try foodItemDocsRef.documents.map({try $0.data(as: FoodItemFromDoc.self)})
                
                for foodItemDoc in foodItemDocs {
                    let itemPayers = await UserFirebaseService().getUsers(userIds: foodItemDoc.payerUserIds)
                    if let itemPayers {
                        foodItems.append(FoodItem(doc: foodItemDoc, payers: itemPayers))
                    } else {
                        throw FoodStore.FirebaseError.unknownError
                    }
                    
                }
                
                let submitter = await UserFirebaseService().getUser(uid: foodStore.submitterId)
                
                if (submitter == nil) {
                    throw FoodStore.FirebaseError.unknownError
                }
                
                storePaidByMe.append(FoodStore(doc: foodStore, debtors: [], submitter: submitter!, foodItems: foodItems))
            } catch {
                throw FoodStore.FirebaseError.unknownError
            }
            
        }
        self.tripDetailsView.foodStoreTable.reloadData()
    }
    
    
}
