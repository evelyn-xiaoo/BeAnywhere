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
        /*
        //working with the shadows and colors...
        wrapperCellView.backgroundColor = .white
        wrapperCellView.layer.cornerRadius = 4.0
        wrapperCellView.layer.shadowColor = UIColor.gray.cgColor
        wrapperCellView.layer.shadowOffset = .zero
        wrapperCellView.layer.shadowRadius = 2.0
        wrapperCellView.layer.shadowOpacity = 0.7
         */
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(wrapperCellView)
    }
    
    func setupLabelName(){
        itemNameLabel = UILabel()
        itemCostLabel = UILabel()
        
        let labels: [UILabel] = [itemNameLabel, itemCostLabel]
        
        for label: UILabel in labels {
            label.font = UIFont.systemFont(ofSize: 14)
            label.translatesAutoresizingMaskIntoConstraints = false
            wrapperCellView.addSubview(label)
        }
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            wrapperCellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            wrapperCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            
            itemNameLabel.centerYAnchor.constraint(equalTo: wrapperCellView.centerYAnchor),
            itemNameLabel.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 0),
            
            itemCostLabel.topAnchor.constraint(equalTo: itemNameLabel.topAnchor),
            itemCostLabel.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: 0),

            
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
