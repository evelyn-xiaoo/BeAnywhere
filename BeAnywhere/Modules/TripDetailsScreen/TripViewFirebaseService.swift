//
//  TripViewFirebaseService.swift
//  BeAnywhere
//
//  Created by Evelyn Xiao on 11/19/24.
//
import UIKit

extension TripViewController {
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
            } else {
                print("No stores found for user \(userId)")
            }
        }
        
        return users
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
