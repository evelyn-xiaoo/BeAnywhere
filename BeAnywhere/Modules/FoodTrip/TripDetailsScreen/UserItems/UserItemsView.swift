//
//  UserItemsView.swift
//  BeAnywhere
//
//  Created by Evelyn Xiao on 11/21/24.
//

import UIKit

class UserItemsView: UIView {

    var didPay: UIButton!
    var itemsTable: UITableView!
    var yourItemsLabel: UILabel!
    var noSelectedItems: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupComponents()
        initConstraints()
    }
    
    func setupComponents() {
        yourItemsLabel = UILabel()
        yourItemsLabel.text = "Your Items"
        yourItemsLabel.font = .systemFont(ofSize: 14)
        yourItemsLabel.textColor = .black
        yourItemsLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(yourItemsLabel)
        
        noSelectedItems = UILabel()
        noSelectedItems.text = "No items selected"
        noSelectedItems.font = .systemFont(ofSize: 14)
        noSelectedItems.textColor = .black
        noSelectedItems.translatesAutoresizingMaskIntoConstraints = false
        noSelectedItems.textAlignment = .center
        addSubview(noSelectedItems)
        
        didPay = UIButton()
        didPay.titleLabel?.font = .systemFont(ofSize: 14)
        didPay.setTitleColor(.green, for: .normal)
        didPay.layer.cornerRadius = 20
        didPay.layer.borderWidth = 1
        didPay.layer.borderColor = UIColor.green.cgColor
        didPay.translatesAutoresizingMaskIntoConstraints = false
        didPay.titleLabel?.numberOfLines = 0
        addSubview(didPay)
        
        itemsTable = UITableView()
        itemsTable.translatesAutoresizingMaskIntoConstraints = false
        itemsTable.register(UserItemsCell.self, forCellReuseIdentifier: TableConfigs.selectedItems)
        itemsTable.separatorStyle = .none
        itemsTable.rowHeight = 85
        addSubview(itemsTable)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            yourItemsLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            yourItemsLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            noSelectedItems.topAnchor.constraint(equalTo: yourItemsLabel.bottomAnchor, constant: 20),
            noSelectedItems.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            noSelectedItems.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8),
            
            itemsTable.topAnchor.constraint(equalTo: noSelectedItems.bottomAnchor, constant: 0),
            itemsTable.leadingAnchor.constraint(equalTo: yourItemsLabel.leadingAnchor),
            itemsTable.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            itemsTable.bottomAnchor.constraint(equalTo: didPay.topAnchor, constant: -20),
            
            didPay.topAnchor.constraint(equalTo: itemsTable.bottomAnchor),
            didPay.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            didPay.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
