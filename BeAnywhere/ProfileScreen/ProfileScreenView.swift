//
//  ProfileScreenView.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 10/25/24.
//

import UIKit

class ProfileScreenView: UIView {
    var welcomeMsg: UILabel!
    

    override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = .white
    
        setupLabels()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            
            
            
            ])}
}
