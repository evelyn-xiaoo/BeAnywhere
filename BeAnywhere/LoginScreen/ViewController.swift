//
//  ViewController.swift
//  BeAnywhere
//
//  Created by Evelyn Xiao on 10/22/24.
//

import UIKit

class ViewController: UIViewController {
    let loginView = LoginScreenView()
    let registerScreenController = RegisterScreenController()
    let profileController = ProfileScreenController()
    override func loadView() {
        view = loginView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        loginView.buttonLogin.addTarget(self, action: #selector(onLoginTapped), for: .touchUpInside)
        loginView.buttonToRegister.addTarget(self, action: #selector(onRegisterNavTapped), for: .touchUpInside)
        
        title = "Login"
    }
    
    @objc func onLoginTapped(){
        //MARK: creating a new user on Firebase...
        loginAccount()
    }
    
    // MARK: Navigates to the register page
    @objc func onRegisterNavTapped() {
        navigationController?.pushViewController(registerScreenController, animated: true)
    }
    
    func showErrorAlert(message: String){
            let alert = UIAlertController(title: "Error", message: "\(message) Please try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
    }


}

