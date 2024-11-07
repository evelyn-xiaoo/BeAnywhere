//
//  RegisterFirebaseService.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 10/25/24.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

extension RegisterScreenController{
    func registerNewAccount(photoURL: URL?){
        //MARK: create a Firebase user with email and password...
        if let name = registerView.textFieldName.text,
           let email = registerView.textFieldEmail.text,
           let password = registerView.textFieldPassword.text,
           let username = registerView.textFieldUsername.text,
           let venmo = registerView.textFieldVenmo.text {
            //Validations....
            
            if (!isValidEmail(email)) {
                self.showErrorAlert(message: "Invalid email.")
                return
            }
            
            if (name == "" || email == "" || password == "" || username == "" ) {
                self.showErrorAlert(message: "Text fields cannot be empty.")
                return
            }

            
            Auth.auth().createUser(withEmail: email, password: password, completion: {result, error in
                if error == nil{
                    //MARK: store extra information in firestore
                    let db = Firestore.firestore()
                    let userRef = db.collection("users").document(email)
                    
                    userRef.setData([
                        "username" : username,
                        "venmo" : venmo,
                        
                    ], merge: true) { error in
                        if let error = error {
                            print("Error saving Venmo data: \(error.localizedDescription)")
                        } else {
                            print("Venmo data saved successfully")
                        }
                    }
                    
                    //MARK: the user creation is successful...
                    self.profileController.currentUser = User(name: name, email: email, username: username, venmo: venmo, URL: photoURL)
                    self.setNameAndPhotoOfTheUserInFirebaseAuth(name: name, email: email, photoURL: photoURL)
                    self.setNameOfTheUserInFirebaseAuth(name: name)
                    
                    self.showSuccessAlert(message: "Successfully logged in!")
                }else{
                    //MARK: there is a error creating the user...
                    
                    
                    if let errorObj = error {
                        self.showErrorAlert(message: errorObj.localizedDescription)
                    } else {
                        self.showErrorAlert(message: "Unknown error occured.")
                    }
                    
                }
            })
        }
    }
    
    //MARK: We set the name of the user after we create the account...
    func setNameOfTheUserInFirebaseAuth(name: String){
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.commitChanges(completion: {(error) in
            if error == nil{
                //MARK: the profile update is successful...
                self.navigationController?.popViewController(animated: true)
                self.navigationController?.pushViewController(self.profileController, animated: true)
            }else{
                //MARK: there was an error updating the profile...
                print("Error occured: \(String(describing: error))")
            }
        })
    }
    
    func setNameAndPhotoOfTheUserInFirebaseAuth(name: String, email: String, photoURL: URL?){
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.photoURL = photoURL
        
        changeRequest?.commitChanges(completion: {(error) in
            if error != nil{
                print("Error occured: \(String(describing: error))")
            }else{
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
}
