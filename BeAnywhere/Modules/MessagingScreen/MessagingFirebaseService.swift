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
    
    // MARK: sends a message in a chat with a debtor where the chatId is the debtor's user id
    func sendMessage(tripId: String, storeId: String, chatId: String, content: String) async {
        if (content == "") {
            showErrorAlert(message: "Please enter a message.", controller: self)
            return
        }
        
        do {
            let messageCollectionRef = database
                .collection(FoodTrip.collectionName)
                .document(tripId)
                .collection(FoodStore.collectionName)
                .document(storeId)
                .collection(Chat.collectionName)
                .document(chatId)
                .collection(Message.collectionName)
            
            let newMessageDocRef = messageCollectionRef.document()
            let newMessage = Message(id: newMessageDocRef.documentID, content: content, dateCreated: Date.now, submitter: self.currentUser!)
            
            try await newMessageDocRef.setData(newMessage.toMap())
        } catch {
            showErrorAlert(message: "Unknown error occurred. Please try again.", controller: self)
        }
    }
    
    func setMessageObserver(storeId: String, chat: Chat) {
        database
            .collection(FoodTrip.collectionName)
            .document(tripId)
            .collection(FoodStore.collectionName)
            .document(storeId)
            .collection(Chat.collectionName)
            .document(chat.id)
            .collection(Message.collectionName)
            .addSnapshotListener(includeMetadataChanges: false, listener: {querySnapshot, error in
                if let documents = querySnapshot?.documents{
                    for document in documents{
                        do{
                            let messageDoc  = try document.data(as: MessageFromDoc.self)
                            if (!self.currentMessages.map{$0.id}.contains(messageDoc.id)) {
                                self._addMessage(messageDoc: messageDoc)
                            }
                        
                        }catch{
                            print(error)
                        }
                    }
                    
                   
                }
            })
    }
    
    func _addMessage(messageDoc: MessageFromDoc) {
        let currentMsgUserDocRef =  database
            .collection(FirestoreUser.collectionName)
            .document(messageDoc.submitterId)
        
        currentMsgUserDocRef.getDocument(as: FirestoreUser.self) { result in
            switch result {
            case .success(let msgUser):
                let message = Message(id: messageDoc.id, content: messageDoc.content, dateCreated: messageDoc.dateCreated, submitter: msgUser)
                self.currentMessages.append(message)
                self.currentMessages.sort(by: { $0.dateCreated < $1.dateCreated })
                self.msgView.messagesTable.reloadData()
                
                // autoamatically scrolls down to the end of the message
                self.msgView.messagesTable.scrollToRow(at:  NSIndexPath.init(row: self.currentMessages.count - 1, section: 0) as IndexPath, at: UITableView.ScrollPosition.none, animated: true)
                
              
            case .failure(let error):
                showErrorAlert(message: "Failed to get the chat data. Please try login again.", controller: self)
            }
          }
    }
}
