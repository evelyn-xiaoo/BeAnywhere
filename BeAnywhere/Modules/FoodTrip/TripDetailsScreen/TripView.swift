//
//  TripView.swift
//  BeAnywhere
//
//  Created by Evelyn Xiao on 11/19/24.
//

import UIKit

class TripView: UIView {
    
    var addStoreButton: UIButton!
    var foodStoreTable: UITableView!
    var paidByMeLabel: UILabel!
    var totalReceivedLabel: UILabel!
    var noStorePaidByYouLabel: UILabel!
    
    var paidByOthersLabel: UILabel!
    var totalCost: UILabel!
    var otherUsersTable: UITableView!
    
    var scrollView: UIScrollView!
    var contentView: UIView!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupScrollView()
        setupaddStoreButton()
        setupPaidByYouTableViewTrips()
        setUpLabels()
        setupOtherUsersTableView()
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
    
    func setupaddStoreButton(){
        addStoreButton = UIButton(type: .system)
        addStoreButton.setTitle("Add+", for: .normal)
        addStoreButton.contentHorizontalAlignment = .fill
        addStoreButton.contentVerticalAlignment = .fill
        addStoreButton.imageView?.contentMode = .scaleAspectFit
        addStoreButton.layer.cornerRadius = 16
        addStoreButton.imageView?.layer.shadowOffset = .zero
        addStoreButton.imageView?.layer.shadowRadius = 0.8
        addStoreButton.imageView?.layer.shadowOpacity = 0.7
        addStoreButton.imageView?.clipsToBounds = true
        addStoreButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(addStoreButton)
    }
    
    func setUpLabels() {
        paidByMeLabel = UILabel()
        totalReceivedLabel = UILabel()
        paidByOthersLabel = UILabel()
        totalCost = UILabel()
        noStorePaidByYouLabel = UILabel()
        
        paidByMeLabel.font = UIFont.boldSystemFont(ofSize: 15)
        paidByMeLabel.text = "Paid by you"
        totalReceivedLabel.font = UIFont.boldSystemFont(ofSize: 12)
        
        paidByOthersLabel.text = "Paid by others"
        paidByOthersLabel.font = UIFont.boldSystemFont(ofSize: 15)
        
        totalCost.text = "$0.00"
        totalCost.font = UIFont.boldSystemFont(ofSize: 15)
        
        noStorePaidByYouLabel.font = UIFont.boldSystemFont(ofSize: 15)
        noStorePaidByYouLabel.numberOfLines = 0
        
        let appLabels: [UILabel] = [paidByMeLabel, totalReceivedLabel, paidByOthersLabel, totalCost, noStorePaidByYouLabel]
        
        // apply common attributes to the labels
        for label: UILabel in appLabels {
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            contentView.addSubview(label)
        }
    }
    
    func setupPaidByYouTableViewTrips(){
        foodStoreTable = UITableView()
        foodStoreTable.register(FoodStoreTableViewCell.self, forCellReuseIdentifier: TableConfigs.tableFoodStore)
        foodStoreTable.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(foodStoreTable)
    }
    
    func setupOtherUsersTableView(){
        otherUsersTable = UITableView()
        otherUsersTable.register(UserCell.self, forCellReuseIdentifier: TableConfigs.otherUsers)
        otherUsersTable.translatesAutoresizingMaskIntoConstraints = false
        otherUsersTable.rowHeight = UITableView.automaticDimension
        otherUsersTable.separatorStyle = .none
        contentView.addSubview(otherUsersTable)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
                    scrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
                    scrollView.widthAnchor.constraint(equalTo:self.safeAreaLayoutGuide.widthAnchor),
                    scrollView.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            paidByMeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25),
            paidByMeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            totalReceivedLabel.topAnchor.constraint(equalTo: paidByMeLabel.topAnchor),
            totalReceivedLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            noStorePaidByYouLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            noStorePaidByYouLabel.topAnchor.constraint(equalTo: paidByMeLabel.bottomAnchor, constant: 32),
            
            foodStoreTable.topAnchor.constraint(equalTo: paidByMeLabel.bottomAnchor, constant: 16),
            foodStoreTable.bottomAnchor.constraint(equalTo: addStoreButton.topAnchor, constant: -8),
            foodStoreTable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            foodStoreTable.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            
            
            addStoreButton.bottomAnchor.constraint(equalTo: paidByOthersLabel.topAnchor, constant:-32),
            addStoreButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            paidByOthersLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            paidByOthersLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            totalCost.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            totalCost.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            otherUsersTable.topAnchor.constraint(equalTo: paidByOthersLabel.bottomAnchor, constant: 20),
            otherUsersTable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            otherUsersTable.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            otherUsersTable.heightAnchor.constraint(greaterThanOrEqualToConstant: 200),
            
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
