//
//  OthersStoreView.swift
//  BeAnywhere
//
//  Created by Evelyn Xiao on 11/20/24.
//

import UIKit

class SelectItemsView: UIView {
    
    var msgButton: UIButton!
    var selectItemsLabel: UILabel!
    var itemsTable: UITableView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupComponents()
        initConstraints()
    }
    
    func setupComponents() {
        msgButton = UIButton(type: .system)
        msgButton.setTitleColor(.black, for: .normal)
        msgButton.titleLabel?.font = .systemFont(ofSize: 14)
        msgButton.layer.cornerRadius = 20
        msgButton.layer.borderWidth = 1
        msgButton.titleLabel?.numberOfLines = 0
        msgButton.layer.borderColor = UIColor.red.cgColor
        msgButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(msgButton)
        
        selectItemsLabel = UILabel()
        selectItemsLabel.text = "Select your items"
        selectItemsLabel.font = .systemFont(ofSize: 14)
        selectItemsLabel.textColor = .black
        selectItemsLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(selectItemsLabel)
        
        itemsTable = UITableView()
        itemsTable.translatesAutoresizingMaskIntoConstraints = false
        itemsTable.register(ItemCell.self, forCellReuseIdentifier: TableConfigs.foodItem)
        itemsTable.separatorStyle = .none
        itemsTable.rowHeight = 85
        addSubview(itemsTable)
        
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            msgButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            msgButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            
            selectItemsLabel.topAnchor.constraint(equalTo: msgButton.bottomAnchor, constant: 20),
            selectItemsLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            
            itemsTable.topAnchor.constraint(equalTo: selectItemsLabel.bottomAnchor, constant: 10),
            itemsTable.leadingAnchor.constraint(equalTo: selectItemsLabel.leadingAnchor, constant: 10),
            itemsTable.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            itemsTable.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
