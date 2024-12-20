//
//  TripBoxTableViewCell.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 11/4/24.
//

import UIKit

class TripBoxTableViewCell: UITableViewCell {
    
    var wrapperCellView: UIView!
    var groupNameLabel: UILabel!
    var tripImage: UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupWrapperCellView()
        setupLabelName()
        setupAvatarImage()
        
        initConstraints()
    }
    
    func setupAvatarImage(){
        tripImage = UIImageView()
        tripImage.image = UIImage(systemName: "map")?.withRenderingMode(.alwaysOriginal) // MARK: Update this to use actual saved image
        tripImage.contentMode = .scaleToFill
        tripImage.clipsToBounds = true
        tripImage.layer.masksToBounds = true
        tripImage.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tripImage)
    }

    func setupWrapperCellView(){
        wrapperCellView = UITableViewCell()
        
        //working with the shadows and colors...
        //wrapperCellView.backgroundColor = .white
        wrapperCellView.layer.cornerRadius = 4.0
        wrapperCellView.layer.borderColor = UIColor.black.cgColor
        wrapperCellView.layer.borderWidth = 1
        //wrapperCellView.layer.shadowColor = UIColor.gray.cgColor
        //wrapperCellView.layer.shadowOffset = .zero
        //wrapperCellView.layer.shadowRadius = 2.0
        //wrapperCellView.layer.shadowOpacity = 0.7
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(wrapperCellView)
    }
    
    func setupLabelName(){
        groupNameLabel = UILabel()
        groupNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        groupNameLabel.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(groupNameLabel)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            wrapperCellView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor,constant: 0),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            wrapperCellView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            
            tripImage.widthAnchor.constraint(equalTo: tripImage.heightAnchor),
            tripImage.heightAnchor.constraint(equalTo: wrapperCellView.heightAnchor, multiplier: 0.8),
            tripImage.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 8),
            tripImage.bottomAnchor.constraint(equalTo: wrapperCellView.bottomAnchor, constant: -8),
            tripImage.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 16),
            
            groupNameLabel.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 14),
            groupNameLabel.bottomAnchor.constraint(equalTo: wrapperCellView.bottomAnchor, constant: -14),
            groupNameLabel.leadingAnchor.constraint(equalTo: tripImage.trailingAnchor, constant: 10),
            groupNameLabel.heightAnchor.constraint(equalToConstant: 20),
            groupNameLabel.widthAnchor.constraint(equalTo: wrapperCellView.widthAnchor),
            
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
