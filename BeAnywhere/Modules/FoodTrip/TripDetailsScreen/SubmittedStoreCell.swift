//
//  SubmittedStoreCell.swift
//  BeAnywhere
//
//  Created by Evelyn Xiao on 11/19/24.
//

import UIKit

class SubmittedStoreCell: UITableViewCell {
    var wrapperCell: UIView!
    var name: UILabel!
    var date: UILabel!
    var cost: UILabel!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupWrapperCell()
        setupLabels()
        initConstraints()
    }
    
    func setupWrapperCell() {
        wrapperCell = UIView()
        wrapperCell.backgroundColor = .white
        wrapperCell.layer.borderColor = UIColor.gray.cgColor
        wrapperCell.layer.borderWidth = 1
        wrapperCell.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(wrapperCell)
    }
    
    func setupLabels() {
        name = UILabel()
        name.font = .systemFont(ofSize: 16, weight: .regular)
        name.textColor = .black
        name.translatesAutoresizingMaskIntoConstraints = false
        wrapperCell.addSubview(name)
        
        date = UILabel()
        date.font = .systemFont(ofSize: 16, weight: .regular)
        date.textColor = .black
        date.translatesAutoresizingMaskIntoConstraints = false
        wrapperCell.addSubview(date)
        
        cost = UILabel()
        cost.font = .systemFont(ofSize: 16, weight: .regular)
        cost.textColor = .black
        cost.translatesAutoresizingMaskIntoConstraints = false
        wrapperCell.addSubview(cost)
        
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            wrapperCell.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            wrapperCell.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0),
            wrapperCell.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0),
            wrapperCell.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
            
            name.topAnchor.constraint(equalTo: wrapperCell.topAnchor, constant: 10),
            name.leadingAnchor.constraint(equalTo: wrapperCell.leadingAnchor, constant: 10),
            date.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 2),
            date.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            cost.topAnchor.constraint(equalTo: date.bottomAnchor, constant: 2),
            cost.leadingAnchor.constraint(equalTo: date.leadingAnchor),
            cost.bottomAnchor.constraint(equalTo: wrapperCell.bottomAnchor, constant: -10)
        ])
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
