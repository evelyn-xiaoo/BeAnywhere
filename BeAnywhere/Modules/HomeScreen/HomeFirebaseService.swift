//
//  HomeFirebaseService.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 11/3/24.
//

import Foundation
import FirebaseAuth

extension ViewController {
    func logoutCurrentAccount() {
        do {
            try Auth.auth().signOut()
            let loginController = LoginScreenController()
            loginController.modalPresentationStyle = .fullScreen
            self.present(loginController, animated: false)
        } catch {
            self.showErrorAlert(message: "Failed to logout.")
        }
    }
    
    func getCurrentUserAndTrips(userId: String) {
            let currentUserDocRef = database
                .collection(FirestoreUser.collectionName)
                .document(userId)
            
            currentUserDocRef.getDocument(as: FirestoreUser.self) { result in
                switch result {
                case .success(let user):
                    self.currentUser = user
                    self.setTripListObservation()
                  
                case .failure(let error):
                    self.showErrorAlert(message: "Failed to get the user data. Please try login again.")
                    self.hideActivityIndicator()
                }
              }
        
    }
    
    func setTripListObservation() {
        
        // MARK: Observe the changes in food trip collection and update trips in real time
        database.collection(FoodTrip.collectionName).addSnapshotListener(includeMetadataChanges: false, listener: {querySnapshot, error in
            if let documents = querySnapshot?.documents{
                self.currentTrips.removeAll()
                for document in documents{
                    do{
                        let foodTripDocument  = try document.data(as: FoodTripFromDoc.self)
                        
                        if (foodTripDocument.memberIds.contains(self.currentUser!.id)) && !foodTripDocument.isTerminated {
                            self.currentTrips.append(foodTripDocument)
                        }
                    }catch{
                        print(error)
                        self.hideActivityIndicator()
                    }
                }
                
                self.homeView.tripTable.reloadData()
                self.hideActivityIndicator()
            }
        })
    }
}
