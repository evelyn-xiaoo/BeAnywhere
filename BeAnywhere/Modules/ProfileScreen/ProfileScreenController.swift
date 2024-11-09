//
//  ProfileScreenController.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 10/25/24.
//

import UIKit
import FirebaseAuth

class ProfileScreenController: UIViewController {

    let profileView = ProfileScreenView()
    var currentUser: FirestoreUser? = nil
    
    
    override func loadView() {
        view = profileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = currentUser {
            profileView.name.text = "\(user.name)"
            profileView.username.text = "@\(user.username)"
            profileView.venmo.text = "venmo: \(user.venmo)"
            if let url = URL(string: user.avatarURL){
                profileView.profilePic.loadRemoteImage(from: url)
            }
            
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editProfile))
    }
    
    
    @objc func onSignOutTapped() {
        
    }
    
    @objc func editProfile(){
        let editProfileScreen = ProfileEditViewController()
        editProfileScreen.currentUser = currentUser
        navigationController?.pushViewController(editProfileScreen, animated: true)
    }

}
