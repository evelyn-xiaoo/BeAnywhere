//
//  UserSearchFirebaseService.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 11/7/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

extension UserSearchBottmSheetController {
    func getAllUsers() {
        database.collection(FirestoreUser.collectionName).addSnapshotListener(includeMetadataChanges: false, listener: {querySnapshot, error in
            if let documents = querySnapshot?.documents{
                self.appUsers.removeAll()
                for document in documents {
                    do {
                        let user = try document.data(as: FirestoreUser.self)
                        if user.id != nil && user.id != Auth.auth().currentUser?.uid {
                            self.appUsers.append(user)
                        }
                        
                    } catch {
                        print("Cannot load user data for user search bottom sheet")
                    }
                }
                self.appUsers.sorted(by: { $0.name < $1.name })
                //MARK: initializing the array for the table view with all the names...
                self.usersForTableView = self.appUsers
                self.searchSheet.tableViewSearchResults.reloadData()
                
            }
        })
    }
}
