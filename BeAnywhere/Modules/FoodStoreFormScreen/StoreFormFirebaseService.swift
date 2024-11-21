//
//  StoreFormFirebaseService.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 11/3/24.
//

import Foundation

extension StoreFormScreenController {
    func saveNewFoodStore(_ newStore: FoodStoreInForm, tripId: String) async {
        if (newStore.storeName == "" || newStore.address == "") {
            showErrorAlert(message: "The text fields cannot be empty. Please try again.", controller: self)
            return
        }
        
        if (newStore.foodItems.isEmpty) {
            showErrorAlert(message: "There should be at least one food item in the food store. Please try again.", controller: self)
            return
        }
        self.showActivityIndicator()
        await saveFoodStoreDataToFirebase(newStore, tripId: tripId)
    }
    
    func saveFoodStoreDataToFirebase(_ newStore: FoodStoreInForm, tripId: String) async {
        let collectionFoodStores = database
            .collection(FoodTrip.collectionName)
            .document(tripId)
            .collection(FoodStore.collectionName)
        let newFoodStoreDocRef = collectionFoodStores.document()
        
        do {
            // Save food item documents
            // Upload food item images and update food item document field
            let foodItemsWithIds = try await saveFoodItemsToFirestore(foodItems: newStore.foodItems, tripId: tripId, storeId: newFoodStoreDocRef.documentID)
            let foodItemsWithImageURL = try await getFoodItemImageURL(foodItems: foodItemsWithIds, tripId: tripId, storeId: newFoodStoreDocRef.documentID)
            
            // Save food store document and upload recipe image
            let newFoodStoreWithId = FoodStore(id: newFoodStoreDocRef.documentID, storeName: newStore.storeName, address: newStore.address, submitter: newStore.submitter, dateCreated: newStore.dateCreated, recipeImage: newStore.recipeImage, foodItems: foodItemsWithImageURL, debtors: newStore.debtors)
            try await newFoodStoreDocRef.setData(newFoodStoreWithId.toMap())
            let newStoreWithImageURL = try await self.uploadRecipePhotoToStorage(newFoodStoreWithId, tripId: tripId)
            
            // Indicates the food store submission was successful
            self.notificationCenter.post(
                name: Notification.Name(NotificationConfigs.NewFoodStoreObserverName),
                object: newStoreWithImageURL)
            self.hideActivityIndicator()
            self.navigationController?.popViewController(animated: true)
        } catch {
            self.hideActivityIndicator()
            showErrorAlert(message: "Failed to create new trip. Please try again.", controller: self)
        }
    }
    
    func uploadRecipePhotoToStorage(_ newStore: FoodStore, tripId: String) async throws -> FoodStore {
        let newStoreDocRef = database
            .collection(FoodTrip.collectionName)
            .document(tripId)
            .collection(FoodStore.collectionName)
            .document(newStore.id)
        
        if let image = pickedRecipeImage {
            if let jpegData = image.jpegData(compressionQuality: 80){
                let storageRef = storage.reference()
                let imagesRepo = storageRef.child("imagesFoodStores")
                let imageRef = imagesRepo.child("\(newStore.id).jpg")
                
                do {
                    _ = try await imageRef.putDataAsync(jpegData)
                    let url = try await imageRef.downloadURL()
                    
                    try await newStoreDocRef.updateData([
                        "recipeImage": url.absoluteString
                    ])
                    
                    return FoodStore(id: newStore.id, storeName: newStore.storeName, address: newStore.address, submitter: newStore.submitter, dateCreated: newStore.dateCreated, recipeImage: url.absoluteString, foodItems: newStore.foodItems, debtors: newStore.debtors)
                    
                } catch {
                    print("DEV: error uploading store reciepe image")
                    throw FoodStore.FirebaseError.unknownError
                }
                
            } else {
                print("DEV: error uploading store reciepe image")
                throw FoodStore.FirebaseError.unknownError
            }
        } else {
            return FoodStore(id: newStore.id, storeName: newStore.storeName, address: newStore.address, submitter: newStore.submitter, dateCreated: newStore.dateCreated, recipeImage: "", foodItems: newStore.foodItems, debtors: newStore.debtors)
        }
    }
    
    func saveFoodItemsToFirestore(foodItems: [FoodItemInForm], tripId: String, storeId: String) async throws -> [FoodItemInForm] {
        var foodItemsWithId: [FoodItemInForm] = []
        for foodItem in foodItems {
            let newItemCollectionRef = database
                .collection(FoodTrip.collectionName)
                .document(tripId)
                .collection(FoodStore.collectionName)
                .document(storeId)
                .collection(FoodItem.collectionName)
            let newFoodItemDocRef = newItemCollectionRef.document()
            let newFoodItem = FoodItem(id: newFoodItemDocRef.documentID, name: foodItem.name, price: foodItem.price, payers: foodItem.payers, foodImage: "")
            do {
                try await newFoodItemDocRef.setData(newFoodItem.toMap())
                foodItemsWithId.append(FoodItemInForm(id: newFoodItem.id, name: newFoodItem.name, price: newFoodItem.price, payers: newFoodItem.payers, foodImage: foodItem.foodImage))
            } catch {
                print("DEV: error saving food item data")
                throw FoodStore.FirebaseError.unknownError
            }
            
        }
        return foodItemsWithId
    }
    
    func getFoodItemImageURL(foodItems: [FoodItemInForm], tripId: String, storeId: String) async throws -> [FoodItem] {
        self.showActivityIndicator()
        var foodItemsWithImageUrl: [FoodItem] = []
        for foodItem in foodItems {
            let foodItemDocRef = database
                .collection(FoodTrip.collectionName)
                .document(tripId)
                .collection(FoodStore.collectionName)
                .document(storeId)
                .collection(FoodItem.collectionName)
                .document(foodItem.id)
            
            if let itemImage = foodItem.foodImage {
                if let jpegData = itemImage.jpegData(compressionQuality: 80){
                    let storageRef = storage.reference()
                    let imagesRepo = storageRef.child("imagesFoodItems")
                    let imageRef = imagesRepo.child("\(foodItem.id).jpg")
                    
                    do {
                        _ = try await imageRef.putDataAsync(jpegData)
                        let url = try await imageRef.downloadURL()
                        
                        foodItemsWithImageUrl.append(FoodItem(id: foodItem.id, name: foodItem.name, price: foodItem.price, payers: foodItem.payers, foodImage: url.absoluteString))
                        
                        try await foodItemDocRef.updateData([
                            "foodImageUrl": url.absoluteString
                        ])
                    } catch {
                        print("DEV: error uploading food item image")
                        throw FoodStore.FirebaseError.unknownError
                    }
                    
                }
            } else {
                foodItemsWithImageUrl.append(FoodItem(id: foodItem.id, name: foodItem.name, price: foodItem.price, payers: foodItem.payers, foodImage: ""))
            }
        }
        return foodItemsWithImageUrl
    }
    
    
    
}
