//
//  UserFirebaseService.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 11/8/24.
//

import Foundation
import Firebase
import FirebaseFirestore

class UserFirebaseService {
    let database = Firestore.firestore()
    func getUser(uid: String) async -> FirestoreUser? {
        let currentUserDocRef = database
            .collection(FirestoreUser.collectionName)
            .document(uid)
        
        do {
            let currentUser = try await currentUserDocRef.getDocument(as: FirestoreUser.self)
            return currentUser
        } catch {
            return nil
        }
    }
    
    func getUsers(userIds: [String]) async -> [FirestoreUser]? {
        var users: [FirestoreUser] = []
        for userId in userIds {
            let userDocRef = database
                .collection(FirestoreUser.collectionName)
                .document(userId)
            do {
                let user = try await userDocRef.getDocument()
                users.append(try user.data(as: FirestoreUser.self))
            } catch {
                return nil
            }
            
        }
        return users
    }

}
