//
//  UserBoxTableViewCell.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 11/4/24.
//

import UIKit

class UserBoxTableViewCell: UITableViewCell {
    
    var wrapperCellView: UIView!
    var userNameLabel: UILabel!
    var avatarImage:UIImageView!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupWrapperCellView()
        setupLabelName()
        setupAvatarImage()
        
        initConstraints()
    }
    
    func setupAvatarImage(){
        avatarImage = UIImageView()
        avatarImage.image = UIImage(systemName: "person.circle")?.withRenderingMode(.alwaysOriginal) // MARK: Update this to use actual saved image
        avatarImage.contentMode = .scaleToFill
        avatarImage.clipsToBounds = true
        avatarImage.layer.masksToBounds = true
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(avatarImage)
    }

    func setupWrapperCellView(){
        wrapperCellView = UITableViewCell()
        
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
        userNameLabel = UILabel()
        userNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(userNameLabel)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            wrapperCellView.topAnchor.constraint(equalTo: self.topAnchor,constant: 4),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            wrapperCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
            
            avatarImage.widthAnchor.constraint(equalToConstant: 32),
            avatarImage.heightAnchor.constraint(equalToConstant: 32),
            avatarImage.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 8),
            avatarImage.bottomAnchor.constraint(equalTo: wrapperCellView.bottomAnchor, constant: -8),
            avatarImage.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 16),
            
            userNameLabel.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 14),
            userNameLabel.bottomAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: -14),
            userNameLabel.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: 10),
            userNameLabel.heightAnchor.constraint(equalToConstant: 20),
            userNameLabel.widthAnchor.constraint(equalTo: wrapperCellView.widthAnchor),
            
            wrapperCellView.heightAnchor.constraint(equalToConstant: 48)
            
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
