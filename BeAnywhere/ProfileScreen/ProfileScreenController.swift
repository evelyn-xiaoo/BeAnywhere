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
    var currentUser: User? = nil
    
    
    override func loadView() {
        view = profileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = currentUser {
            profileView.name.text = "\(user.name)!"
            profileView.username.text = "@\(user.username)"
            profileView.venmo.text = "venmo: \(user.venmo)"
            if let url = user.photoURL{
                profileView.profilePic.loadRemoteImage(from: url)
            }
            
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editProfile))
    }
    
    
    @objc func onSignOutTapped() {
        
    }
    
    @objc func editProfile(){
        let editProfileScreen = ProfileEditViewController()
        navigationController?.pushViewController(editProfileScreen, animated: true)
    }

}


extension UIImageView {
    //MARK: Borrowed from: https://www.hackingwithswift.com/example-code/uikit/how-to-load-a-remote-image-url-into-uiimageview
    
    func loadRemoteImage(from url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
