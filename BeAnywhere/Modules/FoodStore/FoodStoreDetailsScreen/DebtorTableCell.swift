//
//  DebtorTableCell.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 11/4/24.
//

import UIKit

class DebtorTableCell: UITableViewCell {
    var wrapperCellView: UIView!
    var debtorNameLabel: UILabel!
    var debtorPaymentStatusLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupWrapperCellView()
        setupLabelName()
        
        initConstraints()
    }

    func setupWrapperCellView(){
        wrapperCellView = UIView()
        
        //working with the shadows and colors...
        wrapperCellView.backgroundColor = .white
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(wrapperCellView)
    }
    
    func setupLabelName(){
        debtorNameLabel = UILabel()
        debtorPaymentStatusLabel = UILabel()
        
        let labels: [UILabel] = [debtorNameLabel, debtorPaymentStatusLabel]
        
        for label: UILabel in labels {
            label.font = UIFont.boldSystemFont(ofSize: 14)
            label.translatesAutoresizingMaskIntoConstraints = false
            wrapperCellView.addSubview(label)
        }
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            wrapperCellView.topAnchor.constraint(equalTo: self.topAnchor,constant: 4),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            wrapperCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
            
            debtorNameLabel.topAnchor.constraint(equalTo: wrapperCellView.topAnchor),
           
            debtorNameLabel.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor),
            debtorNameLabel.heightAnchor.constraint(equalToConstant: 15),
            debtorNameLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 200),
            
            debtorPaymentStatusLabel.topAnchor.constraint(equalTo: debtorNameLabel.topAnchor),
            debtorPaymentStatusLabel.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor),
            debtorPaymentStatusLabel.heightAnchor.constraint(equalToConstant: 15),
            
            wrapperCellView.heightAnchor.constraint(equalToConstant: 15)
            
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
