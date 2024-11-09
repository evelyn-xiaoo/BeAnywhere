//
//  LoginFirebaseService.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 10/25/24.
//

import Foundation
import FirebaseAuth

extension LoginScreenController{
    func loginAccount(){
        showActivityIndicator()
        //MARK: sign in a Firebase user with email and password...
        if let email = loginView.textFieldEmail.text,
           let password = loginView.textFieldPassword.text{
            //Validations....
            Auth.auth().signIn(withEmail: email, password: password, completion: {result, error in
                if error == nil{
                    //MARK: the user login is successful...
                    if let currentUser = Auth.auth().currentUser {
                        if let userName = currentUser.displayName,
                           let userEmail = currentUser.email {
                            
                            // MARK: navigate back to home screen after logging in
                            self.getCurrentUserAndNavigate(userId: currentUser.uid)
                        } else {
                            // MARK: the current user displayName is not found from Firesbase Auth
                        }
                        
                    } else {
                        // MARK: the current user is not found from Firesbase Auth
                    }
                    
                }else{
                    //MARK: there is a error logging in the user...
                    self.showErrorAlert(message: "Invalid credentials. Please try again.")
                    print(error)
                }
            })
        }
    }
    
    func getCurrentUserAndNavigate(userId: String) {
            let currentUserDocRef = database
                .collection(FirestoreUser.collectionName)
                .document(userId)
            
            currentUserDocRef.getDocument(as: FirestoreUser.self) { result in
                switch result {
                case .success(let user):
                    let homeScreen = ViewController()
                    UserSession.shared.currentUser = user
                    homeScreen.currentUser = user
                    self.dismiss(animated: false)
                  
                case .failure(let error):
                    self.showErrorAlert(message: "Failed to get the user data. Please try login again.")
                }
              }
        self.hideActivityIndicator()
    }
}
