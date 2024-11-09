//
//  RegisterFirebaseService.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 10/25/24.
//

import Foundation
import FirebaseAuth

extension RegisterScreenController{
    
    func registerNewAccount(){
        showActivityIndicator()
        //MARK: create a Firebase user with email and password...
        if let name = registerView.textFieldName.text,
           let email = registerView.textFieldEmail.text,
           let password = registerView.textFieldPassword.text,
           let username = registerView.textFieldUsername.text,
           let venmo = registerView.textFieldVenmo.text{
            //Validations....
            
            if (!isValidEmail(email)) {
                showErrorAlert(message: "Invalid email.", controller: self)
                return
            }
            
            if (name == "" || email == "" || password == "" || username == "" ) {
                showErrorAlert(message: "Text fields cannot be empty.", controller: self)
                return
            }

            
            Auth.auth().createUser(withEmail: email, password: password, completion: {result, error in
                if error == nil{
                    //MARK: the user creation is successful...
                    self.uploadProfilePhotoToStorage(userId: Auth.auth().currentUser!.uid, email: email, name: name, username: username, venmo: venmo)
                    
                    
                }else{
                    //MARK: there is a error creating the user...
                    
                    
                    if let errorObj = error {
                        showErrorAlert(message: errorObj.localizedDescription, controller: self)
                    } else {
                        showErrorAlert(message: "Unknown error occured.", controller: self)
                    }
                    
                }
            })
        }
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
                                self.setNameOfTheUserInFirebaseAuth(newUser: FirestoreUser(id: userId, name: name, email: email, avatarURL: imageUrl.absoluteString, venmo: venmo, username: username))
                            }
                        })
                    }
                })
            }
        } else {
           
            self.setNameOfTheUserInFirebaseAuth(newUser: FirestoreUser(id: userId, name: name, email: email, avatarURL: "", venmo: venmo, username: username))
        }
    }
    
    //MARK: We set the name of the user after we create the account...
    func setNameOfTheUserInFirebaseAuth(newUser: FirestoreUser){
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
                                let homeController = ViewController()
                                homeController.currentUser = newUser
                                
                                self.dismiss(animated: false)
                                self.loginDelegate.delegateNavigateToHomeScreen()
                                
                                
                                showSuccessAlert(message: "Successfully logged in!", controller: self)
                            }
                        })
                    }catch{
                        print("Error adding document!")
                    }
        
        self.hideActivityIndicator()
    }
}
