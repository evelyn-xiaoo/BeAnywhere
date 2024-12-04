//
//  MessageTableViewCell.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 12/2/24.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    var wrapperCellView: UIView!
    var userNameLabel: UILabel!
    var userAvatarImage: UIImageView!
    var messageDateLabel: UILabel!
    var messageContentLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupWrapperCellView()
        setupLabels()
        setupAvatarImage()
        
        initConstraints()
    }
    
    func setupAvatarImage(){
        userAvatarImage = UIImageView()
        userAvatarImage.image = UIImage(systemName: "person.circle.fill")?.withRenderingMode(.alwaysOriginal) // MARK: Update this to use actual saved image
        userAvatarImage.contentMode = .scaleToFill
        userAvatarImage.clipsToBounds = true
        userAvatarImage.layer.masksToBounds = true
        userAvatarImage.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(userAvatarImage)
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
    
    func setupLabels(){
        userNameLabel = UILabel()
        messageDateLabel = UILabel()
        messageContentLabel = UILabel()
        
        userNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        messageDateLabel.font = UIFont.systemFont(ofSize: 12)
        messageContentLabel.font = UIFont.systemFont(ofSize: 10)
        messageContentLabel.numberOfLines = 5
        
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        messageDateLabel.translatesAutoresizingMaskIntoConstraints = false
        messageContentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        wrapperCellView.addSubview(userNameLabel)
        wrapperCellView.addSubview(messageDateLabel)
        wrapperCellView.addSubview(messageContentLabel)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            wrapperCellView.topAnchor.constraint(equalTo: self.topAnchor,constant: 4),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            wrapperCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
            
            userAvatarImage.widthAnchor.constraint(equalToConstant: 32),
            userAvatarImage.heightAnchor.constraint(equalToConstant: 32),
            userAvatarImage.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 8),
            userAvatarImage.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 16),
            
            userNameLabel.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 14),
            userNameLabel.leadingAnchor.constraint(equalTo: userAvatarImage.trailingAnchor, constant: 10),
            userNameLabel.heightAnchor.constraint(equalToConstant: 20),
            userNameLabel.trailingAnchor.constraint(equalTo: messageDateLabel.leadingAnchor, constant: -16),
            userNameLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 100),
            
            messageContentLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 4),
            messageContentLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor),
            messageContentLabel.widthAnchor.constraint(lessThanOrEqualTo: wrapperCellView.widthAnchor, multiplier: 0.8),
            
            messageDateLabel.topAnchor.constraint(equalTo: userNameLabel.topAnchor),
            messageDateLabel.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -16),
            messageDateLabel.heightAnchor.constraint(equalToConstant: 20),
            
            wrapperCellView.heightAnchor.constraint(greaterThanOrEqualToConstant: 72)
            
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
