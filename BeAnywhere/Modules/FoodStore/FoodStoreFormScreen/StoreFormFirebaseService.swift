//
//  StoreFormFirebaseService.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 11/3/24.
//

import Foundation

extension StoreFormScreenController {
    func updateExistingFoodStore(newStore: FoodStoreInForm, tripId: String) async {
        if (newStore.storeName == "" || newStore.address == "") {
            showErrorAlert(message: "The text fields cannot be empty. Please try again.", controller: self)
            return
        }
        
        if (newStore.foodItems.isEmpty) {
            showErrorAlert(message: "There should be at least one food item in the food store. Please try again.", controller: self)
            return
        }
        
        if (newStore.id == "") {
            showErrorAlert(message: "Invalid store. Please try again.", controller: self)
            return
        }
        
        self.showActivityIndicator()
        
        await deleteAllOldFoodItems(tripId: tripId, storeId: newStore.id)
        await saveFoodStoreDataToFirebase(newStore, tripId: tripId)
    }
    
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
    
    func deleteAllOldFoodItems(tripId: String, storeId: String) async {
        do {
            let foodItemCollection = try await database
                .collection(FoodTrip.collectionName)
                .document(tripId)
                .collection(FoodStore.collectionName)
                .document(storeId)
                .collection(FoodItem.collectionName)
                .getDocuments()
            
            let storageRef = storage.reference()
            
            for foodItem in foodItemCollection.documents {
                let foodItemFromDoc = try foodItem.data(as: FoodItemFromDoc.self)
                
                if (foodItemFromDoc.foodImageUrl != "") {
                    try await storageRef.child("imagesFoodItems").child("\(foodItemFromDoc.id).jpg")
                        .delete()
                }
                try await foodItem.reference.delete()
            }
        } catch {
            self.hideActivityIndicator()
            showErrorAlert(message: "Failed to update a store. Please try again.", controller: self)
        }
    }
    
    func saveFoodStoreDataToFirebase(_ newStore: FoodStoreInForm, tripId: String) async {
        
        var debtorsWithSubmittedItems: [Debtor] = []
        let collectionFoodStores = database
            .collection(FoodTrip.collectionName)
            .document(tripId)
            .collection(FoodStore.collectionName)
        
        var newFoodStoreDocRef = collectionFoodStores.document()
        
        if (newStore.id != "") {
            let existingFoodStoreDocRef = database
                .collection(FoodTrip.collectionName)
                .document(tripId)
                .collection(FoodStore.collectionName)
                .document(newStore.id)
            
            newFoodStoreDocRef = existingFoodStoreDocRef
        }
        
        do {
            // Save food item documents
            // Upload food item images and update food item document field
            let foodItemsWithIds = try await saveFoodItemsToFirestore(foodItems: newStore.foodItems, tripId: tripId, storeId: newFoodStoreDocRef.documentID)
            let foodItemsWithImageURL = try await getFoodItemImageURL(foodItems: foodItemsWithIds, tripId: tripId, storeId: newFoodStoreDocRef.documentID)
            
            // MARK:
//            for i in (0...newStore.debtors.count) {
//                var debtorsFoodItems: [FoodItem] = []
//                for foodItem in foodItemsWithImageURL {
//                    if (foodItem.payers.contains(where: { $0.id == newStore.debtors[i].id})) {
//                        debtorsFoodItems.append(foodItem)
//                    }
//                }
//                debtorsWithSubmittedItems.append(newStore.debtors[i])
//                debtorsWithSubmittedItems[i].user.submittedFoodItems = debtorsFoodItems
//                
//            }
            
            // Save food store document and upload recipe image
            let newFoodStoreWithId = FoodStore(id: newFoodStoreDocRef.documentID, storeName: newStore.storeName, address: newStore.address, submitter: newStore.submitter, dateCreated: newStore.dateCreated, recipeImage: newStore.recipeImage, foodItems: foodItemsWithImageURL, debtors: newStore.debtors)
            try await newFoodStoreDocRef.setData(newFoodStoreWithId.toMap())
            let newStoreWithImageURL = try await self.uploadRecipePhotoToStorage(newFoodStoreWithId, tripId: tripId)
            
            // Save debtors in Firestore
            try await saveDebtorsInFirestore(tripId: tripId, storeId: newFoodStoreWithId.id, debtors: newStore.debtors)
            
            // Indicates the food store submission was successful
            self.notificationCenter.post(
                name: Notification.Name(NotificationConfigs.NewFoodStoreObserverName),
                object: [
                    "newStore": newStoreWithImageURL,
                    "isUpdate": selectedFoodStore != nil
                ])
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
            if let jpegData = image.image!.jpegData(compressionQuality: 80){
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
                            print("DEV: error on saving image into Firestore")
                            throw FoodStore.FirebaseError.unknownError
                        }
                        
                    } else {
                        print("DEV: error on compressing the food item image")
                        throw FoodStore.FirebaseError.unknownError
                        
                    }
                
            } else {
                foodItemsWithImageUrl.append(FoodItem(id: foodItem.id, name: foodItem.name, price: foodItem.price, payers: foodItem.payers, foodImage: ""))
            }
        }
        return foodItemsWithImageUrl
    }
    
    func saveDebtorsInFirestore(tripId: String, storeId: String, debtors: [Debtor]) async throws {
        let collectionFoodStores = database
            .collection(FoodTrip.collectionName)
            .document(tripId)
            .collection(FoodStore.collectionName)
            .document(storeId)
            .collection(Debtor.collectionName)
        
        for debtor in debtors {
            var newDebtorDocRef = collectionFoodStores.document()
            
            if (debtor.id != "") {
                let debtorDocumentRef = database
                    .collection(FoodTrip.collectionName)
                    .document(tripId)
                    .collection(FoodStore.collectionName)
                    .document(storeId)
                    .collection(Debtor.collectionName)
                    .document(debtor.id)
                
                newDebtorDocRef = debtorDocumentRef
            }
    
            do {
                // Save food store document and upload recipe image
                let newDebtor = Debtor(id: newDebtorDocRef.documentID, user: debtor.user, dateCreated: debtor.dateCreated, paymentStatus: debtor.paymentStatus)
                try await newDebtorDocRef.setData(newDebtor.toMap())
                
            } catch {
                print("DEV: error on saving debtor in Firestore")
                throw FoodStore.FirebaseError.unknownError
            }
        }
    }
    
}
