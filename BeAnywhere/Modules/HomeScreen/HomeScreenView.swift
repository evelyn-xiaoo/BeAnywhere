//
//  HomeScreenView.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 11/3/24.
//
import UIKit

class HomeScreenView: UIView {

    var addTripButton: UIButton!
    var tripTable: UITableView!
    var currentTripLabel: UILabel!
    var noTripLabel: UILabel!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = .white

        setUpLabels()
        setupAddTripButton()
        
        setupTableViewTrips()
        initConstraints()
    }
    
    func setupAddTripButton(){
        addTripButton = UIButton(type: .system)
        addTripButton.setTitle("New trip", for: .normal)
        addTripButton.layer.borderColor = UIColor.black.cgColor
        addTripButton.layer.borderWidth = 1
        addTripButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        addTripButton.setTitleColor(UIColor.black, for: .normal)
        addTripButton.titleLabel?.textAlignment = .center
        //addTripButton.setImage(UIImage(systemName: "map.circle.fill")?.withRenderingMode(.alwaysOriginal), for: .normal)
        //addTripButton.contentHorizontalAlignment = .fill
        //addTripButton.contentVerticalAlignment = .fill
        //addTripButton.imageView?.contentMode = .scaleAspectFit
        //addTripButton.layer.cornerRadius = 16
        //addTripButton.imageView?.layer.shadowOffset = .zero
        //addTripButton.imageView?.layer.shadowRadius = 0.8
        //addTripButton.imageView?.layer.shadowOpacity = 0.7
        //addTripButton.imageView?.clipsToBounds = true
        addTripButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(addTripButton)
    }
    
    func setUpLabels() {
        currentTripLabel = UILabel()
        noTripLabel = UILabel()
        
        currentTripLabel.font = UIFont.systemFont(ofSize: 16)
        noTripLabel.font = UIFont.boldSystemFont(ofSize: 16)
        noTripLabel.numberOfLines = 0
        
        let appLabels: [UILabel] = [currentTripLabel, noTripLabel]
        
        // apply common attributes to the labels
        for label: UILabel in appLabels {
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            self.addSubview(label)
        }
    }
    
    func setupTableViewTrips(){
        tripTable = UITableView()
        tripTable.register(TripBoxTableViewCell.self, forCellReuseIdentifier: TableConfigs.tableViewTrips)
        tripTable.rowHeight = UITableView.automaticDimension
        tripTable.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tripTable)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            currentTripLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            currentTripLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            noTripLabel.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            noTripLabel.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),
            
            
            tripTable.topAnchor.constraint(equalTo: currentTripLabel.bottomAnchor, constant: 10),
            tripTable.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tripTable.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            tripTable.bottomAnchor.constraint(equalTo: addTripButton.topAnchor, constant: -20),
            
            /*
            addTripButton.widthAnchor.constraint(equalToConstant: 48),
            addTripButton.heightAnchor.constraint(equalToConstant: 48),
            addTripButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addTripButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
             */
            
            addTripButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addTripButton.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.7),
            addTripButton.heightAnchor.constraint(equalToConstant: 48),
            addTripButton.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
