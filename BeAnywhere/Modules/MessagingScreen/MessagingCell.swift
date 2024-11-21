//
//  MessagingCell.swift
//  BeAnywhere
//
//  Created by Evelyn Xiao on 11/21/24.
//

import UIKit

class MessagingCell: UITableViewCell {
    var wrapperCellView: UIView!
    var itemLabel: UILabel!
    var innerTable: UITableView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        setupWrapperCellView()
        setupItemLabel()
        setupTable()
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
    
    func setupTable() {
        innerTable = UITableView()
        innerTable.backgroundColor = .white
        innerTable.translatesAutoresizingMaskIntoConstraints = false
        innerTable.register(SubmittedStoreCell.self, forCellReuseIdentifier: TableConfigs.submittedStores)
        innerTable.dataSource = self
        innerTable.delegate = self
        innerTable.rowHeight = UITableView.automaticDimension
        innerTable.separatorStyle = .none
        wrapperCellView.addSubview(innerTable)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            wrapperCellView.topAnchor.constraint(equalTo: self.topAnchor),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            wrapperCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            
            itemLabel.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 10),
            itemLabel.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 20),
            
            
            innerTable.topAnchor.constraint(equalTo: itemLabel.bottomAnchor, constant: 0),
            innerTable.leadingAnchor.constraint(equalTo: itemLabel.leadingAnchor, constant: 10),
            innerTable.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -10),
            innerTable.bottomAnchor.constraint(equalTo: wrapperCellView.bottomAnchor),
            
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

extension MessagingCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableConfigs.message, for: indexPath) as! TextCell
        
        return cell
    }
    
    
    
}
