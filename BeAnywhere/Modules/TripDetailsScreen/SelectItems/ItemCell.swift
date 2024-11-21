//
//  ItemCell.swift
//  BeAnywhere
//
//  Created by Evelyn Xiao on 11/20/24.
//

import UIKit

class ItemCell: UITableViewCell {
    var wrapperCellView: UIView!
    var itemName: UILabel!
    var price: UILabel!
    var foodImageURL: String = ""
    var foodImage: UIImageView!
    var payersLabel: UILabel!
    
    var checkBox: UIButton!
    
    var isMyItem: Bool = false
    var payersIds: [String]? = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        setupWrapperCellView()
        setupImage()
        setupLabels()
        setupCheckBox()
        initConstraints()
    }
    
    
    func setupWrapperCellView() {
        wrapperCellView = UIView()
        wrapperCellView.backgroundColor = .white
        wrapperCellView.layer.borderColor = UIColor.black.cgColor
        wrapperCellView.layer.borderWidth = 1
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(wrapperCellView)
    }
    
    func setupImage() {
        foodImage = UIImageView()
        foodImage.image = UIImage(systemName: "takeoutbag.and.cup.and.straw")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        foodImage.contentMode = .scaleAspectFit
        foodImage.clipsToBounds = true
        foodImage.layer.cornerRadius = 10
        foodImage.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(foodImage)
    }
    
    func setupLabels() {
        itemName = UILabel()
        itemName.font = .systemFont(ofSize: 16, weight: .regular)
        itemName.textColor = .black
        itemName.translatesAutoresizingMaskIntoConstraints = false
        itemName.numberOfLines = 1
        wrapperCellView.addSubview(itemName)
        
        price = UILabel()
        price.font = .systemFont(ofSize: 14, weight: .regular)
        price.textColor = .black
        price.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(price)
        
        payersLabel = UILabel()
        payersLabel.font = .systemFont(ofSize: 14, weight: .regular)
        payersLabel.textColor = .black
        payersLabel.numberOfLines = 1
        payersLabel.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(payersLabel)
    }
    
    func setupCheckBox() {
        checkBox = UIButton()
        checkBox.setImage(UIImage(systemName: "square.fill")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal), for: .normal)
        checkBox.contentMode = .scaleAspectFill
        checkBox.imageView?.contentMode = .scaleAspectFill
        checkBox.contentHorizontalAlignment = .fill
        checkBox.contentVerticalAlignment = .fill
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(checkBox)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            wrapperCellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            wrapperCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            
            foodImage.heightAnchor.constraint(equalTo: wrapperCellView.heightAnchor, multiplier: 0.8),
            foodImage.widthAnchor.constraint(equalTo: foodImage.heightAnchor),
            foodImage.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 10),
            foodImage.centerYAnchor.constraint(equalTo: wrapperCellView.centerYAnchor),
            
            itemName.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 10),
            itemName.leadingAnchor.constraint(equalTo: foodImage.trailingAnchor, constant: 10),
            
            price.topAnchor.constraint(equalTo: itemName.bottomAnchor, constant: 2),
            price.leadingAnchor.constraint(equalTo: itemName.leadingAnchor),
            
            payersLabel.topAnchor.constraint(equalTo: price.bottomAnchor, constant: 2),
            payersLabel.leadingAnchor.constraint(equalTo: itemName.leadingAnchor),
            
            checkBox.heightAnchor.constraint(equalToConstant: 30),
            checkBox.widthAnchor.constraint(equalTo: checkBox.heightAnchor),
            checkBox.centerYAnchor.constraint(equalTo: wrapperCellView.centerYAnchor),
            checkBox.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -20)
            
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
