//
//  LoginFirebaseService.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 10/25/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

extension ViewController{
    func loginAccount(){
        //MARK: sign in a Firebase user with email and password...
        if let email = loginView.textFieldEmail.text,
           let password = loginView.textFieldPassword.text {
            //Validations....
            Auth.auth().signIn(withEmail: email, password: password, completion: {result, error in
                if error == nil{
                    //MARK: the user login is successful...
                    if let currentUser = Auth.auth().currentUser {
                        if let userName = currentUser.displayName,
                           let userPhoto = currentUser.photoURL{
                            let db = Firestore.firestore()
                            let userRef = db.collection("users").document(email)
                            userRef.getDocument {document, error in
                                if let error = error {
                                    print("Error fetching user document: \(error.localizedDescription)")
                                    return
                                }
                                
                                if let document = document, document.exists {
                                    // Access `username` and `venmo` fields from the document data
                                    let username = document.get("username") as? String ?? "No username"
                                    let venmo = document.get("venmo") as? String ?? "No Venmo"
                                    
                                    print("Username: \(username), Venmo: \(venmo)")
                                    
                                    // You can also use this data to update your UI or model
                                    self.profileController.currentUser = User(name: userName,email: email, username: username, venmo: venmo, URL: userPhoto )
                                    print("logging in user: \(userName)")
                                    self.navigationController?.popViewController(animated: true)
                                    self.navigationController?.pushViewController(self.profileController, animated: true)
                                } else {
                                    print("User document does not exist.")
                                }
                            }
                        } else {
                            // MARK: the current user displayName is not found from Firesbase Auth
                            print("cannot find that user's email")
                        }
                    }else{
                        //MARK: there is a error logging in the user...
                        self.showErrorAlert(message: "Invalid credentials.")
                        print(error)
                    }
                }
            })
        }
                               
    }
}
