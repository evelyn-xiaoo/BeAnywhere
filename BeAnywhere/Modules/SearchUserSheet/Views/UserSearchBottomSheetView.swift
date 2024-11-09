//
//  UserSearchBottomSheetView.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 11/7/24.
//

import UIKit

class UserSearchBottomSheetView: UIView {
    var searchBar: UISearchBar!
        var tableViewSearchResults: UITableView!
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            self.backgroundColor = .white
            
            //MARK: Search Bar...
            searchBar = UISearchBar()
            searchBar.placeholder = "Search names or emails"
            searchBar.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(searchBar)
            
            //MARK: Table view...
            tableViewSearchResults = UITableView()
            tableViewSearchResults.register(UserSearchTableViewCell.self, forCellReuseIdentifier: TableConfigs.searchUserTable)
            tableViewSearchResults.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(tableViewSearchResults)
            
            //MARK: constraints...
            NSLayoutConstraint.activate([
                searchBar.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
                searchBar.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                searchBar.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
                
                tableViewSearchResults.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
                tableViewSearchResults.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
                tableViewSearchResults.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor),
                tableViewSearchResults.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor),
            ])
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
}
