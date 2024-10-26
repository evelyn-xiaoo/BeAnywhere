//
//  ProfileScreenController.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 10/25/24.
//

import UIKit

class ProfileScreenController: UIViewController {

    let profileView = ProfileScreenView()
    var currentUser: User? = nil
    override func loadView() {
        view = profileView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        if let user = currentUser {
            profileView.welcomeMsg.text = "Welcome \(user.name)!"
        }
    }
    
    @objc func onSignOutTapped() {
        
    }

}
