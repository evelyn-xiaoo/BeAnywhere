//
//  FoodItemTableViewCell.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 11/4/24.
//

import UIKit

class FoodItemTableViewCell: UITableViewCell {
    
    var wrapperCellView: UIView!
    var itemNameLabel: UILabel!
    var itemCostLabel: UILabel!
    var itemPayersLabel: UILabel!
    var itemImage:UIImageView!
    var checkBoxImage:UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupWrapperCellView()
        setupLabels()
        setupitemImage()
        
        initConstraints()
    }
    
    func setupitemImage(){
        itemImage = UIImageView()
        itemImage.image = UIImage(systemName: "fork.knife.circle")?.withRenderingMode(.alwaysOriginal) // MARK: Update this to use actual saved image
        itemImage.contentMode = .scaleToFill
        itemImage.clipsToBounds = true
        itemImage.layer.masksToBounds = true
        itemImage.translatesAutoresizingMaskIntoConstraints = false
        
        checkBoxImage = UIImageView()
        checkBoxImage.image = UIImage(systemName: "square")?.withRenderingMode(.alwaysOriginal) // MARK: Update this to use actual saved image
        checkBoxImage.contentMode = .scaleToFill
        checkBoxImage.clipsToBounds = true
        checkBoxImage.layer.masksToBounds = true
        checkBoxImage.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(itemImage)
        self.addSubview(checkBoxImage)
    }

    func setupWrapperCellView(){
        wrapperCellView = UITableViewCell()
        wrapperCellView.layer.borderColor = UIColor.black.cgColor
        wrapperCellView.layer.borderWidth = 1
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
    
    func setupLabels(){
        itemNameLabel = UILabel()
        itemCostLabel = UILabel()
        itemPayersLabel = UILabel()
        
        let appLabels: [UILabel] = [itemNameLabel, itemCostLabel, itemPayersLabel]
        
        // MARK: apply common attributes to all labels
        for itemLabel: UILabel in appLabels{
            itemLabel.font = UIFont.boldSystemFont(ofSize: 14)
            itemLabel.translatesAutoresizingMaskIntoConstraints = false
            wrapperCellView.addSubview(itemLabel)
        }
        
        //delete = UIButton(type: .system)
        //wrapperCellView.addSubview(delete)
        
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            wrapperCellView.topAnchor.constraint(equalTo: self.topAnchor,constant: 5),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            wrapperCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            
            itemImage.widthAnchor.constraint(equalTo: itemImage.heightAnchor),
            itemImage.heightAnchor.constraint(equalTo: wrapperCellView.heightAnchor, multiplier: 0.8),
            itemImage.centerYAnchor.constraint(equalTo: wrapperCellView.centerYAnchor),
            itemImage.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 10),
            
            itemNameLabel.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 10),
            itemNameLabel.leadingAnchor.constraint(equalTo: itemImage.trailingAnchor, constant: 10),
            
            itemCostLabel.topAnchor.constraint(equalTo: itemNameLabel.bottomAnchor, constant: 2),
            itemCostLabel.leadingAnchor.constraint(equalTo: itemNameLabel.leadingAnchor),
            
            itemPayersLabel.topAnchor.constraint(equalTo: itemCostLabel.bottomAnchor, constant: 2),
            itemPayersLabel.leadingAnchor.constraint(equalTo: itemNameLabel.leadingAnchor),
            
            checkBoxImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            checkBoxImage.centerYAnchor.constraint(equalTo: wrapperCellView.centerYAnchor),
            
            /*
            delete.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -20),
            delete.centerYAnchor.constraint(equalTo: wrapperCellView.centerYAnchor),
             */
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
