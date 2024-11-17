//
//  TripDetailsScreenView.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 11/3/24.
//
import UIKit

class TripDetailsScreenView: UIView {

    var addStoreButton: UIButton!
    var foodStoreTable: UITableView!
    var paidByMeLabel: UILabel!
    var totalReceivedLabel: UILabel!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = .white

        setUpLabels()
        setupaddStoreButton()
        
        setupTableViewTrips()
        initConstraints()
    }
    
    func setupaddStoreButton(){
        addStoreButton = UIButton(type: .system)
        addStoreButton.setTitle("Add+", for: .normal)
        addStoreButton.contentHorizontalAlignment = .fill
        addStoreButton.contentVerticalAlignment = .fill
        addStoreButton.imageView?.contentMode = .scaleAspectFit
        addStoreButton.layer.cornerRadius = 16
        addStoreButton.imageView?.layer.shadowOffset = .zero
        addStoreButton.imageView?.layer.shadowRadius = 0.8
        addStoreButton.imageView?.layer.shadowOpacity = 0.7
        addStoreButton.imageView?.clipsToBounds = true
        addStoreButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(addStoreButton)
    }
    
    func setUpLabels() {
        paidByMeLabel = UILabel()
        totalReceivedLabel = UILabel()
        
        let appLabels: [UILabel] = [paidByMeLabel, totalReceivedLabel]
        
        paidByMeLabel.font = UIFont.boldSystemFont(ofSize: 15)
        totalReceivedLabel.font = UIFont.boldSystemFont(ofSize: 15)
        
        
        // apply common attributes to the labels
        for label: UILabel in appLabels {
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            self.addSubview(label)
        }
    }
    
    func setupTableViewTrips(){
        foodStoreTable = UITableView()
        foodStoreTable.register(TripBoxTableViewCell.self, forCellReuseIdentifier: TableConfigs.tableFoodStore)
        foodStoreTable.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(foodStoreTable)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            paidByMeLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 25),
            paidByMeLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            totalReceivedLabel.topAnchor.constraint(equalTo: paidByMeLabel.topAnchor),
            totalReceivedLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            foodStoreTable.topAnchor.constraint(equalTo: paidByMeLabel.bottomAnchor, constant: 16),
            foodStoreTable.leadingAnchor.constraint(equalTo: paidByMeLabel.leadingAnchor, constant: 5),
            foodStoreTable.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            foodStoreTable.bottomAnchor.constraint(equalTo: addStoreButton.topAnchor, constant: -8),
            
            
            addStoreButton.topAnchor.constraint(equalTo: foodStoreTable.bottomAnchor, constant: 8),
            addStoreButton.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
