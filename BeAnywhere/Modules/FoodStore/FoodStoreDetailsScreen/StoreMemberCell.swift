//
//  StoreMemberCell.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 11/23/2024.
//

import UIKit

class StoreMemberCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {
    var wrapperCellView: UIView!
    var userNameLabel: UILabel!
    var totalItemCostLabel: UILabel!
    var messageButtonImage: UIImageView!
    var innerTable: UITableView!
    var navigationController: UINavigationController!
    var tripId: String!
    
    
    // put this info into inner table
    var submittedFoodItems: [FoodItem] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        setupWrapperCellView()
        setupLabels()
        setupTable()
        setupButtonImage()
        initConstraints()
    }
    
    func setupWrapperCellView() {
        wrapperCellView = UIView()
        wrapperCellView.backgroundColor = .white
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(wrapperCellView)
    }
    
    func setupTable() {
        innerTable = UITableView()
        innerTable.backgroundColor = .white
        innerTable.translatesAutoresizingMaskIntoConstraints = false
        innerTable.register(FoodItemInStoreCell.self, forCellReuseIdentifier: TableConfigs.foodItemInStoreDetails)
        innerTable.dataSource = self
        innerTable.delegate = self
        innerTable.separatorStyle = .none
        wrapperCellView.addSubview(innerTable)
    }
    
    func setupButtonImage() {
        messageButtonImage = UIImageView()
        
        messageButtonImage.image = UIImage(systemName: "message")?.withRenderingMode(.alwaysOriginal)
        messageButtonImage.tintColor = .black
        messageButtonImage.contentMode = .scaleToFill
        messageButtonImage.clipsToBounds = true
        messageButtonImage.layer.masksToBounds = true
        messageButtonImage.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(messageButtonImage)
    }
    
    func setupLabels() {
        userNameLabel = UILabel()
        totalItemCostLabel = UILabel()
        
        let labels: [UILabel] = [userNameLabel, totalItemCostLabel]
        
        for label: UILabel in labels {
            label.textColor = .black
            label.font = .systemFont(ofSize: 16, weight: .regular)
            label.translatesAutoresizingMaskIntoConstraints = false
            wrapperCellView.addSubview(label)
        }
    }
    
    
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            wrapperCellView.topAnchor.constraint(equalTo: self.topAnchor),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            wrapperCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            
            messageButtonImage.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 10),
            messageButtonImage.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 10),
            
            userNameLabel.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 10),
            userNameLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 150),
            userNameLabel.leadingAnchor.constraint(equalTo: messageButtonImage.trailingAnchor, constant: 10),
            
            totalItemCostLabel.topAnchor.constraint(equalTo: userNameLabel.topAnchor),
            totalItemCostLabel.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -20),
            totalItemCostLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 80),
            
            innerTable.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 0),
            innerTable.leadingAnchor.constraint(equalTo: messageButtonImage.trailingAnchor),
            innerTable.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -10),
            innerTable.bottomAnchor.constraint(equalTo: wrapperCellView.bottomAnchor, constant: -50),
            
            ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension StoreMemberCell {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return submittedFoodItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableConfigs.foodItemInStoreDetails, for: indexPath) as! FoodItemInStoreCell
        let store = submittedFoodItems[indexPath.row]
        cell.itemNameLabel.text = store.name
        cell.itemCostLabel.text = "$ \(store.price)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    
}