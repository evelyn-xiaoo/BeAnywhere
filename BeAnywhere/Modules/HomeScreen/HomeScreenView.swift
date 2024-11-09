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
        addTripButton.setTitle("", for: .normal)
        addTripButton.setImage(UIImage(systemName: "map.circle.fill")?.withRenderingMode(.alwaysOriginal), for: .normal)
        addTripButton.contentHorizontalAlignment = .fill
        addTripButton.contentVerticalAlignment = .fill
        addTripButton.imageView?.contentMode = .scaleAspectFit
        addTripButton.layer.cornerRadius = 16
        addTripButton.imageView?.layer.shadowOffset = .zero
        addTripButton.imageView?.layer.shadowRadius = 0.8
        addTripButton.imageView?.layer.shadowOpacity = 0.7
        addTripButton.imageView?.clipsToBounds = true
        addTripButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(addTripButton)
    }
    
    func setUpLabels() {
        currentTripLabel = UILabel()
        
        let appLabels: [UILabel] = [currentTripLabel]
        
        currentTripLabel.font = UIFont.boldSystemFont(ofSize: 15)
        
        
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
        tripTable.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tripTable)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            currentTripLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 25),
            currentTripLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            tripTable.topAnchor.constraint(equalTo: currentTripLabel.bottomAnchor, constant: 16),
            tripTable.leadingAnchor.constraint(equalTo: currentTripLabel.leadingAnchor, constant: 5),
            tripTable.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            tripTable.bottomAnchor.constraint(equalTo: addTripButton.topAnchor, constant: -8),
            
            addTripButton.widthAnchor.constraint(equalToConstant: 48),
            addTripButton.heightAnchor.constraint(equalToConstant: 48),
            addTripButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addTripButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
