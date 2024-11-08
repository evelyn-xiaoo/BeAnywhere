//
//  HomeFirebaseService.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 11/3/24.
//

import Foundation

extension AddTripScreenController {
    func saveFoodTrip(_ trip: FoodTrip) throws {
        
        if (trip.groupName == "" || trip.location == "") {
            showErrorAlert(message: "The text fields cannot be empty. Please try again.", controller: self)
            return
        }
        
        if (trip.members.isEmpty) {
            showErrorAlert(message: "There should be at least one member in the group. Please try again.", controller: self)
            return
        }
        self.showActivityIndicator()
        saveTripDataToFirestore(trip)
        
        
        
    }
    
    func saveTripDataToFirestore(_ trip: FoodTrip) {
        let collectionTrips = database
            .collection(FoodTrip.collectionName)
        let newTripDocRef = collectionTrips.document()
        let newFoodTrip = FoodTrip(id: newTripDocRef.documentID, groupName: trip.groupName, location: trip.location, members: trip.members, photoURL: trip.photoURL ?? "")
                    
                        newTripDocRef.setData(
                            newFoodTrip.toMap()
                        , completion: {(error) in
                            if error == nil{
                                self.uploadTripPhotoToStorage(newFoodTrip)
                                
                                
                            }
                        })
                    
        
        
    }
    
    func uploadTripPhotoToStorage(_ trip: FoodTrip) {
        if let image = pickedTripImage {
            if let jpegData = image.jpegData(compressionQuality: 80){
                let storageRef = storage.reference()
                let imagesRepo = storageRef.child("imagesFoodTrips")
                let imageRef = imagesRepo.child("\(trip.id).jpg")
                
                let uploadTask = imageRef.putData(jpegData, completion: {(metadata, error) in
                    if error == nil{
                        imageRef.downloadURL(completion: {(url, error) in
                            if error == nil,
                               let imageUrl = url{
                                self._updateTripImageUrl(FoodTrip(
                                    id: trip.id,
                                    groupName: trip.groupName, location: trip.location, members: trip.members, photoURL: imageUrl.absoluteString))
                            } else {
                                
                                self.hideActivityIndicator()
                                showErrorAlert(message: "Failed to create new trip. Please try again.", controller: self)
                            }
                        })
                    } else {
                        self.hideActivityIndicator()
                        showErrorAlert(message: "Failed to create new trip. Please try again.", controller: self)
                    }
                })
            }
        }
    }
    
    
    
    func _updateTripImageUrl(_ trip: FoodTrip) {
        let collectionTrips = database
            .collection(FoodTrip.collectionName)
            .document(trip.id)
        
        collectionTrips.updateData([
            "photoURL": trip.photoURL!
        ], completion: {(error) in
            if error == nil {
                self.navigationController?.popViewController(animated: true)
                self.hideActivityIndicator()
                
            } else {
                self.hideActivityIndicator()
                showErrorAlert(message: "Failed to create new trip. Please try again.", controller: self)
            }
        })
       
}

                                               }
