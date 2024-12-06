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
    var messageButtonImage: UIButton!
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
        innerTable.separatorStyle = .singleLine
        innerTable.rowHeight = 30
        wrapperCellView.addSubview(innerTable)
    }
    
    func setupButtonImage() {
        messageButtonImage = UIButton(type: .system)
        messageButtonImage.setTitle("", for: .normal)
        messageButtonImage.setImage(UIImage(systemName: "message")?.withRenderingMode(.alwaysOriginal), for: .normal)
        messageButtonImage.contentMode = .scaleToFill
        messageButtonImage.clipsToBounds = true
        messageButtonImage.layer.masksToBounds = true
        messageButtonImage.showsMenuAsPrimaryAction = true
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
            messageButtonImage.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 0),
            
            userNameLabel.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 10),
            userNameLabel.leadingAnchor.constraint(equalTo: messageButtonImage.trailingAnchor, constant: 10),
            
            totalItemCostLabel.topAnchor.constraint(equalTo: userNameLabel.topAnchor),
            totalItemCostLabel.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -20),
            
            innerTable.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 5),
            innerTable.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor, constant: 10),
            innerTable.trailingAnchor.constraint(equalTo: totalItemCostLabel.trailingAnchor),
            innerTable.bottomAnchor.constraint(equalTo: wrapperCellView.bottomAnchor, constant: -10),
            
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
