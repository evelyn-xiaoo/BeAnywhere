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
    
    let childProgressView = ProgressSpinnerViewController()
    var items: [FoodItemFromDoc] = []
    var database = Firestore.firestore()
    let firebaseAuth = Auth.auth()
    var tripId: String = ""
    
    var textFieldBottomConstraint: NSLayoutConstraint!
    
    // MARK: a list of messages that get tracked in real time
    var currentMessages: [Message] = []
    
    // MARK: a variables that need to be initialized from other calls
    var currentChat: Chat? = nil
    var currentStore: FoodStoreFromDoc? = nil
    var currentUser: FirestoreUser? = nil
    var opponentUser: FirestoreUser? = nil
    
    override func loadView() {
        view = msgView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let opponentUser {
            title = opponentUser.name
        }
        msgView.itemsTable.delegate = self
        msgView.itemsTable.dataSource = self
        
        msgView.dropDownView.delegate = self
        msgView.dropDownView.dataSource = self
        
        msgView.messagesTable.delegate = self
        msgView.messagesTable.dataSource = self
        msgView.messagesTable.separatorStyle = .none
        
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
        
        self.msgView.msgSendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showActivityIndicator()
        if let store = currentStore {
            if let currentChat {
                setMessageObserver(storeId: store.id, chat: currentChat)
                Task{
                    await self.initItems(tripId: self.tripId, storeId: store.id)
                    DispatchQueue.main.async {
                        self.msgView.itemsTable.reloadData()
                    }
                    self.hideActivityIndicator()
                }
            } else {
                showErrorAlert(message: "Unknown error occurred. Please try again later.", controller: self)
            }
        } else {
            showErrorAlert(message: "Unknown error occurred. Please try again later.", controller: self)
        }
        hideActivityIndicator()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.size.height

            UIView.animate(withDuration: 0.3) {
                // Adjust the bottom constraint by the keyboard height
                self.textFieldBottomConstraint.constant = -keyboardHeight
                self.msgView.textField.layer.zPosition = 1
                self.msgView.msgSendButton.layer.zPosition = 1
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            // Reset the bottom constraint to its original value
            self.textFieldBottomConstraint.constant = -40
            self.msgView.textField.layer.zPosition = 0
            self.msgView.msgSendButton.layer.zPosition = 0
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc func sendMessage() {
        if let messageContent = msgView.textField.text {
            Task.detached {
                await self.sendMessage(tripId: self.tripId, storeId: self.currentStore!.id, chatId: self.currentChat!.id, content: messageContent)
            }
        } else {
            showErrorAlert(message: "Unknown error. Please try again.", controller: self)
        }
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
        } else if tableView == msgView.messagesTable {
            return currentMessages.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == msgView.itemsTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableConfigs.message, for: indexPath) as! MessagingCell
            let item = msgGroups[indexPath.row]
            cell.itemLabel.text = item
            return cell
        } else if tableView == msgView.messagesTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableConfigs.tableViewMessages, for: indexPath) as! MessageTableViewCell
            
            if (currentUser!.id == currentMessages[indexPath.row].submitter.id) {
                // Current user's message
                cell.wrapperCellView.backgroundColor = .blue
                cell.userNameLabel.textColor = .white
                cell.messageDateLabel.textColor = .white
                cell.messageContentLabel.textColor = .white
                
            } else {
                // Other user's message
                cell.wrapperCellView.backgroundColor = .white
                cell.userNameLabel.textColor = .black
                cell.messageDateLabel.textColor = .black
                cell.messageContentLabel.textColor = .black
                
            }
            
            cell.userNameLabel.text = currentMessages[indexPath.row].submitter.name
            cell.messageDateLabel.text = currentMessages[indexPath.row].dateCreated.formatted()
            cell.messageContentLabel.text = currentMessages[indexPath.row].content
            
            if let avatarImageUrl = URL(string: currentMessages[indexPath.row].submitter.avatarURL) {
                Task.detached {
                    await cell.userAvatarImage.loadRemoteImage(from: avatarImageUrl)
                }
            }
         
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TableConfigs.selectDropdown, for: indexPath) as! DropdownCell
        let item = items[indexPath.row]
        cell.itemLabel.text = item.name
        
        return cell
    }
}

extension MessagingViewController:ProgressSpinnerDelegate{
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

