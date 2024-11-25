//
//  FoodItemAddTableViewCell.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 11/7/24.
//

import UIKit

class FoodItemAddTableViewCell: UITableViewCell {
    var wrapperCellView: UIView!
    var labelTitle: UILabel!
    var checkBox: UIImageView!
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupWrapperCellVIew()
            setupLabelTitle()
            setupCheckBox()
            
            initConstraints()
        }
        
        func setupWrapperCellVIew(){
            wrapperCellView = UITableViewCell()
            wrapperCellView.backgroundColor = .white
            wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(wrapperCellView)
        }
    
        func setupCheckBox(){
        checkBox = UIImageView()
            checkBox.image = UIImage(systemName: "square")?.withRenderingMode(.alwaysOriginal)
            checkBox.contentMode = .scaleToFill
            checkBox.clipsToBounds = true
            checkBox.layer.masksToBounds = true
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(checkBox)
    }
        func setupLabelTitle(){
            labelTitle = UILabel()
            
            labelTitle.font = UIFont.boldSystemFont(ofSize: 20)
            
            labelTitle.translatesAutoresizingMaskIntoConstraints = false
            
            wrapperCellView.addSubview(labelTitle)
            
        }
        func initConstraints(){
            NSLayoutConstraint.activate([
                wrapperCellView.topAnchor.constraint(equalTo: self.topAnchor,constant: 10),
                wrapperCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
                wrapperCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
                wrapperCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
                
                checkBox.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 8),
                checkBox.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 16),
                checkBox.heightAnchor.constraint(equalToConstant: 20),
                checkBox.widthAnchor.constraint(equalToConstant: 20),
                
                labelTitle.topAnchor.constraint(equalTo: checkBox.topAnchor),
                labelTitle.leadingAnchor.constraint(equalTo: checkBox.trailingAnchor, constant: 16),
                labelTitle.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant:  -16),
                labelTitle.heightAnchor.constraint(equalToConstant: 20),
                
                wrapperCellView.heightAnchor.constraint(equalToConstant: 40)
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
