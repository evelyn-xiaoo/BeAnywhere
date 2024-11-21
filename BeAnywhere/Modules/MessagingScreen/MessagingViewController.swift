//
//  MessagingViewController.swift
//  BeAnywhere
//
//  Created by Evelyn Xiao on 11/20/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class MessagingViewController: UIViewController {
    
    let msgView = MessagingView()
    
    var msgGroups: [String] = []
    
    var items: [FoodItemFromDoc] = []
    var database = Firestore.firestore()
    let firebaseAuth = Auth.auth()
    var tripId: String = ""
    var currentStore: FoodStoreFromDoc? = nil
    
    var textFieldBottomConstraint: NSLayoutConstraint!
    
    override func loadView() {
        view = msgView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        msgView.itemsTable.delegate = self
        msgView.itemsTable.dataSource = self
        
        msgView.dropDownView.delegate = self
        msgView.dropDownView.dataSource = self
        
        textFieldBottomConstraint = msgView.textField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
                textFieldBottomConstraint.isActive = true
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        // Add tap gesture to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(sendMessage))
        
        self.msgView.selectItem.addTarget(self, action: #selector(toggleDropdown), for: .touchUpInside)
    
    }
    
    @objc func toggleDropdown() {
        UIView.animate(withDuration: 0.3) {
            self.msgView.dropDownView.isHidden.toggle()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let store = currentStore {
            Task{
                await self.initItems(tripId: self.tripId, storeId: store.id)
                DispatchQueue.main.async {
                    self.msgView.itemsTable.reloadData()
                }
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height

            UIView.animate(withDuration: 0.3) {
                // Adjust the bottom constraint by the keyboard height
                self.textFieldBottomConstraint.constant = -keyboardHeight
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            // Reset the bottom constraint to its original value
            self.textFieldBottomConstraint.constant = -40
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc func sendMessage() {
        
    }
}

extension MessagingViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == msgView.itemsTable {
            return msgGroups.count
        }
        else if tableView == msgView.dropDownView {
            print("num items = \(items.count)")
            return items.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == msgView.itemsTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableConfigs.message, for: indexPath) as! MessagingCell
            let item = msgGroups[indexPath.row]
            cell.itemLabel.text = item
            return cell
        }
        print("here")
        let cell = tableView.dequeueReusableCell(withIdentifier: TableConfigs.selectDropdown, for: indexPath) as! DropdownCell
        let item = items[indexPath.row]
        cell.itemLabel.text = item.name
        return cell
    }
}

