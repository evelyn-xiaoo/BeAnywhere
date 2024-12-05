//
//  UserItemsViewController.swift
//  BeAnywhere
//
//  Created by Evelyn Xiao on 11/21/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class UserItemsViewController: UIViewController {
    let userItemsView = UserItemsView()
    var store: FoodStoreFromDoc? = nil
    var tripId: String = ""
    var database = Firestore.firestore()
    var firebaseAuth = Auth.auth()
    var currUserId: String = ""
    var selectedItems: [FoodItemFromDoc] = []
    var done: Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let store {
            title = store.storeName
            
            Task.detached{
                await self.initFoodItems(tripId: self.tripId, storeId: store.id)
                DispatchQueue.main.async {
                    self.userItemsView.itemsTable.reloadData()
                }
            }
            
            
        }
    }
    
    @MainActor
    func refreshItems(newItems: [FoodItemFromDoc]) async {
        if let store = self.store {
            // Update selectedItems on the main actor
            self.selectedItems = newItems
            print("Sent back: \(self.selectedItems.count)")
            
            // Initialize food items
            await self.initFoodItems(tripId: self.tripId, storeId: store.id)
            
            // Reload the table view
            self.userItemsView.itemsTable.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view = userItemsView
        // Do any additional setup after loading the view.
        
        userItemsView.itemsTable.delegate = self
        userItemsView.itemsTable.dataSource = self
        
        
        navigationItem.title = store?.storeName
        
    }
    
    @objc func editTapped() {
        let editItemsVC = SelectItemsViewController()
        editItemsVC.store = store
        editItemsVC.tripId = tripId
        editItemsVC.delegate = self
        navigationController?.pushViewController(editItemsVC, animated: true)
    }
    
    @objc func didPayClicked() {
        let alert = UIAlertController(title: "Confirm", message: "Are you sure you paid?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] _ in
            
            if let storeId = self?.store?.id, let userId = self?.currUserId {
                Task {
                    await self?.markPaymentAsCompleted(storeId: storeId, userId: userId)
                }
            } else {
                print("Store ID or User ID is missing.")
            }

            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(alert, animated: true)
        
    }
    
    

}

extension UserItemsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableConfigs.selectedItems, for: indexPath) as! UserItemsCell
        let item = selectedItems[indexPath.row]
        
        
        cell.itemName.text = item.name
        cell.foodImageURL = item.foodImageUrl
        cell.price.text = "\(item.price)"
        cell.payersIds = item.payerUserIds
        
        
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
                    self.userItemsView.itemsTable.reloadData()
                }
            }
            else {
                cell.payersLabel.text = ""
            }
        }
        
        
        return cell
    }
    
    
}
