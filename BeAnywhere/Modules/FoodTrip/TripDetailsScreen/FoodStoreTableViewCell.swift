//
//  FoodStoreTableViewCell.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 11/4/24.
//

import UIKit

class FoodStoreTableViewCell: UITableViewCell {
    
    var wrapperCellView: UIView!
    var storeNameLabel: UILabel!
    var storeDateLabel: UILabel!
    var storeAddressLabel: UILabel!
    var storeFoodCostLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupWrapperCellView()
        setupLabelName()
        
        initConstraints()
    }

    func setupWrapperCellView(){
        wrapperCellView = UIView()
        wrapperCellView.layer.borderColor = UIColor.black.cgColor
        wrapperCellView.layer.borderWidth = 1
        
        //working with the shadows and colors...
        //wrapperCellView.backgroundColor = .white
        //wrapperCellView.layer.cornerRadius = 4.0
        //wrapperCellView.layer.shadowColor = UIColor.gray.cgColor
        //wrapperCellView.layer.shadowOffset = .zero
        //wrapperCellView.layer.shadowRadius = 2.0
        //wrapperCellView.layer.shadowOpacity = 0.7
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(wrapperCellView)
    }
    
    func setupLabelName(){
        storeNameLabel = UILabel()
        storeDateLabel = UILabel()
        storeAddressLabel = UILabel()
        storeFoodCostLabel = UILabel()
        
        let labels: [UILabel] = [storeNameLabel, storeDateLabel, storeAddressLabel, storeFoodCostLabel]
        
        for label: UILabel in labels {
            label.font = UIFont.systemFont(ofSize: 14)
            label.translatesAutoresizingMaskIntoConstraints = false
            wrapperCellView.addSubview(label)
        }
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            wrapperCellView.topAnchor.constraint(equalTo: self.topAnchor,constant: 0),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            wrapperCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            
            storeNameLabel.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 5),
            storeNameLabel.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 10),
            
            storeDateLabel.topAnchor.constraint(equalTo: storeNameLabel.bottomAnchor, constant: 2),
            storeDateLabel.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 10),
            
            storeAddressLabel.topAnchor.constraint(equalTo: storeDateLabel.bottomAnchor, constant: 2),
            storeAddressLabel.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 10),
            
            storeFoodCostLabel.topAnchor.constraint(equalTo: storeAddressLabel.bottomAnchor, constant: 2),
            storeFoodCostLabel.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 10),
            storeFoodCostLabel.bottomAnchor.constraint(equalTo: wrapperCellView.bottomAnchor, constant: -5),
            
            
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
