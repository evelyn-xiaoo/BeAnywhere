//
//  HomeScreenView.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 11/3/24.
//

import UIKit

class AddTripScreenView: UIView {

    var tripImage: UIButton!
    var textFieldName: UITextField!
    var textFieldLocation: UITextField!
    var addMemberButton: UIButton!
    var memberTable: UITableView!
    var tripImageLabel: UILabel!
    var membersLabel: UILabel!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = .white

        setUpLabels()
        setupAddMemberButton()
        setuptextFieldLocation()
        setuptextFieldGroupName()
        setupTripImage()
        setupTableViewTrips()
        initConstraints()
    }
    
    func setupTripImage(){
        tripImage = UIButton(type: .system)
        tripImage.setTitle("", for: .normal)
        tripImage.setImage(UIImage(systemName: "map"), for: .normal)
        tripImage.tintColor = .gray
        tripImage.contentHorizontalAlignment = .fill
        tripImage.contentVerticalAlignment = .fill
        tripImage.imageView?.contentMode = .scaleAspectFill
        tripImage.translatesAutoresizingMaskIntoConstraints = false
        tripImage.showsMenuAsPrimaryAction = true
        tripImage.layer.cornerRadius = 10
        tripImage.clipsToBounds = true
        self.addSubview(tripImage)
    }
    
    func setuptextFieldGroupName(){
        textFieldName = UITextField()
        textFieldName.placeholder = "Group Name"
        textFieldName.keyboardType = .default
        textFieldName.borderStyle = .roundedRect
        textFieldName.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldName)
    }
    
    func setuptextFieldLocation(){
        textFieldLocation = UITextField()
        textFieldLocation.placeholder = "City, Country"
        textFieldLocation.keyboardType = .default
        textFieldLocation.borderStyle = .roundedRect
        textFieldLocation.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldLocation)
    }
    
    func setupAddMemberButton(){
        addMemberButton = UIButton(type: .system)
        addMemberButton.setTitle("", for: .normal)
        addMemberButton.setImage(UIImage(systemName: "person.crop.circle.badge.plus")?.withRenderingMode(.alwaysOriginal), for: .normal)
        addMemberButton.contentHorizontalAlignment = .fill
        addMemberButton.contentVerticalAlignment = .fill
        addMemberButton.imageView?.contentMode = .scaleAspectFit
        addMemberButton.layer.cornerRadius = 16
        addMemberButton.imageView?.layer.shadowOffset = .zero
        addMemberButton.imageView?.layer.shadowRadius = 0.8
        addMemberButton.imageView?.layer.shadowOpacity = 0.7
        addMemberButton.imageView?.clipsToBounds = true
        addMemberButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(addMemberButton)
    }
    
    func setUpLabels() {
        tripImageLabel = UILabel()
        membersLabel = UILabel()
        
        let appLabels: [UILabel] = [ tripImageLabel, membersLabel]
        
        membersLabel.font = UIFont.boldSystemFont(ofSize: 15)
        tripImageLabel.font = UIFont.boldSystemFont(ofSize: 13)
        tripImageLabel.text = "Trip Image"
        membersLabel.text = "Group Members:"
        
        
        // apply common attributes to the labels
        for label: UILabel in appLabels {
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            self.addSubview(label)
        }
    }
    
    func setupTableViewTrips(){
        memberTable = UITableView()
        memberTable.register(UserBoxTableViewCell.self, forCellReuseIdentifier: TableConfigs.tableViewUsers)
        memberTable.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(memberTable)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            
            tripImage.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 50),
            tripImage.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            tripImage.widthAnchor.constraint(equalToConstant: 100),
            tripImage.heightAnchor.constraint(equalToConstant: 100),
            
            tripImageLabel.topAnchor.constraint(equalTo: tripImage.bottomAnchor, constant: 8),
            tripImageLabel.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            textFieldName.topAnchor.constraint(equalTo: tripImage.bottomAnchor, constant: 32),
            textFieldName.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            textFieldName.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            textFieldName.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            textFieldLocation.topAnchor.constraint(equalTo: textFieldName.bottomAnchor, constant: 16),
            textFieldLocation.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            textFieldLocation.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            textFieldLocation.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            membersLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            membersLabel.topAnchor.constraint(equalTo: textFieldLocation.bottomAnchor, constant: 16),
            
            memberTable.topAnchor.constraint(equalTo: membersLabel.bottomAnchor, constant: 16),
            memberTable.bottomAnchor.constraint(equalTo: addMemberButton.topAnchor, constant: -8),
            memberTable.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor),
            
            addMemberButton.widthAnchor.constraint(equalToConstant: 48),
            addMemberButton.heightAnchor.constraint(equalToConstant: 48),
            addMemberButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addMemberButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
