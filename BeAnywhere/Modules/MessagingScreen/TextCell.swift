//
//  TextCell.swift
//  BeAnywhere
//
//  Created by Evelyn Xiao on 11/21/24.
//

import UIKit

class TextCell: UITableViewCell {
    var wrapperCell: UIView!
    var from: UILabel!
    var text: UITextView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupWrapperCell()
        setupLabels()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupWrapperCell() {
        wrapperCell = UIView()
        wrapperCell.backgroundColor = .white
        wrapperCell.layer.borderColor = UIColor.black.cgColor
        wrapperCell.layer.borderWidth = 1
        wrapperCell.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(wrapperCell)
    }
    
    func setupLabels() {
        from = UILabel()
        from.font = .systemFont(ofSize: 16, weight: .regular)
        from.textColor = .black
        from.translatesAutoresizingMaskIntoConstraints = false
        wrapperCell.addSubview(from)
        
        text = UITextView()
        text.textContainerInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        text.textColor = .black
        text.translatesAutoresizingMaskIntoConstraints = false
        wrapperCell.addSubview(text)
        
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            wrapperCell.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            wrapperCell.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0),
            wrapperCell.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0),
            wrapperCell.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
            
            from.topAnchor.constraint(equalTo: wrapperCell.topAnchor, constant: 2),
            from.leadingAnchor.constraint(equalTo: wrapperCell.leadingAnchor, constant: 2),
            
            text.topAnchor.constraint(equalTo: from.bottomAnchor, constant: 0),
            text.leadingAnchor.constraint(equalTo: wrapperCell.leadingAnchor),
            text.bottomAnchor.constraint(equalTo: wrapperCell.bottomAnchor,constant: -10),
            text.trailingAnchor.constraint(equalTo: wrapperCell.trailingAnchor, constant: 0)
            ])
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
