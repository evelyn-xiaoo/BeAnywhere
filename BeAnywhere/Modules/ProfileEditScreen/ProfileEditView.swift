//
//  ProfileEditView.swift
//  BeAnywhere
//
//  Created by Evelyn Xiao on 11/6/24.
//

import UIKit

class ProfileEditView: UIView {
    var buttonLogout: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupButtonLogout()
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
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            buttonLogout.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            buttonLogout.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -100)
        ])
    }

}
