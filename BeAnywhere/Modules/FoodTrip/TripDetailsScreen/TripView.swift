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
        addStoreButton.setTitleColor(.black, for: .normal)
        addStoreButton.layer.borderWidth = 1
        addStoreButton.layer.borderColor = UIColor.black.cgColor
        
        //addStoreButton.contentHorizontalAlignment = .fill
        //addStoreButton.contentVerticalAlignment = .fill
        //addStoreButton.imageView?.contentMode = .scaleAspectFit
        //addStoreButton.layer.cornerRadius = 16
        //addStoreButton.imageView?.layer.shadowOffset = .zero
        //addStoreButton.imageView?.layer.shadowRadius = 0.8
        //addStoreButton.imageView?.layer.shadowOpacity = 0.7
        //addStoreButton.imageView?.clipsToBounds = true
        addStoreButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(addStoreButton)
    }
    
    func setUpLabels() {
        paidByMeLabel = UILabel()
        totalReceivedLabel = UILabel()
        paidByOthersLabel = UILabel()

        noStorePaidByYouLabel = UILabel()
        
        paidByMeLabel.font = UIFont.boldSystemFont(ofSize: 15)
        paidByMeLabel.text = "Paid by you"
        totalReceivedLabel.font = UIFont.systemFont(ofSize: 15)
        
        paidByOthersLabel.text = "Paid by others"
        paidByOthersLabel.font = UIFont.boldSystemFont(ofSize: 15)
        
        noStorePaidByYouLabel.font = UIFont.boldSystemFont(ofSize: 15)
        noStorePaidByYouLabel.numberOfLines = 0
        
        
        let appLabels: [UILabel] = [paidByMeLabel, totalReceivedLabel, paidByOthersLabel, noStorePaidByYouLabel]
        
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
        foodStoreTable.rowHeight = 75
        foodStoreTable.isScrollEnabled = false
        contentView.addSubview(foodStoreTable)
    }
    
    func setupOtherUsersTableView(){
        otherUsersTable = UITableView()
        otherUsersTable.register(UserCell.self, forCellReuseIdentifier: TableConfigs.otherUsers)
        otherUsersTable.translatesAutoresizingMaskIntoConstraints = false
        otherUsersTable.rowHeight = UITableView.automaticDimension
        otherUsersTable.separatorStyle = .none
        otherUsersTable.isScrollEnabled = false
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
            
            paidByMeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            paidByMeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            totalReceivedLabel.topAnchor.constraint(equalTo: paidByMeLabel.topAnchor),
            totalReceivedLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            noStorePaidByYouLabel.centerXAnchor.constraint(equalTo: foodStoreTable.centerXAnchor),
            noStorePaidByYouLabel.topAnchor.constraint(equalTo: paidByMeLabel.bottomAnchor, constant: 40),
            noStorePaidByYouLabel.bottomAnchor.constraint(equalTo: addStoreButton.topAnchor, constant: -40),
            
            foodStoreTable.topAnchor.constraint(equalTo: paidByMeLabel.bottomAnchor, constant: 10),
            foodStoreTable.leadingAnchor.constraint(equalTo: paidByMeLabel.leadingAnchor, constant: 20),
            foodStoreTable.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            //foodStoreTable.bottomAnchor.constraint(equalTo: addStoreButton.topAnchor, constant: -20),
            foodStoreTable.heightAnchor.constraint(greaterThanOrEqualToConstant: 200),
            
            addStoreButton.topAnchor.constraint(equalTo: foodStoreTable.bottomAnchor, constant: 20),
            addStoreButton.leadingAnchor.constraint(equalTo: foodStoreTable.leadingAnchor),
            addStoreButton.trailingAnchor.constraint(equalTo: foodStoreTable.trailingAnchor),
            addStoreButton.widthAnchor.constraint(equalTo: foodStoreTable.widthAnchor),
            addStoreButton.heightAnchor.constraint(equalToConstant: 40),
            
            paidByOthersLabel.topAnchor.constraint(equalTo: addStoreButton.bottomAnchor, constant: 40),
            paidByOthersLabel.leadingAnchor.constraint(equalTo: paidByMeLabel.leadingAnchor),
            
            
            otherUsersTable.topAnchor.constraint(equalTo: paidByOthersLabel.bottomAnchor, constant: 10),
            otherUsersTable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            otherUsersTable.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            otherUsersTable.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            otherUsersTable.heightAnchor.constraint(greaterThanOrEqualToConstant: 200),
            
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
