//
//  UserSearchTableViewCell.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 11/7/24.
//

import UIKit

class UserSearchTableViewCell: UITableViewCell {
    var wrapperCellView: UIView!
        var labelTitle: UILabel!
    var labelUserEmail: UILabel!
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupWrapperCellVIew()
            setupLabelTitle()
            initConstraints()
        }
        
        func setupWrapperCellVIew(){
            wrapperCellView = UITableViewCell()
            wrapperCellView.backgroundColor = .white
            wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(wrapperCellView)
        }
        func setupLabelTitle(){
            labelTitle = UILabel()
            labelUserEmail = UILabel()
            labelTitle.font = UIFont.boldSystemFont(ofSize: 20)
            labelUserEmail.font = UIFont.systemFont(ofSize: 15)
            labelTitle.translatesAutoresizingMaskIntoConstraints = false
            labelUserEmail.translatesAutoresizingMaskIntoConstraints = false
            wrapperCellView.addSubview(labelTitle)
            wrapperCellView.addSubview(labelUserEmail)
        }
        func initConstraints(){
            NSLayoutConstraint.activate([
                wrapperCellView.topAnchor.constraint(equalTo: self.topAnchor,constant: 10),
                wrapperCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
                wrapperCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
                wrapperCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
                
                labelTitle.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 8),
                labelTitle.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 16),
                labelTitle.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant:  -16),
                labelTitle.heightAnchor.constraint(equalToConstant: 20),
                
                labelUserEmail.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 8),
                labelUserEmail.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 16),
                labelUserEmail.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant:  -16),
                labelUserEmail.heightAnchor.constraint(equalToConstant: 20),
                
                wrapperCellView.heightAnchor.constraint(equalToConstant: 56)
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
