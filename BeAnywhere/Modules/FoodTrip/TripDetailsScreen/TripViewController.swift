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
    let notificationCenter = NotificationCenter.default
    let childProgressView = ProgressSpinnerViewController()
    
    let database = Firestore.firestore()
    let firebaseAuth = Auth.auth()
    
    var currentUser: FirestoreUser? = nil
    var storeOtherUsers: [FirestoreUser] = []
    // other user id : cost
    var storeUserItemCost: [String:Double] = [:]
    // other user id : [String (store ids)]
    var paidStores: [String:[String]] = [:]
    
    var storeDocsPaidByMe: [FoodStoreFromDoc] = []
    var storePaidByMe: [FoodStore] = []
    
    override func loadView() {
        view = tripView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let currentTrip {
            title = currentTrip.groupName
            
            Task.detached{
                await self.showActivityIndicator()
                
                if await (self.currentUser == nil) {
                    self.currentUser = await UserFirebaseService().getUser(uid: self.firebaseAuth.currentUser!.uid)
                }
                
                await self.initUsers(tripId: currentTrip.id)
                DispatchQueue.main.async {
                    self.tripView.otherUsersTable.reloadData()
                }
                await self.initCurrentUserFoodStores(tripId: currentTrip.id, currentUserId: self.currentUser!.id)
                await self.updatePriceAmount()
                await self.hideActivityIndicator()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tripView.otherUsersTable.delegate = self
        tripView.otherUsersTable.dataSource = self
        
        tripView.foodStoreTable.dataSource = self
        tripView.foodStoreTable.delegate = self
        //MARK: removing the separator line...
        tripView.foodStoreTable.separatorStyle = .none
        
        if let currentTrip {
            if !currentTrip.isTerminated {
                let editTripIcon = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(onTripEditClick))
               
                
                navigationItem.rightBarButtonItems = [editTripIcon]
                
                tripView.addStoreButton.addTarget(self, action: #selector(onAddFoodStoreButtonClick), for: .touchUpInside)
                
                notificationCenter.addObserver(self, selector: #selector(notificationReceivedForTripEdit(notification:)) , name: Notification.Name(NotificationConfigs.UpdatedTripObserverName), object: nil)
            }
            else {
                tripView.addStoreButton.isHidden = true
            }
        }
        
    }
    
    @objc func onTripEditClick() {
        if currentTrip == nil {
            showErrorAlert(message: "Unknown error. Please try to revist the page.", controller: self)
            return
        }
        
        self.showActivityIndicator()

        let editTripScreenController = EditTripScreenController()
        editTripScreenController.currentTrip = currentTrip!
        self.hideActivityIndicator()
        self.navigationController?.pushViewController(editTripScreenController, animated: true)
    }
    
//    @objc func notificationReceivedForFoodStoreAdded(notification: Notification) {
//        let newFoodStoreRequest = notification.object as! Dictionary<String, Any>
//        
//        let newFoodStoreByCurrentUser = newFoodStoreRequest["newStore"] as! FoodStore
//        let isRequestUpdate = newFoodStoreRequest["isUpdate"] as! Bool
//        
//        if (isRequestUpdate) {
//            storePaidByMe.removeAll(where: { $0.id == newFoodStoreByCurrentUser.id })
//            storePaidByMe.append(newFoodStoreByCurrentUser)
//        } else {
//            storePaidByMe.append(newFoodStoreByCurrentUser)
//        }
//        updatePriceAmount()
//        tripView.foodStoreTable.reloadData()
//    }
    
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
                } else {
                    amountOwedToCurrentUser += foodItem.price * (Double(foodItem.payers.count - 1) / Double(foodItem.payers.count))
                }
            }
        }
        
        tripView.totalReceivedLabel.text = "Total amount to receive: $\(roundToTwoPlace(amountOwedToCurrentUser))"
    }
    
    func getTotalStoreItemsCost(store: FoodStore) -> Double {
        return roundToTwoPlace(store.foodItems.reduce(0) { $0 + $1.price })
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
    
    func getCostForUser(userId: String) -> Double {
        return self.storeUserItemCost[userId] ?? 0
    }
    
    func getPaidStores(userId: String) -> [String] {
        return self.paidStores[userId] ?? []
    }

}

extension TripViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (tableView == tripView.otherUsersTable) {
            return storeOtherUsers.count
        }
        
        if (tableView == tripView.foodStoreTable) {
            if (storePaidByMe.isEmpty) {
                tripView.noStorePaidByYouLabel.layer.zPosition = 1
                tripView.noStorePaidByYouLabel.text = "No store paid by you. \n\n Click below button to add store you paid."
            } else {
                tripView.noStorePaidByYouLabel.layer.zPosition = 0
                tripView.noStorePaidByYouLabel.text = ""
            }
                return storePaidByMe.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(tableView == tripView.otherUsersTable) {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableConfigs.otherUsers, for: indexPath) as! UserCell
            let user = storeOtherUsers[indexPath.row]
            
            if let currUserId = currentUser?.id {
                cell.currUserId = currUserId
            }
            
            cell.userNameLabel.text = user.name
            cell.userId = currentUser?.id
            
            cell.totalCost.text = "Total to pay back: $\(getCostForUser(userId: user.id))"
            
            cell.paidStores = getPaidStores(userId: user.id)
            print(cell.paidStores.count)
            
            if let submittedStores = user.submittedStores {
                if (submittedStores.isEmpty) {
                    cell.noStoresPaidByUser.layer.zPosition = 1
                    cell.noStoresPaidByUser.text = "No store paid by user."
                } else {
                    cell.noStoresPaidByUser.layer.zPosition = -1
                    cell.noStoresPaidByUser.text = ""
                }
                cell.submittedStores = submittedStores
            }
            cell.navigationController = navigationController
            cell.innerTable.reloadData()
            if let currentTrip = currentTrip?.id {
                cell.tripId = currentTrip
            }
            
            return cell
        }
        
        if (tableView == tripView.foodStoreTable) {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableConfigs.tableFoodStore, for: indexPath) as! FoodStoreTableViewCell
            
            cell.storeNameLabel.text = storePaidByMe[indexPath.row].storeName
            cell.storeDateLabel.text =  storePaidByMe[indexPath.row].dateCreated.formatted()
            cell.storeAddressLabel.text = storePaidByMe[indexPath.row].address
            
            cell.storeFoodCostLabel.text = "Total cost: $ \(getTotalStoreItemsCost(store: storePaidByMe[indexPath.row]))"
            
            return cell
        }
        return UserCell()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (tableView == tripView.otherUsersTable) {
            let user = storeOtherUsers[indexPath.row]
            let numberOfStores = user.submittedStores?.count ?? 0
            let innerTableHeight = CGFloat(numberOfStores) * (60 + 10) // Inner table row height * number of stores
            let nameLabelHeight: CGFloat = 50 // Adjust based on your label's design

            return nameLabelHeight + innerTableHeight
        }
        
        if (tableView == tripView.foodStoreTable) {
            return 104
        }
        
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // MARK: on current trip box click -> navigate to food store details
        if (tableView == tripView.foodStoreTable) {
            let storeDetailsController = StoreDetailsController()
            storeDetailsController.currentTrip = self.currentTrip!
            storeDetailsController.currentFoodStore = storePaidByMe[indexPath.row]
            navigationController?.pushViewController(storeDetailsController, animated: true)
        }
    }
}

extension TripViewController:ProgressSpinnerDelegate{
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
