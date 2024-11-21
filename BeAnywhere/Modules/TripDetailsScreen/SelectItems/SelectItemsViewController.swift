//
//  OthersStoreViewController.swift
//  BeAnywhere
//
//  Created by Evelyn Xiao on 11/20/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class SelectItemsViewController: UIViewController {
    let storeView = SelectItemsView()
    var store: FoodStoreFromDoc? = nil
    var tripId: String = ""
    var database = Firestore.firestore()
    var firebaseAuth = Auth.auth()
    var delegate: UserItemsViewController!
    
    var items: [FoodItemFromDoc] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view = storeView
        // Do any additional setup after loading the view.
        
        
        
        storeView.itemsTable.delegate = self
        storeView.itemsTable.dataSource = self
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveSelections))
        
        storeView.msgButton.addTarget(self, action: #selector(msgButtonTapped), for: .touchUpInside)
    }
    
    @objc func msgButtonTapped() {
        let messagingVC = MessagingViewController()
        messagingVC.currentStore = store
        messagingVC.tripId = tripId
        messagingVC.items = items
        
        if let store {
            // need to send the submitterId
            //messagingVC.sendToId = store.submitterId
            navigationController?.pushViewController(messagingVC, animated: true)
        }
    }
    
    
    @objc func saveSelections() {
        print("Saving food item selections")
        
        guard let currUser = firebaseAuth.currentUser else {
            print("Error: Current user not authenticated.")
            return
        }
        guard let delegate = delegate else {
            print("Error: delegate is nil")
            return
        }
        
        // Filter items where the current user is a payer
        let selectedItems = items.filter {
            $0.payerUserIds.contains(currUser.uid)
        }
        
        
        if selectedItems.isEmpty {
            let alert = UIAlertController(
                title: "No Items Selected",
                message: "Please select at least one item to submit.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        // Update Firestore with selected items
        if let store = store {
            Task {
                await self.saveFoodItemSelections(selectedItems: selectedItems, tripId: self.tripId, storeId: store.id)
                print("saving size: \(selectedItems.count)")
                await delegate.refreshItems(newItems: selectedItems)
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let store {
            title = store.storeName
            
            Task.detached{
                await self.initFoodItems(tripId: self.tripId, storeId: store.id)
                DispatchQueue.main.async {
                    self.storeView.itemsTable.reloadData()
                }
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SelectItemsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableConfigs.foodItem, for: indexPath) as! ItemCell
        let item = items[indexPath.row]
        
        cell.itemName.text = item.name
        cell.foodImageURL = item.foodImageUrl
        cell.price.text = "\(item.price)"
        cell.payersIds = item.payerUserIds
        
        // setting checked boxes
        if let currUser = firebaseAuth.currentUser, item.payerUserIds.contains(currUser.uid) {
            cell.isMyItem = true
            cell.checkBox.setImage(
                UIImage(systemName: "checkmark.square.fill")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal),
                for: .normal
            )
        } else {
            cell.isMyItem = false
            cell.checkBox.setImage(
                UIImage(systemName: "square.fill")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal),
                for: .normal
            )
        }
        
        
        // display payer names for each item
        Task {
            var payerNames: [String] = []
            if item.payerUserIds.count != 0 {
                for payerId in item.payerUserIds {
                    if let name = await self.getUserName(userId: payerId) {
                        payerNames.append(name)
                    }
                }
                
                DispatchQueue.main.async {
                    cell.payersLabel.text = payerNames.joined(separator: ", ")
                    self.storeView.itemsTable.reloadData()
                }
            }
            else {
                cell.payersLabel.text = ""
            }
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selecting row")
        
        // Get the reference to the item in the items array
        var item = items[indexPath.row]
        
        guard let cell = tableView.cellForRow(at: indexPath) as? ItemCell else {
            print("Could not find cell for indexPath")
            return
        }
        
        // Toggle the item state
        cell.isMyItem.toggle()
        
        if cell.isMyItem {
            print("This is my item")
            
            // Add the current user to payerUserIds
            if let currUser = firebaseAuth.currentUser, !item.payerUserIds.contains(currUser.uid) {
                items[indexPath.row].payerUserIds.append(currUser.uid) // Update the items array
            }
            
            // Update cell UI
            cell.payersIds = items[indexPath.row].payerUserIds
            cell.checkBox.setImage(
                UIImage(systemName: "checkmark.square.fill")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal),
                for: .normal
            )
        } else {
            print("This is not my item: curr size = \(items[indexPath.row].payerUserIds.count)")
            
            // Remove the current user from payerUserIds
            if let currUser = firebaseAuth.currentUser {
                items[indexPath.row].payerUserIds.removeAll { $0 == currUser.uid } // Update the items array
            }
            print("This is not my item: new size = \(items[indexPath.row].payerUserIds.count)")
            // Update cell UI
            cell.payersIds = items[indexPath.row].payerUserIds
            cell.checkBox.setImage(
                UIImage(systemName: "square.fill")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal),
                for: .normal
            )
        }
        
        // Fetch and update payer names
        Task {
            var payerNames: [String] = []
            for payerId in items[indexPath.row].payerUserIds {
                if let name = await self.getUserName(userId: payerId) {
                    payerNames.append(name)
                }
            }
            DispatchQueue.main.async {
                cell.payersLabel.text = payerNames.joined(separator: ", ")
            }
        }
    }
    
}
