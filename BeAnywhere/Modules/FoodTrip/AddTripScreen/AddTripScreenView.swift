//
//  AddTripScreenView.swift
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
        textFieldName.placeholder = "Trip Name"
        textFieldName.keyboardType = .default
        textFieldName.borderStyle = .roundedRect
        textFieldName.backgroundColor = .systemGray6
        textFieldName.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldName)
    }
    
    func setuptextFieldLocation(){
        textFieldLocation = UITextField()
        textFieldLocation.placeholder = "City, Country"
        textFieldLocation.keyboardType = .default
        textFieldLocation.borderStyle = .roundedRect
        textFieldLocation.backgroundColor = .systemGray6
        textFieldLocation.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldLocation)
    }
    
    func setupAddMemberButton(){
        addMemberButton = UIButton(type: .system)
        addMemberButton.setTitle("Add member", for: .normal)
        addMemberButton.setTitleColor(.black, for: .normal)
        //addMemberButton.setImage(UIImage(systemName: "person.crop.circle.badge.plus")?.withRenderingMode(.alwaysOriginal), for: .normal)
        //addMemberButton.contentHorizontalAlignment = .fill
        //addMemberButton.contentVerticalAlignment = .fill
        //addMemberButton.imageView?.contentMode = .scaleAspectFit
        //addMemberButton.layer.cornerRadius = 16
        //addMemberButton.imageView?.layer.shadowOffset = .zero
        //addMemberButton.imageView?.layer.shadowRadius = 0.8
        //addMemberButton.imageView?.layer.shadowOpacity = 0.7
        //addMemberButton.imageView?.clipsToBounds = true
        addMemberButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(addMemberButton)
    }
    
    func setUpLabels() {
        tripImageLabel = UILabel()
        membersLabel = UILabel()
        
        let appLabels: [UILabel] = [ tripImageLabel, membersLabel]
        
        membersLabel.font = UIFont.systemFont(ofSize: 16)
        tripImageLabel.font = UIFont.systemFont(ofSize: 16)
        tripImageLabel.text = "Trip Image"
        membersLabel.text = "Trip Members:"
        
        
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
        memberTable.rowHeight = UITableView.automaticDimension
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
            
            textFieldName.topAnchor.constraint(equalTo: tripImageLabel.bottomAnchor, constant: 20),
            textFieldName.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            textFieldName.heightAnchor.constraint(equalToConstant: 40),
            textFieldName.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            textFieldLocation.topAnchor.constraint(equalTo: textFieldName.bottomAnchor, constant: 10),
            textFieldLocation.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            textFieldLocation.heightAnchor.constraint(equalToConstant: 40),
            textFieldLocation.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            membersLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            membersLabel.topAnchor.constraint(equalTo: textFieldLocation.bottomAnchor, constant: 20),
            
            memberTable.topAnchor.constraint(equalTo: membersLabel.bottomAnchor, constant: 10),
            memberTable.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            memberTable.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            memberTable.bottomAnchor.constraint(equalTo: addMemberButton.topAnchor, constant: -40),
            
            addMemberButton.widthAnchor.constraint(equalToConstant: 100),
            addMemberButton.heightAnchor.constraint(equalToConstant: 40),            addMemberButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addMemberButton.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
