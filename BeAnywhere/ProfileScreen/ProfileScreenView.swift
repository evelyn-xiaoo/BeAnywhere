//
//  ProfileScreenView.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 10/25/24.
//

import UIKit

class ProfileScreenView: UIView {
    var welcomeMsg: UILabel!
    var buttonLogout: UIButton!

    override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = .white
        setupButtonLogout()
        setupLabels()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupButtonLogout() {
        buttonLogout = UIButton(type: .system)
        buttonLogout.setTitle("Logout", for: .normal)
        buttonLogout.titleLabel?.font = .boldSystemFont(ofSize: 16)
        buttonLogout.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonLogout)
    }
    
    func setupLabels() {
        welcomeMsg = UILabel()
        welcomeMsg.font = UIFont.boldSystemFont(ofSize: 23)
        welcomeMsg.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(welcomeMsg)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            welcomeMsg.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 16),
            welcomeMsg.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            buttonLogout.topAnchor.constraint(equalTo: welcomeMsg.bottomAnchor, constant: 16),
            buttonLogout.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            ])}
}
