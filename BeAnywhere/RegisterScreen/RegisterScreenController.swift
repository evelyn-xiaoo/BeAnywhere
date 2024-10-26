//
//  RegisterScreenController.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 10/25/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegisterScreenController: UIViewController {
    let registerView = RegisterScreenView()
    let profileController = ProfileScreenController()
        override func loadView() {
            view = registerView
        }
        override func viewDidLoad() {
            super.viewDidLoad()
            navigationController?.navigationBar.prefersLargeTitles = true
            registerView.buttonRegister.addTarget(self, action: #selector(onRegisterTapped), for: .touchUpInside)
            title = "Register"
        }
        
        @objc func onRegisterTapped(){
            //MARK: creating a new user on Firebase...
            registerNewAccount()
        }
    
    func showErrorAlert(message: String){
            let alert = UIAlertController(title: "Error", message: "\(message) Please try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
    }
    
    func showSuccessAlert(message: String){
            let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
    }

}
