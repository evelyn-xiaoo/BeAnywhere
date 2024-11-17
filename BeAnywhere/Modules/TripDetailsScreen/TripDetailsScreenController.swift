//
//  TripDetailsScreenController.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 10/22/24.
//

import UIKit
import Firebase
import FirebaseAuth

class TripDetailsScreenController: UIViewController {

    let tripDetailsView = TripDetailsScreenView()
    var currentTrip: FoodTripFromDoc? = nil
    
    
    let database = Firestore.firestore()
    let firebaseAuth = Auth.auth()
    let childProgressView = ProgressSpinnerViewController()
    
    var currentUser: FirestoreUser? = nil
    var storeDocsPaidByMe: [FoodStoreFromDoc] = []
    var storePaidByMe: [FoodStore] = []
    let notificationCenter = NotificationCenter.default
    
    
    override func loadView() {
        view = tripDetailsView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // MARK: load food stores and food items in each store
        if let currentTrip {
            Task.detached{
                await self.initFoodStores(tripId: currentTrip.id)
            }
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let currentTrip {
            title = currentTrip.groupName
        }
        
        var totalReceived: Double = 0
        
        storePaidByMe.forEach { store in
            store.foodItems.forEach { item in
                totalReceived += item.price
            }
        }
        
        tripDetailsView.paidByMeLabel.text = "Paid by you"
        tripDetailsView.totalReceivedLabel.text = "$ \(totalReceived.formatted())"
        
        //MARK: setting the delegate and data source...
        tripDetailsView.foodStoreTable.dataSource = self
        tripDetailsView.foodStoreTable.delegate = self
        //MARK: removing the separator line...
        tripDetailsView.foodStoreTable.separatorStyle = .none
        
        let editTripIcon = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(onTripEditClick))
       
        
        navigationItem.rightBarButtonItems = [editTripIcon]
        
        tripDetailsView.addStoreButton.addTarget(self, action: #selector(onAddFoodStoreButtonClick), for: .touchUpInside)
    }
   
    
    @objc func onTripEditClick() {
        if currentTrip == nil {
            self.showErrorAlert(message: "Unknown error. Please try to revist the page.")
            return
        }
        
        self.showActivityIndicator()
//        let tripMembers = await UserFirebaseService().getUsers(userIds: currentTrip!.memberIds)
//        
//        if (tripMembers == nil) {
//            self.showErrorAlert(message: "Unknown error. Please try to revist the page.")
//            return
//        }
        
        
        
        let editTripScreenController = EditTripScreenController()
        editTripScreenController.currentTrip = FoodTrip(doc: currentTrip!, members: [])
        self.hideActivityIndicator()
        self.navigationController?.pushViewController(editTripScreenController, animated: true)
    }
    
   
    
    @objc func onAddFoodStoreButtonClick(){
        print("on new food store button click")
    }
    
    func showErrorAlert(message: String){
            let alert = UIAlertController(title: "Error", message: "\(message) Please try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
    }
    

}

extension TripDetailsScreenController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storePaidByMe.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableConfigs.tableFoodStore, for: indexPath) as! FoodStoreTableViewCell
        let dateFormatter = DateFormatter()
        cell.storeNameLabel.text = storePaidByMe[indexPath.row].storeName
        cell.storeDateLabel.text = dateFormatter.string(from: storePaidByMe[indexPath.row].dateCreated)
        cell.storeAddressLabel.text = storePaidByMe[indexPath.row].address
        cell.storeFoodCostLabel.text = "$"
        
       
        
     
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // MARK: on current trip box click -> navigate to food store details
    }
}

extension TripDetailsScreenController:ProgressSpinnerDelegate{
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
