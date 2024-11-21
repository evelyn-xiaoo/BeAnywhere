//
//  DropdownCell.swift
//  BeAnywhere
//
//  Created by Evelyn Xiao on 11/21/24.
//

import UIKit

class DropdownCell: UITableViewCell {
    
    var wrapperCellView: UIView!
    var itemLabel: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        setupWrapperCellView()
        setupItemLabel()
        initConstraints()
    }
    
    func setupWrapperCellView() {
        wrapperCellView = UIView()
        wrapperCellView.backgroundColor = .white
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(wrapperCellView)
    }
    
    func setupItemLabel() {
        itemLabel = UILabel()
        itemLabel.textColor = .black
        itemLabel.font = .systemFont(ofSize: 16, weight: .regular)
        itemLabel.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(itemLabel)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            wrapperCellView.topAnchor.constraint(equalTo: self.topAnchor),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            wrapperCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            
            itemLabel.centerYAnchor.constraint(equalTo: wrapperCellView.centerYAnchor),
            itemLabel.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 20),
            
            
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
