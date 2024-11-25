//
//  EditTripScreenView.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 11/3/24.
//

import UIKit

class EditTripScreenView: UIView {

    var tripImage: UIButton!
    var textFieldName: UITextField!
    var textFieldLocation: UITextField!
    var tripImageLabel: UILabel!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = .white

        setUpLabels()
        setuptextFieldLocation()
        setuptextFieldGroupName()
        setupTripImage()
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
    
    func setUpLabels() {
        tripImageLabel = UILabel()
        
        let appLabels: [UILabel] = [ tripImageLabel]
        
        tripImageLabel.font = UIFont.boldSystemFont(ofSize: 13)
        tripImageLabel.text = "Trip Image"
        
        
        // apply common attributes to the labels
        for label: UILabel in appLabels {
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            self.addSubview(label)
        }
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
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
