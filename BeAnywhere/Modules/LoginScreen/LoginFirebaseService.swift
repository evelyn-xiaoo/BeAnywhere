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
                            self.showErrorAlert(message: "Invalid credentials. Please try again.")
                            self.hideActivityIndicator()
                        }
                        
                    } else {
                        // MARK: the current user is not found from Firesbase Auth
                        self.showErrorAlert(message: "Invalid credentials. Please try again.")
                        self.hideActivityIndicator()
                    }
                    
                }else{
                    //MARK: there is a error logging in the user...
                    self.showErrorAlert(message: "Invalid credentials. Please try again.")
                    self.hideActivityIndicator()
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
                    UserSession.shared.currentUser = user
                    self.hideActivityIndicator()
                    self.dismiss(animated: false)
                    
                    self.notificationCenter.post(
                        name: Notification.Name(NotificationConfigs.NewUserLoggedInObserverName),
                        object: nil)
                    
                    
                    print("DEV: navigation completed")
                  
                case .failure(let error):
                    self.showErrorAlert(message: "Failed to get the user data. Please try login again.")
                    self.hideActivityIndicator()
                }
              }
    }
}
