//
//  FoodItemInStoreCell.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 11/4/24.
//

import UIKit

class FoodItemInStoreCell: UITableViewCell {
    
    var wrapperCellView: UIView!
    var itemNameLabel: UILabel!
    var itemCostLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupWrapperCellView()
        setupLabelName()
        
        initConstraints()
    }

    func setupWrapperCellView(){
        wrapperCellView = UIView()
        
        //working with the shadows and colors...
        wrapperCellView.backgroundColor = .white
        wrapperCellView.layer.cornerRadius = 4.0
        wrapperCellView.layer.shadowColor = UIColor.gray.cgColor
        wrapperCellView.layer.shadowOffset = .zero
        wrapperCellView.layer.shadowRadius = 2.0
        wrapperCellView.layer.shadowOpacity = 0.7
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(wrapperCellView)
    }
    
    func setupLabelName(){
        itemNameLabel = UILabel()
        itemCostLabel = UILabel()
        
        let labels: [UILabel] = [itemNameLabel, itemCostLabel]
        
        for label: UILabel in labels {
            label.font = UIFont.boldSystemFont(ofSize: 14)
            label.translatesAutoresizingMaskIntoConstraints = false
            wrapperCellView.addSubview(label)
        }
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            wrapperCellView.topAnchor.constraint(equalTo: self.topAnchor,constant: 4),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            wrapperCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
            
            itemNameLabel.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 8),
           
            itemNameLabel.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 8),
            itemNameLabel.heightAnchor.constraint(equalToConstant: 15),
            itemNameLabel.widthAnchor.constraint(equalTo: wrapperCellView.widthAnchor),
            
            itemCostLabel.topAnchor.constraint(equalTo: itemNameLabel.bottomAnchor, constant: 8),
            itemCostLabel.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 8),
            itemCostLabel.heightAnchor.constraint(equalToConstant: 15),
            itemCostLabel.widthAnchor.constraint(equalTo: wrapperCellView.widthAnchor),
            
            wrapperCellView.heightAnchor.constraint(equalToConstant: 54)
            
        ])
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
