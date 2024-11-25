//
//  ProfileEditView.swift
//  BeAnywhere
//
//  Created by Evelyn Xiao on 11/6/24.
//

import UIKit

class ProfileEditView: UIView {
    var buttonLogout: UIButton!
    
    var nameLabel: UILabel!
    var emailLabel: UILabel!
    var usernameLabel: UILabel!
    var venmoLabel: UILabel!
    
    var profilePhoto: UIButton!
    var textFieldName: UITextField!
    var textFieldEmail: UITextField!
    var textFieldVenmo: UITextField!
    var textFieldUsername: UITextField!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupButtonLogout()
        setupProfilePhoto()
        setupLabels()
        setupTextFields()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupButtonLogout() {
        buttonLogout = UIButton(type: .system)
        buttonLogout.setTitle("Logout", for: .normal)
        buttonLogout.tintColor = .red
        buttonLogout.titleLabel?.font = .boldSystemFont(ofSize: 16)
        buttonLogout.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonLogout)
    }
    
    func setupProfilePhoto() {
        profilePhoto = UIButton()
        profilePhoto.contentHorizontalAlignment = .fill
        profilePhoto.contentVerticalAlignment = .fill
        profilePhoto.imageView?.contentMode = .scaleAspectFill
        profilePhoto.showsMenuAsPrimaryAction = true
        profilePhoto.layer.cornerRadius = 50
        profilePhoto.clipsToBounds = true
        profilePhoto.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(profilePhoto)
    }
    
    func setupTextFields() {
        textFieldName = UITextField()
        textFieldEmail = UITextField()
        textFieldVenmo = UITextField()
        textFieldUsername = UITextField()
        
        [textFieldName, textFieldEmail, textFieldUsername, textFieldVenmo].forEach {
            $0.borderStyle = .roundedRect
            $0.backgroundColor = .white
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 5
            $0.layer.borderColor = UIColor.gray.cgColor
            $0.textColor = .black
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
    }
    
    func setupLabels() {
        nameLabel = UILabel()
        emailLabel = UILabel()
        usernameLabel = UILabel()
        venmoLabel = UILabel()
        
        nameLabel.text = "Name"
        emailLabel.text = "Email"
        usernameLabel.text = "Username"
        venmoLabel.text = "Venmo"
        
        [nameLabel, emailLabel, usernameLabel, venmoLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.font = .systemFont(ofSize: 12)
            $0.textColor = .lightGray
            self.addSubview($0)
        }
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            buttonLogout.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            buttonLogout.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -100),
            
            profilePhoto.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 50),
            profilePhoto.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            profilePhoto.widthAnchor.constraint(equalToConstant: 100),
            profilePhoto.heightAnchor.constraint(equalTo: profilePhoto.widthAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: profilePhoto.bottomAnchor, constant: 50),
            nameLabel.leadingAnchor.constraint(equalTo: textFieldName.leadingAnchor, constant: 2),
            
            textFieldName.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            textFieldName.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            textFieldName.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            
            emailLabel.topAnchor.constraint(equalTo: textFieldName.bottomAnchor, constant: 16),
            emailLabel.leadingAnchor.constraint(equalTo: textFieldEmail.leadingAnchor, constant: 2),
            
            textFieldEmail.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 2),
            textFieldEmail.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            textFieldEmail.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            
            usernameLabel.topAnchor.constraint(equalTo: textFieldEmail.bottomAnchor, constant: 16),
            usernameLabel.leadingAnchor.constraint(equalTo: textFieldUsername.leadingAnchor, constant: 2),
            
            textFieldUsername.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 2),
            textFieldUsername.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            textFieldUsername.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            
            venmoLabel.topAnchor.constraint(equalTo: textFieldUsername.bottomAnchor, constant: 16),
            venmoLabel.leadingAnchor.constraint(equalTo: textFieldVenmo.leadingAnchor, constant: 2),
            
            textFieldVenmo.topAnchor.constraint(equalTo: venmoLabel.bottomAnchor, constant: 2),
            textFieldVenmo.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            textFieldVenmo.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
        ])
    }

}
