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
    func getUser(uid: String) -> FirestoreUser? {
        var userFound: FirestoreUser? = nil
        let currentUserDocRef = database
            .collection(FirestoreUser.collectionName)
            .document(uid)
        
        currentUserDocRef.getDocument(as: FirestoreUser.self) { result in
            switch result {
            case .success(let user):
                userFound  = user
              
            case .failure(let error): break
                
            }
          }
        
        return userFound
    }

}
