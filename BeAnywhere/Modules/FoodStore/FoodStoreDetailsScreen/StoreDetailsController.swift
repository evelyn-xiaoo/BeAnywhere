//
//  StoreDetailsController.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 11/23/24.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class StoreDetailsController: UIViewController {
    let storeView = StoreDetailsView()
    let notificationCenter = NotificationCenter.default
    let childProgressView = ProgressSpinnerViewController()
    
    let database = Firestore.firestore()
    let firebaseAuth = Auth.auth()
    var currentUser: FirestoreUser? = nil
    var chatsWithStorePayer: [Chat]? = nil
    
    // MARK: list of food store's members with food items in each user
    var membersFoodItems: [FirestoreUser] = []
    
    // MARK: list of food store's debtors
    var debtors: [Debtor] = []
    
    // MARK: varialbes that must be defined on this class call
    var currentFoodStore: FoodStore? = nil
    var currentTrip: FoodTripFromDoc? = nil
    
    override func loadView() {
        view = storeView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let currentFoodStore, let currentTrip {
            title = currentFoodStore.storeName
            
            Task{
                self.showActivityIndicator()
                self.currentUser = await UserFirebaseService().getUser(uid: firebaseAuth.currentUser!.uid)
                await self.initDebtors(tripId: currentTrip.id, storeId: currentFoodStore.id)
                self.chatsWithStorePayer = await self.getChatWithStorePayer(tripId: currentTrip.id, storeId: currentFoodStore.id, debtorUserIds: self.debtors.map({$0.user.id}))
                await self.setRecipeImage()
                self.updatePriceAmount()
                DispatchQueue.main.async {
                    self.storeView.memberWithFoodItemsTable.reloadData()
                    self.storeView.memberWithPaymentStatusTable.reloadData()
                    self.hideActivityIndicator()
                    
                }
                
            }
        } else {
            showErrorAlert(message: "Cannot load food store. Please try again later.", controller: self)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storeView.storeDateLabel.text = currentFoodStore!.dateCreated.formatted()
        
        storeView.memberWithFoodItemsTable.delegate = self
        storeView.memberWithFoodItemsTable.dataSource = self
        storeView.memberWithFoodItemsTable.separatorStyle = .none
        
        storeView.memberWithPaymentStatusTable.dataSource = self
        storeView.memberWithPaymentStatusTable.delegate = self
        storeView.memberWithPaymentStatusTable.separatorStyle = .none
        
        let editTripIcon = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(onTripEditClick))
       
        
        navigationItem.rightBarButtonItems = [editTripIcon]
        
        notificationCenter.addObserver(self, selector: #selector(notificationReceivedForStoreEdit(notification:)) , name: Notification.Name(NotificationConfigs.UpdatedFoodStoreObserverName), object: nil)
    }
    
    @objc func onTripEditClick() {
        let editStoreScreenController = StoreFormScreenController()
        editStoreScreenController.selectedFoodStore = currentFoodStore!
        editStoreScreenController.currentTrip = currentTrip!
        self.navigationController?.pushViewController(editStoreScreenController, animated: true)
    }
    
    @objc func notificationReceivedForStoreEdit(notification: Notification) {
        let newFoodStore = notification.object as! FoodStore
        currentFoodStore = newFoodStore
    }
    
    func setRecipeImage() async {
        if let currentFoodStore {
            if let imageURL = URL(string: currentFoodStore.recipeImage) {
                await storeView.foodStoreImageView.loadRemoteImage(from: imageURL)
            }
        }
    }
    
    func updatePriceAmount() {
        var totalCostFromDebtors: Double = 0
        for memberWithFoodItem in membersFoodItems {
            totalCostFromDebtors += memberWithFoodItem.submittedFoodItems!.reduce(0) { $0 + $1.price }
        }
        storeView.totalCostAmountLabel.text = " $\(roundToTwoPlace(totalCostFromDebtors))"
    }
    
    func getTotalStoreItemsCost() -> Double {
        return roundToTwoPlace(currentFoodStore!.foodItems.reduce(0) { $0 + $1.price })
    }
    
    func onDebtorChat(selectedDebtorUser: FirestoreUser) {
        let messagingVC = MessagingViewController()
        messagingVC.currentStore = FoodStoreFromDoc(id: currentFoodStore!.id, storeName: currentFoodStore!.storeName, address: currentFoodStore!.address, recipeImage: currentFoodStore!.recipeImage, dateCreated: currentFoodStore!.dateCreated, submitterId: currentFoodStore!.submitter.id)
        messagingVC.tripId = currentTrip!.id
        messagingVC.currentUser = currentUser
        messagingVC.opponentUser = selectedDebtorUser
        
        if let chatsWithStorePayer {
            messagingVC.currentChat = chatsWithStorePayer.first(where: { $0.id == selectedDebtorUser.id })
        } else {
            showErrorAlert(message: "Unknown error. Please try again later.", controller: self)
            return
        }
        
        navigationController?.pushViewController(messagingVC, animated: true)
    }
    
    func getChatOption(selectedUser: FirestoreUser) -> UIMenu {
        let menuItems = [
                    UIAction(title: "Chat",handler: {(_) in
                        self.onDebtorChat(selectedDebtorUser: selectedUser)
                    })
                ]
                
        return UIMenu(title: "Option", children: menuItems)
    }
}

extension StoreDetailsController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (tableView == storeView.memberWithFoodItemsTable) {
            return membersFoodItems.count
        }
        
        if (tableView == storeView.memberWithPaymentStatusTable) {
            return debtors.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(tableView == storeView.memberWithFoodItemsTable) {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableConfigs.foodItemMember, for: indexPath) as! StoreMemberCell
            let memberWithItems = membersFoodItems[indexPath.row]
            
            cell.userNameLabel.text = memberWithItems.name
            cell.messageButtonImage.menu = getChatOption(selectedUser: memberWithItems)
            if let submittedFoodItems = memberWithItems.submittedFoodItems {
                cell.totalItemCostLabel.text = "$ \(roundToTwoPlace(submittedFoodItems.reduce(0) { $0 + $1.price }))"
                cell.submittedFoodItems = submittedFoodItems
            }
            cell.innerTable.reloadData()
            
            return cell
        }
        
        if (tableView == storeView.memberWithPaymentStatusTable) {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableConfigs.foodItemDebtor, for: indexPath) as! DebtorTableCell
            cell.debtorNameLabel.text = debtors[indexPath.row].user.name
            cell.debtorPaymentStatusLabel.text =  debtors[indexPath.row].paymentStatus.rawValue
            
            switch (debtors[indexPath.row].paymentStatus) {
            case PaymentStatus.dispute:
                cell.debtorPaymentStatusLabel.textColor = .red
            case PaymentStatus.paid:
                cell.debtorPaymentStatusLabel.textColor = .green
            case PaymentStatus.pending:
                cell.debtorPaymentStatusLabel.textColor = .black
            }
            
            return cell
        }
        
        // MARK: indicates a invalid table view
        return UserCell()
    }
    
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if (tableView == storeView.otherUsersTable) {
//            let user = storeOtherUsers[indexPath.row]
//            let numberOfStores = user.submittedStores?.count ?? 0
//            let innerTableHeight = CGFloat(numberOfStores) * (60 + 10) // Inner table row height * number of stores
//            let nameLabelHeight: CGFloat = 50 // Adjust based on your label's design
//
//            return nameLabelHeight + innerTableHeight
//        }
//        
//        if (tableView == storeView.foodStoreTable) {
//            return 104
//        }
//        
//        return 100
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // MARK: on current trip box click -> navigate to food store details
    }
}

extension StoreDetailsController:ProgressSpinnerDelegate{
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
