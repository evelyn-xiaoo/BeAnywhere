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
        
        if let currentTrip {
            title = currentTrip.groupName
        }
        
        // MARK: load food stores and food items in each store
        if let currentTrip {
            Task.detached {
                await self.initFoodStores(tripId: currentTrip.id)
                self.updatePriceAmount()
            }
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tripDetailsView.paidByMeLabel.text = "Paid by you"
        
        //MARK: setting the delegate and data source...
        tripDetailsView.foodStoreTable.dataSource = self
        tripDetailsView.foodStoreTable.delegate = self
        //MARK: removing the separator line...
        tripDetailsView.foodStoreTable.separatorStyle = .none
        tripDetailsView.foodStoreTable.rowHeight = 104
        
        let editTripIcon = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(onTripEditClick))
       
        
        navigationItem.rightBarButtonItems = [editTripIcon]
        
        tripDetailsView.addStoreButton.addTarget(self, action: #selector(onAddFoodStoreButtonClick), for: .touchUpInside)
        
        // MARK: setup notification observer to listen for new food store added by the current user
        notificationCenter.addObserver(
                    self,
                    selector: #selector(notificationReceivedForFoodStoreAdded(notification:)),
                    name: Notification.Name(NotificationConfigs.NewFoodStoreObserverName),
                    object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(notificationReceivedForTripEdit(notification:)) , name: Notification.Name(NotificationConfigs.UpdatedTripObserverName), object: nil)
    }
   
    
    @objc func onTripEditClick() {
        if currentTrip == nil {
            self.showErrorAlert(message: "Unknown error. Please try to revist the page.")
            return
        }
        
        self.showActivityIndicator()

        let editTripScreenController = EditTripScreenController()
        editTripScreenController.currentTrip = currentTrip!
        self.hideActivityIndicator()
        self.navigationController?.pushViewController(editTripScreenController, animated: true)
    }
    
    @objc func notificationReceivedForFoodStoreAdded(notification: Notification) {
        let newFoodStoreByCurrentUser = notification.object as! FoodStore
        
        storePaidByMe.append(newFoodStoreByCurrentUser)
        updatePriceAmount()
        tripDetailsView.foodStoreTable.reloadData()
    }
    
    @objc func notificationReceivedForTripEdit(notification: Notification) {
        let newTrip = notification.object as! FoodTrip
        
        
        currentTrip = FoodTripFromDoc(id: newTrip.id, groupName: newTrip.groupName, location: newTrip.location, memberIds: newTrip.members.map({$0.id}), photoURL: newTrip.photoURL, dateCreated: newTrip.dateCreated, isTerminated: newTrip.isTerminated, dateEnded: newTrip.dateEnded)
        
    }
    
    @objc func onAddFoodStoreButtonClick(){
        let foodStoreFormController = StoreFormScreenController()
        foodStoreFormController.currentTrip = currentTrip!
        self.navigationController?.pushViewController(foodStoreFormController, animated: true)
    }
    
    func updatePriceAmount() {
        var amountOwedToCurrentUser: Double = 0.0
        
        for store in storePaidByMe {
            for foodItem in store.foodItems {
                if (!foodItem.payers.contains(where: ({$0.id == self.currentUser!.id}))) {
                    amountOwedToCurrentUser += foodItem.price
                }
            }
        }
        
        tripDetailsView.totalReceivedLabel.text = "Total amount to receive: $\(roundToTwoPlace(amountOwedToCurrentUser))"
    }
    
    func getTotalStoreItemsCost(store: FoodStore) -> Double {
        return roundToTwoPlace(store.foodItems.reduce(0) { $0 + $1.price })
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
        
        cell.storeNameLabel.text = storePaidByMe[indexPath.row].storeName
        cell.storeDateLabel.text =  storePaidByMe[indexPath.row].dateCreated.formatted()
        cell.storeAddressLabel.text = storePaidByMe[indexPath.row].address
        
        cell.storeFoodCostLabel.text = "Total cost: $ \(getTotalStoreItemsCost(store: storePaidByMe[indexPath.row]))"
     
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
