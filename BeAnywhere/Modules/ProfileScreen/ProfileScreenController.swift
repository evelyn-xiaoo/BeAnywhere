//
//  ProfileScreenController.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 10/25/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ProfileScreenController: UIViewController {

    let profileView = ProfileScreenView()
    var currentUser: FirestoreUser? = nil
    
    let database = Firestore.firestore()
    var pastTrips: [FoodTripFromDoc] = []
    
    
    override func loadView() {
        view = profileView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initFoodTrips()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = currentUser {
            profileView.name.text = "\(user.name)"
            profileView.username.text = "@\(user.username)"
            profileView.venmo.text = "venmo: \(user.venmo)"
            if let url = URL(string: user.avatarURL){
                Task.detached {
                    await self.profileView.profilePic.loadRemoteImage(from: url)
                }
            }
            
            Task.detached {
                await self.initFoodTrips()
                DispatchQueue.main.async {
                    self.profileView.tripTable.reloadData()
                }
            }
        }
        
        
        profileView.tripTable.delegate = self
        profileView.tripTable.dataSource = self
        
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editProfile))
    }
    
    
    
    @objc func editProfile(){
        let editProfileScreen = ProfileEditViewController()
        editProfileScreen.currentUser = currentUser
        navigationController?.pushViewController(editProfileScreen, animated: true)
    }

}

extension ProfileScreenController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(pastTrips.count)
        return pastTrips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableConfigs.tableViewTrips, for: indexPath) as! TripBoxTableViewCell
        cell.groupNameLabel.text = pastTrips[indexPath.row].groupName
        
        
        let url = pastTrips[indexPath.row].photoURL
            if let tripImageUrl = URL(string: url) {
                Task.detached {
                    await cell.tripImage.loadRemoteImage(from: tripImageUrl)
                }
            }
        
        
        
     
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // MARK: on current trip box click -> navigate to trip details page
        let tripDetailsController = TripViewController()
        tripDetailsController.currentTrip = pastTrips[indexPath.row]
        navigationController?.pushViewController(tripDetailsController, animated: true)
    }
}


