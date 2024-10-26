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
        //MARK: create a Firebase user with email and password...
        if let name = registerView.textFieldName.text,
           let email = registerView.textFieldEmail.text,
           let password = registerView.textFieldPassword.text{
            //Validations....
            
            if (!isValidEmail(email)) {
                self.showErrorAlert(message: "Invalid email.")
                return
            }
            
            if (name == "") {
                self.showErrorAlert(message: "Text fields cannot be empty.")
                return
            }

            
            Auth.auth().createUser(withEmail: email, password: password, completion: {result, error in
                if error == nil{
                    //MARK: the user creation is successful...
                    self.profileController.currentUser = User(name: name, email: email)
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
}
