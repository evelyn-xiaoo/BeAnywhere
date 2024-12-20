//
//  RegisterScreenView.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 10/25/24.
//

import UIKit

class RegisterScreenView: UIView {
    var profileImage: UIButton!
    var textFieldName: UITextField!
    var textFieldEmail: UITextField!
    var textFieldVenmo: UITextField!
    var textFieldUsername: UITextField!
    var textFieldPassword: UITextField!
    var textFieldVerifyPassword: UITextField!
    var buttonRegister: UIButton!
    var optionalLabel: UILabel!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupimagePFP()
        setuptextFieldName()
        setuptextFieldEmail()
        setuptextFieldUsername()
        setuptextFieldVenmo()
        setuptextFieldPassword()
        setuptextFieldVerifyPassword()
        setupbuttonRegister()
        
        initConstraints()
    }
    
    func setupimagePFP(){
        profileImage = UIButton(type: .system)
        profileImage.setTitle("", for: .normal)
        profileImage.setImage(UIImage(systemName: "person.circle"), for: .normal)
        profileImage.tintColor = .gray
        profileImage.contentHorizontalAlignment = .fill
        profileImage.contentVerticalAlignment = .fill
        profileImage.imageView?.contentMode = .scaleAspectFill
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.showsMenuAsPrimaryAction = true
        profileImage.layer.cornerRadius = 50
        profileImage.clipsToBounds = true
        self.addSubview(profileImage)
    }
    
    func setuptextFieldName(){
        textFieldName = UITextField()
        textFieldName.placeholder = "Full name"
        textFieldName.keyboardType = .default
        textFieldName.borderStyle = .roundedRect
        textFieldName.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldName)
    }
    
    func setuptextFieldEmail(){
        textFieldEmail = UITextField()
        textFieldEmail.placeholder = "Email"
        textFieldEmail.keyboardType = .emailAddress
        textFieldEmail.borderStyle = .roundedRect
        textFieldEmail.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldEmail)
    }
    
    func setuptextFieldUsername(){
        textFieldUsername = UITextField()
        textFieldUsername.placeholder = "Username"
        textFieldUsername.borderStyle = .roundedRect
        textFieldUsername.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldUsername)
    }
    
    func setuptextFieldVenmo(){
        textFieldVenmo = UITextField()
        textFieldVenmo.placeholder = "Venmo"
        textFieldVenmo.borderStyle = .roundedRect
        textFieldVenmo.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldVenmo)
    }
    
    func setuptextFieldPassword(){
        textFieldPassword = UITextField()
        textFieldPassword.placeholder = "Password"
        textFieldPassword.textContentType = .password
        textFieldPassword.isSecureTextEntry = true
        textFieldPassword.borderStyle = .roundedRect
        textFieldPassword.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldPassword)
    }
    
    func setuptextFieldVerifyPassword(){
        optionalLabel = UILabel()
        optionalLabel.text = "Optional"
        optionalLabel.font = .systemFont(ofSize: 12)
        optionalLabel.textColor = .lightGray
        optionalLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(optionalLabel)
        
        textFieldVerifyPassword = UITextField()
        textFieldVerifyPassword.placeholder = "Verify Password"
        textFieldVerifyPassword.textContentType = .password
        textFieldVerifyPassword.isSecureTextEntry = true
        textFieldVerifyPassword.borderStyle = .roundedRect
        textFieldVerifyPassword.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldVerifyPassword)
    }
    
    func setupbuttonRegister(){
        buttonRegister = UIButton(type: .system)
        buttonRegister.setTitle("Register", for: .normal)
        buttonRegister.titleLabel?.font = .boldSystemFont(ofSize: 16)
        buttonRegister.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonRegister)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0),
            profileImage.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: 125),
            profileImage.heightAnchor.constraint(equalTo: profileImage.widthAnchor),
            
            textFieldName.topAnchor.constraint(equalTo: self.profileImage.bottomAnchor, constant: 16),
            textFieldName.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            textFieldName.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            
            
            textFieldEmail.topAnchor.constraint(equalTo: textFieldName.bottomAnchor, constant: 16),
            textFieldEmail.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            textFieldEmail.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            
            textFieldUsername.topAnchor.constraint(equalTo: textFieldEmail.bottomAnchor, constant: 16),
            textFieldUsername.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            textFieldUsername.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            
            textFieldPassword.topAnchor.constraint(equalTo: textFieldUsername.bottomAnchor, constant: 16),
            textFieldPassword.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            textFieldPassword.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            
            textFieldVerifyPassword.topAnchor.constraint(equalTo: textFieldPassword.bottomAnchor, constant: 16),
            textFieldVerifyPassword.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            textFieldVerifyPassword.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            
            
            optionalLabel.topAnchor.constraint(equalTo: textFieldVerifyPassword.bottomAnchor, constant: 16),
            optionalLabel.leadingAnchor.constraint(equalTo: textFieldVenmo.leadingAnchor, constant: 2),
            
            textFieldVenmo.topAnchor.constraint(equalTo: optionalLabel.bottomAnchor, constant: 2),
            textFieldVenmo.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            textFieldVenmo.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
    
            buttonRegister.topAnchor.constraint(equalTo: textFieldVenmo.bottomAnchor, constant: 32),
            buttonRegister.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
