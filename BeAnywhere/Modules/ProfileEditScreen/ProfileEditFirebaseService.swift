//
//  ProfileEditFirebaseService.swift
//  BeAnywhere
//
//  Created by Evelyn Xiao on 11/8/24.
//


//
//  ProfileEditFirebaseService.swift
//  BeAnywhere
//
//  Created by Evelyn Xiao on 11/7/24.
//

import Foundation
import FirebaseAuth
import UIKit


extension ProfileEditViewController{
    
    @objc func saveProfile() {
        // MARK: Will be done soon
        showActivityIndicator()
        //MARK: create a Firebase user with email and password...
        if let name = editView.textFieldName.text,
           let email = editView.textFieldEmail.text,
           let username = editView.textFieldUsername.text,
           let venmo = editView.textFieldVenmo.text{
            //Validations....
            
            if (!isValidEmail(email)) {
                showErrorAlert(message: "Invalid email.", controller: self)
                return
            }
            
            if (name == "" || email == "" || username == "" ) {
                showErrorAlert(message: "Text fields cannot be empty.", controller: self)
                return
            }
            
            self.uploadProfilePhotoToStorage(userId: Auth.auth().currentUser!.uid, email: email, name: name, username: username, venmo: venmo)
            
            
            
        }
    }
    
    @objc func logoutCurrentAccount() {
        do {
            try Auth.auth().signOut()
            let loginController = LoginScreenController()
            loginController.modalPresentationStyle = .fullScreen
            self.present(loginController, animated: false)
        } catch {
            showErrorAlert(message: "Failed to logout.", controller: self)
        }
    }
    
    
    func updateProfile(){
        
    }
    
    func uploadProfilePhotoToStorage(userId: String, email: String, name: String, username: String, venmo: String){
            
        //MARK: Upload the photo if there is any...
        if let image = pickedImage{
            if let jpegData = image.jpegData(compressionQuality: 80){
                let storageRef = storage.reference()
                let imagesRepo = storageRef.child("imagesUsers")
                let imageRef = imagesRepo.child("\(userId).jpg")
                
                let uploadTask = imageRef.putData(jpegData, completion: {(metadata, error) in
                    if error == nil{
                        imageRef.downloadURL(completion: {(url, error) in
                            if error == nil,
                               let imageUrl = url{
                                self.updateUserInFirebaseAuth(newUser: FirestoreUser(id: userId, name: name, email: email, avatarURL: imageUrl.absoluteString, venmo: venmo, username: username))
                            }
                        })
                    }
                })
            }
        } else {
           
            self.updateUserInFirebaseAuth(newUser: FirestoreUser(id: userId, name: name, email: email, avatarURL: "", venmo: venmo, username: username))
        }
    }
    
    func updateUserInFirebaseAuth(newUser: FirestoreUser){
        let currentUser = Auth.auth().currentUser
        let changeRequest = currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = newUser.name
        if (newUser.avatarURL != ""){
            changeRequest?.photoURL = URL(string: newUser.avatarURL)
        }
        changeRequest?.commitChanges(completion: {(error) in
            if error == nil{
                //MARK: the profile update is successful...
                self.saveUserDataToFirestore(newUser: newUser, userId: currentUser!.uid)
            }else{
                //MARK: there was an error updating the profile...
                print("Error occured: \(String(describing: error))")
            }
           
        })
    }
    
    func saveUserDataToFirestore(newUser: FirestoreUser, userId: String){
        let collectionUsers = database
            .collection(FirestoreUser.collectionName)
                        .document(userId)
                        
                    do{
                        try collectionUsers.setData(from: newUser, completion: {(error) in
                            if error == nil{
                                self.navigationController?.popViewController(animated: true)
                                showSuccessAlert(message: "Successfully updated user!", controller: self)
                            }
                        })
                    }catch{
                        print("Error adding document!")
                    }
        
        self.hideActivityIndicator()
    }
}

extension ProfileEditViewController:ProgressSpinnerDelegate{
    func showActivityIndicator(){
        addChild(childProgressView)
        view.addSubview(childProgressView.view)
        childProgressView.didMove(toParent: self)
    }
    
    func hideActivityIndicator(){
        childProgressView.willMove(toParent: nil)
        childProgressView.view.removeFromSuperview()
        childProgressView.removeFromParent()
    }
}
