//
//  UserSearchBottmSheetController.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 11/7/24.
//

import UIKit
import FirebaseFirestore

class UserSearchBottmSheetController: UIViewController {

    let searchSheet = UserSearchBottomSheetView()
    let database = Firestore.firestore()
    let notificationCenter = NotificationCenter.default
        
        //MARK: the list of names...
    var appUsers = [FirestoreUser]()
        
        //MARK: the array to display the table view...
        var usersForTableView = [FirestoreUser]()
        
        override func loadView() {
            view = searchSheet
        }
        override func viewDidLoad() {
            super.viewDidLoad()
            
            
            
            //MARK: setting up Table View data source and delegate...
            searchSheet.tableViewSearchResults.delegate = self
            searchSheet.tableViewSearchResults.dataSource = self
            
            //MARK: setting up Search Bar delegate...
            searchSheet.searchBar.delegate = self
            
            getAllUsers()
        }
    }

    //MARK: adopting Table View protocols...
    extension UserSearchBottmSheetController: UITableViewDelegate, UITableViewDataSource{
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return usersForTableView.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: TableConfigs.searchUserTable, for: indexPath) as! UserSearchTableViewCell
            
            cell.labelTitle.text = usersForTableView[indexPath.row].name
            cell.labelUserEmail.text = "Email:  \(usersForTableView[indexPath.row].email)"
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedUser: FirestoreUser = usersForTableView[indexPath.row]
            
            notificationCenter.post(
                name: Notification.Name(NotificationConfigs.UserSelectedObserverName),
                object: selectedUser)
            
        }
    }

    //MARK: adopting the search bar protocol...
    extension UserSearchBottmSheetController: UISearchBarDelegate{
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchText == ""{
                self.usersForTableView = appUsers
            }else{
                self.usersForTableView.removeAll()

                for user in appUsers{
                    if user.name.contains(searchText) || user.email.contains(searchText){
                        self.usersForTableView.append(user)
                    }
                }
            }
            self.searchSheet.tableViewSearchResults.reloadData()
        }
    }
