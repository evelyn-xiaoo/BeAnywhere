//
//  HomeScreenController.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 11/3/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginScreenController: UIViewController {
    let loginView = LoginScreenView()
<<<<<<< HEAD:BeAnywhere/LoginScreen/LoginScreenController.swift
    let firebaseAuth = Auth.auth()
    let database = Firestore.firestore()
    
    let childProgressView = ProgressSpinnerViewController()
=======
    let registerScreenController = RegisterScreenController()
    let profileController = ProfileScreenController()
    
>>>>>>> profile-page:BeAnywhere/LoginScreen/ViewController.swift
    override func loadView() {
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        loginView.buttonLogin.addTarget(self, action: #selector(onLoginTapped), for: .touchUpInside)
        loginView.buttonToRegister.addTarget(self, action: #selector(onRegisterNavTapped), for: .touchUpInside)
    }
    
    @objc func onLoginTapped(){
        //MARK: creating a new user on Firebase...
        loginAccount()
    }
    
    // MARK: Navigates to the register page
    @objc func onRegisterNavTapped() {
        let registerScreenController = RegisterScreenController()
        registerScreenController.loginDelegate = self
        
        self.present(registerScreenController, animated: true)
    }
    
    func showErrorAlert(message: String){
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
    }
    
    // MARK: Navigate to the home screen after creating the account
    func delegateNavigateToHomeScreen(){
        self.dismiss(animated: false)
    }


}

extension LoginScreenController:ProgressSpinnerDelegate{
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
