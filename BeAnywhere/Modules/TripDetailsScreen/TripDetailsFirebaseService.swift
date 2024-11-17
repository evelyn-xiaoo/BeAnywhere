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
        
        await setFoodItems(foodStores: foodStores!, tripId: tripId)
        self.hideActivityIndicator()
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
    
    func getFoodItems(foodStores: [FoodStoreFromDoc], tripId: String) {
        for foodStore in foodStores{
            let foodItemsCollectionRef = database
                .collection(FoodTrip.collectionName)
                .document(tripId)
                .collection(FoodStore.collectionName)
                .document(foodStore.id)
                .collection(FoodItem.collectionName)
            
            foodItemsCollectionRef.getDocuments { querySnapshot, error in
                if let documents = querySnapshot?.documents {
                    do {
                        
                    }
                }
            }
        }
    }
    
    // MARK: get food item from each food store and update the controller food stores variable
    func setFoodItems(foodStores: [FoodStoreFromDoc], tripId: String) async {
        for foodStore in foodStores{
            let foodItemsCollectionRef = database
                .collection(FoodTrip.collectionName)
                .document(tripId)
                .collection(FoodStore.collectionName)
                .document(foodStore.id)
                .collection(FoodItem.collectionName)
            do {
                let foodItemDocsRef = try await foodItemsCollectionRef.getDocuments()
                let foodItemDocs = try foodItemDocsRef.documents.map({try $0.data(as: FoodItemFromDoc.self)})
                
                // MARK: we don't need a list of payers for each food item in food trip details page. We query list of payers only when we need to
                let foodItems = foodItemDocs.map({FoodItem(doc: $0, payers: [])})
                
                let submitter = await UserFirebaseService().getUser(uid: foodStore.submitterId)
                
                if (submitter == nil) {
                    self.showErrorAlert(message: "Cannot fetch the food store. Please try again later.")
                    return
                }
                
                storePaidByMe.append(FoodStore(doc: foodStore, debtors: [], submitter: submitter!, foodItems: foodItems))
            } catch {
                self.showErrorAlert(message: "Unknown error. Please try again later.")
                return
            }
            
        }
        self.tripDetailsView.foodStoreTable.reloadData()
    }
    
    
}
