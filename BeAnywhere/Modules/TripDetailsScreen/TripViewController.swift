//
//  TripViewController.swift
//  BeAnywhere
//
//  Created by Evelyn Xiao on 11/19/24.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class TripViewController: UIViewController {
    
    let tripView = TripView()
    var currentTrip: FoodTripFromDoc? = nil
    
    let database = Firestore.firestore()
    let firebaseAuth = Auth.auth()
    
    var currentUser: FirestoreUser? = nil
    var storeOtherUsers: [FirestoreUser] = []
    var foodStores: [FoodStoreFromDoc] = []
    
    override func loadView() {
        view = tripView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tripView.otherUsersTable.delegate = self
        tripView.otherUsersTable.dataSource = self
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let currentTrip {
            title = currentTrip.groupName
            
            tripView.paidByOthersLabel.text = "Paid by others: pending"
            
            Task.detached{
                await self.initUsers(tripId: currentTrip.id)
                DispatchQueue.main.async {
                    self.tripView.otherUsersTable.reloadData()
                }
            }
        }
    }
    
    func calculateOuterTableHeight() -> CGFloat {
        var totalHeight: CGFloat = 0
        
        for row in 0..<storeOtherUsers.count {
            // Calculate row height for each user
            let user = storeOtherUsers[row]
            let numberOfStores = user.submittedStores?.count ?? 0
            let innerTableHeight = CGFloat(numberOfStores) * 100 // Inner table row height * number of stores
            let nameLabelHeight: CGFloat = 40 // Adjust based on your label's design
            let padding: CGFloat = 20 // Add some padding between elements
            
            totalHeight += nameLabelHeight + innerTableHeight + padding
        }
        
        return totalHeight
    }
    
    func updateOuterTableHeight() {
        let height = calculateOuterTableHeight()
        tripView.otherUsersTable.heightAnchor.constraint(equalToConstant: height).isActive = true
    }

}

extension TripViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tripView.otherUsersTable {
            return storeOtherUsers.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableConfigs.otherUsers, for: indexPath) as! UserCell
        let user = storeOtherUsers[indexPath.row]
        
        
        cell.userNameLabel.text = user.name
        if let submittedStores = user.submittedStores {
            cell.submittedStores = submittedStores
        }
        cell.navigationController = navigationController
        cell.innerTable.reloadData()
        if let currentTrip = currentTrip?.id {
            cell.tripId = currentTrip
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let user = storeOtherUsers[indexPath.row]
        let numberOfStores = user.submittedStores?.count ?? 0
        let innerTableHeight = CGFloat(numberOfStores) * (60 + 10) // Inner table row height * number of stores
        let nameLabelHeight: CGFloat = 50 // Adjust based on your label's design

        return nameLabelHeight + innerTableHeight
    }
}
