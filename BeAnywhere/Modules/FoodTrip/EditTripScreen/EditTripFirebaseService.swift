//
//  EditTripFirebaseService.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 11/3/24.
//

import Foundation

extension EditTripScreenController {
    func terminateTrip(trip: FoodTripFromDoc) async {
        let tripDocRef = database
            .collection(FoodTrip.collectionName)
            .document(trip.id)
        
        do {
            try await tripDocRef.updateData(["isTerminated": true])
        } catch {
            showErrorAlert(message: "Failed to terminate the trip. Please try again later.", controller: self)
        }
        navigationController?.popToRootViewController(animated: false)
    }
    
    func saveFoodTrip(_ trip: FoodTrip) {
        
        if (trip.groupName == "" || trip.location == "") {
            showErrorAlert(message: "The text fields cannot be empty. Please try again.", controller: self)
            return
        }
        
        if (trip.members.isEmpty) {
            showErrorAlert(message: "There should be at least one member in the group. Please try again.", controller: self)
            return
        }
        
        self.showActivityIndicator()
        updateTripDataToFirestore(trip)
        
    }
    
    func updateTripDataToFirestore(_ trip: FoodTrip) {
        let tripDocRef = database
            .collection(FoodTrip.collectionName)
            .document(trip.id)
                    
        tripDocRef.updateData(
                            trip.toMap()
                        , completion: {(error) in
                            if error == nil{
                                self.uploadTripPhotoToStorage(trip)
                            } else {
                                self.hideActivityIndicator()
                                showErrorAlert(message: "Failed to create new trip. Please try again.", controller: self)
                            }
                        })
                    
        
        
    }
    
    func uploadTripPhotoToStorage(_ trip: FoodTrip) {
        if let image = pickedTripImage {
            if let jpegData = image.jpegData(compressionQuality: 80){
                let storageRef = storage.reference()
                let imagesRepo = storageRef.child("imagesFoodTrips")
                let imageRef = imagesRepo.child("\(trip.id).jpg")
                
                
                // MARK: delete the original image storage ref and upload image in the same storage ref
                
                        _ = imageRef.putData(jpegData, completion: {(metadata, error) in
                            if error == nil{
                                imageRef.downloadURL(completion: {(url, error) in
                                    if error == nil,
                                       let imageUrl = url{
                                        self._updateTripImageUrl(FoodTrip(
                                            id: trip.id,
                                            groupName: trip.groupName, location: trip.location, members: trip.members, photoURL: imageUrl.absoluteString, dateCreated: trip.dateCreated, dateEnded: trip.dateEnded, isTerminated: trip.isTerminated))
                                    } else {
                                        self.hideActivityIndicator()
                                        showErrorAlert(message: "Failed to update a trip. Please try again.", controller: self)
                                    }
                                })
                            } else {
                                self.hideActivityIndicator()
                                showErrorAlert(message: "Failed to update a trip. Please try again.", controller: self)
                            }
                        })
                    
                
            }
        } else {
            notificationCenter.post(
                name: Notification.Name(NotificationConfigs.UpdatedTripObserverName),
                object: trip)
            self.navigationController?.popViewController(animated: true)
            self.hideActivityIndicator()
        }
    }
    
    
    
    func _updateTripImageUrl(_ trip: FoodTrip) {
        let collectionTrips = database
            .collection(FoodTrip.collectionName)
            .document(trip.id)
        
        collectionTrips.updateData([
            "photoURL": trip.photoURL
        ], completion: {(error) in
            if error == nil {
                self.notificationCenter.post(
                    name: Notification.Name(NotificationConfigs.UpdatedTripObserverName),
                    object: trip)
                self.navigationController?.popViewController(animated: true)
                self.hideActivityIndicator()
                
            } else {
                self.hideActivityIndicator()
                showErrorAlert(message: "Failed to create new trip. Please try again.", controller: self)
            }
        })
       
}

                                               }
