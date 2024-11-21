//
//  TripView.swift
//  BeAnywhere
//
//  Created by Evelyn Xiao on 11/19/24.
//

import UIKit

class TripView: UIView {
    
    var paidByOthersLabel: UILabel!
    var totalCost: UILabel!
    var otherUsersTable: UITableView!
    
    var scrollView: UIScrollView!
    var contentView: UIView!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupScrollView()
        setUpLabels()
        setupOtherUsers()
        initConstraints()
    }
    
    func setupScrollView(){
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(scrollView)
        
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
    }
    
    func setUpLabels() {
        paidByOthersLabel = UILabel()
        paidByOthersLabel.text = "Paid by others"
        paidByOthersLabel.font = UIFont.boldSystemFont(ofSize: 15)
        paidByOthersLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(paidByOthersLabel)
        
        totalCost = UILabel()
        totalCost.text = "$0.00"
        totalCost.font = UIFont.boldSystemFont(ofSize: 15)
        totalCost.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(totalCost)
    }
    
    func setupOtherUsers(){
        otherUsersTable = UITableView()
        otherUsersTable.register(UserCell.self, forCellReuseIdentifier: TableConfigs.otherUsers)
        otherUsersTable.translatesAutoresizingMaskIntoConstraints = false
        otherUsersTable.rowHeight = UITableView.automaticDimension
        otherUsersTable.separatorStyle = .none
        contentView.addSubview(otherUsersTable)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            
            
            paidByOthersLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            paidByOthersLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            totalCost.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            totalCost.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            otherUsersTable.topAnchor.constraint(equalTo: paidByOthersLabel.bottomAnchor, constant: 10),
            otherUsersTable.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            otherUsersTable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            otherUsersTable.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            otherUsersTable.heightAnchor.constraint(greaterThanOrEqualToConstant: 200),
            
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
