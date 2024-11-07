//
//  HomeFirebaseService.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 11/3/24.
//

import Foundation
import FirebaseAuth

extension ViewController {
    func logoutCurrentAccount() {
        do {
            try Auth.auth().signOut()
            let loginController = LoginScreenController()
            loginController.modalPresentationStyle = .fullScreen
            self.present(loginController, animated: false)
        } catch {
            self.showErrorAlert(message: "Failed to logout.")
        }
    }
}
