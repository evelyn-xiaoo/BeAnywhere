//
//  ViewController.swift
//  BeAnywhere
//
//  Created by Evelyn Xiao on 10/22/24.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {

    let homeView = HomeScreenView()
    
    
    let database = Firestore.firestore()
    let firebaseAuth = Auth.auth()
    var currentUser: FirestoreUser? = nil
    var currentTrips: [FoodTrip] = []
    
    
    override func loadView() {
        view = homeView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // MARK: navigate to login screen if not logged in
        if (firebaseAuth.currentUser == nil) {
            let loginController = LoginScreenController()
            loginController.modalPresentationStyle = .fullScreen
            self.present(loginController, animated: false)
        }
        
        
        // MARK: Observe the changes in food trip collection and update trips in real time
        database.collection(FoodTrip.collectionName).addSnapshotListener(includeMetadataChanges: false, listener: {querySnapshot, error in
            if let documents = querySnapshot?.documents{
                self.currentTrips.removeAll()
                for document in documents{
                    do{
                        let foodTrip  = try document.data(as: FoodTrip.self)
                        self.currentTrips.append(foodTrip)
                    }catch{
                        print(error)
                    }
                }
                
                self.homeView.tripTable.reloadData()
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        
        homeView.currentTripLabel.text = "Current trips"
        
        //MARK: setting the delegate and data source...
        homeView.tripTable.dataSource = self
        homeView.tripTable.delegate = self
        //MARK: removing the separator line...
        homeView.tripTable.separatorStyle = .none
        
        let profileIcon = UIBarButtonItem(
            image: UIImage(systemName: "person.crop.circle"),
            style: .plain,
            target: self,
            action: #selector(onProfileIconClick)
        )
        
        let logoutIcon = UIBarButtonItem(
            image: UIImage(systemName: "rectangle.portrait.and.arrow.right"),
            style: .plain,
            target: self,
            action: #selector(onLogoutIconClick)
        )
       
        
        navigationItem.leftBarButtonItems = [profileIcon]
        navigationItem.rightBarButtonItems = [logoutIcon]
        
        homeView.addTripButton.addTarget(self, action: #selector(onAddTripButtonClick), for: .touchUpInside)
    }
    
    @objc func onProfileIconClick(){
        let profileController = ProfileScreenController()
        self.navigationController?.pushViewController(profileController, animated: true)
    }
    
    @objc func onLogoutIconClick(){
        logoutCurrentAccount()
    }
    
    @objc func onAddTripButtonClick(){
        let addTripController = AddTripScreenController()
        self.navigationController?.pushViewController(addTripController, animated: true)
    }
    
    func showErrorAlert(message: String){
            let alert = UIAlertController(title: "Error", message: "\(message) Please try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
    }
    

}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentTrips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableConfigs.tableViewTrips, for: indexPath) as! TripBoxTableViewCell
        cell.groupNameLabel.text = currentTrips[indexPath.row].groupName
        
     
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // MARK: on current trip box click -> navigate to trip details page
    }
}
