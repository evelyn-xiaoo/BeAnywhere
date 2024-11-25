//
//  ProfileFirebaseService.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 10/25/24.
//

import Foundation
import FirebaseAuth

extension ProfileScreenController{
    func initFoodTrips(){
        self.getFoodTrips()
    }
    
    func getFoodTrips() {
        database.collection(FoodTrip.collectionName).addSnapshotListener(includeMetadataChanges: false, listener: {querySnapshot, error in
            if let documents = querySnapshot?.documents{
                self.pastTrips.removeAll()
                for document in documents{
                    do{
                        let foodTripDocument  = try document.data(as: FoodTripFromDoc.self)
                        
                        if (foodTripDocument.memberIds.contains(self.currentUser!.id) && foodTripDocument.isTerminated) {
                            print(foodTripDocument.groupName)
                            self.pastTrips.append(foodTripDocument)
                        }
                    }catch{
                        print(error)
                    }
                }
                
                self.profileView.tripTable.reloadData()
            }
        })
    }
}
