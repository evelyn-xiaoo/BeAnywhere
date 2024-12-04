//
//  StoreDetailsFirebaseService.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 11/23/24.
//
import UIKit

extension StoreDetailsController {
    
    // Fetch the selected food store's debtors
    func initDebtors(tripId: String, storeId: String) async {
        let debtorCollectionRef = database
            .collection(FoodTrip.collectionName)
            .document(tripId)
            .collection(FoodStore.collectionName)
            .document(storeId)
            .collection(Debtor.collectionName)
        
        do {
            let debtorDocsRef = try await debtorCollectionRef.getDocuments()
            
            let debtorsDocs = try debtorDocsRef.documents.map({try $0.data(as: DebtorFromDoc.self)})
            
            debtors.removeAll()
            membersFoodItems.removeAll()
            
            for debtorDoc in debtorsDocs {
                var userSubmittedItems: [FoodItem] = []
                let userId = debtorDoc.userId
                let userFoodItemsInCharge = self.currentFoodStore!.foodItems.filter({$0.payers.contains(where: {$0.id == userId})})
                var user = await UserFirebaseService().getUser(uid: userId)
                
                if (user == nil) {
                    throw FoodStore.FirebaseError.unknownError
                }
                
                for userFoodItem in userFoodItemsInCharge {
                    let itemWithDividedPrice = FoodItem(id: userFoodItem.id, name: userFoodItem.name, price: roundToTwoPlace(userFoodItem.price / Double(userFoodItem.payers.count)), payers: userFoodItem.payers, foodImage: userFoodItem.foodImage)
                    userSubmittedItems.append(itemWithDividedPrice)
                }
                user!.submittedFoodItems = userSubmittedItems
                membersFoodItems.append(user!)
                debtors.append(Debtor(doc: debtorDoc, user: user!))
            }
            
        } catch {
            showErrorAlert(message: "Unknown error occured. Please try again later.", controller: self)
        }
    }
    
    func getChatWithStorePayer(tripId: String, storeId: String, debtorUserIds: [String]) async -> [Chat]? {
        var debtorChats: [Chat] = []
        for debtorUserId in debtorUserIds {
            let chatDocRef = database
                .collection(FoodTrip.collectionName)
                .document(tripId)
                .collection(FoodStore.collectionName)
                .document(storeId)
                .collection(Chat.collectionName)
                .document(debtorUserId)
            
            do {
                let chat = try await chatDocRef.getDocument(as: ChatFromDoc.self)
                
                let storePayer = await UserFirebaseService().getUser(uid: chat.storePayerId)
                
                if (storePayer == nil) {
                    return nil
                }
                
                debtorChats.append(Chat(doc: chat, storePayer: storePayer!))
                
            } catch {
                return nil
            }
        }
        return debtorChats

    }
}
