//
//  TripViewFirebaseService.swift
//  BeAnywhere
//
//  Created by Evelyn Xiao on 11/19/24.
//
import UIKit

extension TripViewController {
    // PAID BY OTHERS FUNCTIONS
    func initUsers(tripId: String) async {
            
        if let otherUsers = await getOtherUsersWithStores(tripId: tripId) {
            self.storeOtherUsers = otherUsers
            DispatchQueue.main.async {
                self.tripView.otherUsersTable.reloadData()
                self.updateOuterTableHeight()
            }
        } else {
            print( "Failed to fetch other users.")
        }
        
        
    }
    
    func getMemberIds(tripId: String) async -> [String]? {
        let tripDocRef = database
            .collection(FoodTrip.collectionName)
            .document(tripId)
            do {
                let tripDoc = try await tripDocRef.getDocument()
                guard let data = tripDoc.data(), let memberIds = data["memberIds"] as? [String] else {
                    return nil
                }
                return memberIds
            } catch {
                print("Error fetching member IDs: \(error)")
                return nil
            }
    }
    
    func getOtherMemberIds(tripId: String) async -> [String]? {
        guard let memberIds = await getMemberIds(tripId: tripId) else { return nil }
            let currentUserId = firebaseAuth.currentUser?.uid
            return memberIds.filter { $0 != currentUserId }
    }
    
    /*
    func getOtherUsers(tripId: String) async -> [FirestoreUser]? {
        guard let otherMemberIds = await getOtherMemberIds(tripId: tripId) else { return nil }
        
        var users = await UserFirebaseService().getUsers(userIds: otherMemberIds)
        
        users?.append(contentsOf: self.storeOtherUsers)
        print(users)
        return users
    }
    */
    
    func getOtherUsersWithStores(tripId: String) async -> [FirestoreUser]? {
        guard let otherMemberIds = await getOtherMemberIds(tripId: tripId) else { return nil }
                
        var users = await UserFirebaseService().getUsers(userIds: otherMemberIds) ?? []
        
        // Fetch stores for each user
        for i in 0..<users.count {
            let userId = users[i].id
            if let submittedStores = await getStores(tripId: tripId, userId: userId) {
                users[i].submittedStores = submittedStores
                
                // for each other user, get the current user's items + store in storeUserItemCost
                for othersStore in submittedStores {
                    storeUserItemCost[userId] = await getTotalCost(tripId: tripId, userId: userId)
                    paidStores[userId] = await storesPaidByCurrUser(tripId: tripId, userId: userId)
                    
                }
                
            } else {
                print("No stores found for user \(userId)")
            }
            print("trip: \(tripId), user: \(userId)")
            
        }
        return users
    }
    
    // for each store from userId, check if the curr user has paid (aka payment status = "paid")
    func storesPaidByCurrUser(tripId: String, userId: String) async -> [String] {
        let foodStoreCollectionRef = database
            .collection(FoodTrip.collectionName)
            .document(tripId)
            .collection(FoodStore.collectionName)
        do {
            let foodStoreDocsRef = try await foodStoreCollectionRef.getDocuments()
            let foodStoreDocs = try foodStoreDocsRef.documents.map({try $0.data(as: FoodStoreFromDoc.self)})
            
            var filteredStores = foodStoreDocs.filter {
                $0.submitterId == userId
            }
            
            var storeIds: [String] = []
            
            for store in filteredStores {
                let debtorCollectionRef = database
                    .collection(FoodTrip.collectionName)
                    .document(tripId)
                    .collection(FoodStore.collectionName)
                    .document(store.id)
                    .collection(Debtor.collectionName)
                do {
                    let debtorDocsRef = try await debtorCollectionRef.getDocuments()
                    let debtorDocs = try debtorDocsRef.documents.map({try $0.data(as: DebtorFromDoc.self)})
                    
                    for debtor in debtorDocs {
                        if let currId = currentUser?.id {
                            if debtor.userId == currId && debtor.paymentStatus == "Paid" {
                                storeIds.append(store.id)
                                print(store.id)
                            }
                        }
                       
                    }
                }
            }
            return storeIds
        } catch {
            print("error: \(error)")
        }
        return []
    }
    
    // for each store from userId, get cost of each item with curr userId in payerIds
    func getTotalCost(tripId: String, userId: String) async -> Double? {
        let foodStoreCollectionRef = database
            .collection(FoodTrip.collectionName)
            .document(tripId)
            .collection(FoodStore.collectionName)
        do {
            let foodStoreDocsRef = try await foodStoreCollectionRef.getDocuments()
            let foodStoreDocs = try foodStoreDocsRef.documents.map({try $0.data(as: FoodStoreFromDoc.self)})
            
            var filteredStores = foodStoreDocs.filter {
                $0.submitterId == userId
            }
            
            for store in filteredStores {
                let itemCollectionRef = database
                    .collection(FoodTrip.collectionName)
                    .document(tripId)
                    .collection(FoodStore.collectionName)
                    .document(store.id)
                    .collection(FoodItem.collectionName)
                do {
                    let itemDocsRef = try await itemCollectionRef.getDocuments()
                    let itemDocs = try itemDocsRef.documents.map({try $0.data(as: FoodItemFromDoc.self)})
                    var total: Double = 0.0
                    for item in itemDocs {
                        if let currId = currentUser?.id {
                            if item.payerUserIds.contains(currId) {
                                total += item.price / Double(item.payerUserIds.count)
                            }
                        }
                    }
                    print("total cost for \(userId): \(total)")
                    return roundToTwoPlace(total)
                }
            }
        } catch {
            print("Error: \(error)")
        }
        return 0
    }
    
    func getFirebaseUser(userId: String) async -> FirestoreUser {
        let userCollectionRef = database.collection(FirestoreUser.collectionName)
        do {
            let userDocsRef = try await userCollectionRef.getDocuments()
            let userDocs = try userDocsRef.documents.map({try $0.data(as: FirestoreUser.self)})
            
            let filteredUser = userDocs.filter { $0.id == userId }
            
            return filteredUser[0]
            
        } catch {
            print("no users: \(error)")
        }
        return FirestoreUser(id: "", name: "", email: "", avatarURL: "", venmo: "", username: "")
    }
    
    func getStores(tripId: String, userId: String) async -> [FoodStoreFromDoc]? {
        let foodStoresCollectionRef = database
            .collection(FoodTrip.collectionName)
            .document(tripId)
            .collection(FoodStore.collectionName)
        do {
            let foodStoreDocsRef = try await foodStoresCollectionRef.getDocuments()
            let foodStoreDocs = try foodStoreDocsRef.documents.map({try $0.data(as: FoodStoreFromDoc.self)})
            let filteredStores = foodStoreDocs.filter { $0.submitterId == userId }
            return filteredStores
        } catch {
            return nil
        }
    }
    
    // MARK: PAID BY YOU FUNCTIONS
    func initCurrentUserFoodStores(tripId: String, currentUserId: String) async {
        let foodStores = await getCurrentUserPaidFoodStores(tripId: tripId, currentUserId: currentUserId)
        
        if (foodStores == nil) {
            
            showErrorAlert(message: "Cannot get food stores. Please try again later.", controller: self)
            return
        }
        
        do {
            try await setFoodItems(foodStores: foodStores!, tripId: tripId)
            
        } catch {
            
            showErrorAlert(message: "Cannot get food stores. Please try again later.", controller: self)
        }
    }
    
    func getCurrentUserPaidFoodStores(tripId: String, currentUserId: String) async -> [FoodStoreFromDoc]? {
        let foodStoresCollectionRef = database
            .collection(FoodTrip.collectionName)
            .document(tripId)
            .collection(FoodStore.collectionName)
        do {
            let foodStoreDocsRef = try await foodStoresCollectionRef.getDocuments()
            let foodStoreDocs = try foodStoreDocsRef.documents.map({try $0.data(as: FoodStoreFromDoc.self)})
            return foodStoreDocs.filter({$0.submitterId == currentUserId})
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
        self.tripView.foodStoreTable.reloadData()
        self.updateFoodStoreTableHeight()
    }
    
    /*
    func getSubmittedStores(tripId: String, userId: String) async -> [FoodStoreFromDoc]? {
        
        let storesRef = database
            .collection(FoodTrip.collectionName)
            .document(tripId)
            .collection(FoodStore.collectionName)
            
            do {
                let snapshot = try await storesRef
                    .whereField(FoodStore.submitterField, isEqualTo: userId)
                    .getDocuments()
                
                // Map Firestore documents to FoodStoreFromDoc objects
                let stores: [FoodStoreFromDoc] = snapshot.documents.compactMap { doc in
                    try? doc.data(as: FoodStoreFromDoc.self)
                }
                return stores
            } catch {
                print("Error fetching stores for user \(userId): \(error)")
                return nil
            }
        }
    
    */
}
