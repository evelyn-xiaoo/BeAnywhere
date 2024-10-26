//
//  LoginFirebaseService.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 10/25/24.
//

import Foundation
import FirebaseAuth

extension ViewController{
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
                            self.profileController.currentUser = User(name: userName, email: userEmail)
                            self.navigationController?.popViewController(animated: true)
                            self.navigationController?.pushViewController(self.profileController, animated: true)
                        } else {
                            // MARK: the current user displayName is not found from Firesbase Auth
                        }
                        
                    } else {
                        // MARK: the current user is not found from Firesbase Auth
                    }
                    
                }else{
                    //MARK: there is a error logging in the user...
                    self.showErrorAlert(message: "Invalid credentials.")
                    print(error)
                }
            })
        }
    }
}
