//
//  StoreFormScreenView.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 11/3/24.
//

import UIKit

class StoreFormScreenView: UIView {

    var recipeImage: UIButton!
    var textFieldName: UITextField!
    var textFieldLocation: UITextField!
    var datePicker: UIDatePicker!
    var addFoodItemButton: UIButton!
    var foodItemTable: UITableView!
    var recipeImageLabel: UILabel!
    var foodItemTableLabel: UILabel!
    var datePickLabel: UILabel!
    var noSelectedItemLabel: UILabel!
    
    var myTotalPriceLabel: UILabel!
    var totalPriceLabel: UILabel!
    var myTotalPriceAmountLabel: UILabel!
    var totalPriceAmountLabel: UILabel!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = .white

        setUpLabels()
        setupaddFoodItemButton()
        setupDatePicker()
        setuptextFieldLocation()
        setuptextFieldGroupName()
        setuprecipeImage()
        setupTableViewTrips()
        initConstraints()
    }
    
    func setuprecipeImage(){
        recipeImage = UIButton(type: .system)
        recipeImage.setTitle("", for: .normal)
        recipeImage.setImage(UIImage(systemName: "photo"), for: .normal)
        recipeImage.contentHorizontalAlignment = .fill
        recipeImage.contentVerticalAlignment = .fill
        recipeImage.imageView?.contentMode = .scaleAspectFill
        recipeImage.translatesAutoresizingMaskIntoConstraints = false
        recipeImage.showsMenuAsPrimaryAction = true
        recipeImage.layer.cornerRadius = 10
        recipeImage.clipsToBounds = true
        self.addSubview(recipeImage)
    }
    
    func setupDatePicker() {
        datePicker = UIDatePicker()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        datePicker.datePickerMode = .date
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(datePicker)
    }
    
    func setuptextFieldGroupName(){
        textFieldName = UITextField()
        textFieldName.placeholder = "Food store name"
        textFieldName.keyboardType = .default
        textFieldName.borderStyle = .roundedRect
        textFieldName.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldName)
    }
    
    func setuptextFieldLocation(){
        textFieldLocation = UITextField()
        textFieldLocation.placeholder = "Address"
        textFieldLocation.keyboardType = .default
        textFieldLocation.borderStyle = .roundedRect
        textFieldLocation.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldLocation)
    }
    
    func setupaddFoodItemButton(){
        addFoodItemButton = UIButton(type: .system)
        addFoodItemButton.setTitle("", for: .normal)
        addFoodItemButton.setImage(UIImage(systemName: "cart.badge.plus")?.withRenderingMode(.alwaysOriginal), for: .normal)
        addFoodItemButton.contentHorizontalAlignment = .fill
        addFoodItemButton.contentVerticalAlignment = .fill
        addFoodItemButton.imageView?.contentMode = .scaleAspectFit
        addFoodItemButton.layer.cornerRadius = 16
        addFoodItemButton.imageView?.layer.shadowOffset = .zero
        addFoodItemButton.imageView?.layer.shadowRadius = 0.8
        addFoodItemButton.imageView?.layer.shadowOpacity = 0.7
        addFoodItemButton.imageView?.clipsToBounds = true
        addFoodItemButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(addFoodItemButton)
    }
    
    func setUpLabels() {
        recipeImageLabel = UILabel()
        foodItemTableLabel = UILabel()
        myTotalPriceLabel = UILabel()
        myTotalPriceAmountLabel = UILabel()
        totalPriceLabel = UILabel()
        totalPriceAmountLabel = UILabel()
        //datePickLabel = UILabel()
        noSelectedItemLabel = UILabel()
        
        let appLabels: [UILabel] = [ recipeImageLabel, foodItemTableLabel, myTotalPriceLabel, myTotalPriceAmountLabel, totalPriceLabel, totalPriceAmountLabel, noSelectedItemLabel]
        
        foodItemTableLabel.font = UIFont.boldSystemFont(ofSize: 15)
        recipeImageLabel.font = UIFont.boldSystemFont(ofSize: 13)
        recipeImageLabel.text = "Receipt image (optional)"
        foodItemTableLabel.text = "Food Items"
        
        /*
        datePickLabel.font = UIFont.boldSystemFont(ofSize: 15)
        datePickLabel.text = "Date"
        */
        
        myTotalPriceLabel.font = UIFont.boldSystemFont(ofSize: 15)
        myTotalPriceAmountLabel.font = UIFont.boldSystemFont(ofSize: 13)
        myTotalPriceLabel.text = "Your total"
        
        totalPriceLabel.font = UIFont.boldSystemFont(ofSize: 15)
        totalPriceAmountLabel.font = UIFont.boldSystemFont(ofSize: 13)
        totalPriceLabel.text = "Total"
        
        noSelectedItemLabel.font = UIFont.boldSystemFont(ofSize: 13)
        noSelectedItemLabel.numberOfLines = 0
        
        
        // apply common attributes to the labels
        for label: UILabel in appLabels {
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            self.addSubview(label)
        }
    }
    
    func setupTableViewTrips(){
        foodItemTable = UITableView()
        foodItemTable.register(FoodItemTableViewCell.self, forCellReuseIdentifier: TableConfigs.tableFoodItem)
        foodItemTable.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(foodItemTable)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            textFieldName.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            textFieldName.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            textFieldName.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            textFieldName.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            textFieldLocation.topAnchor.constraint(equalTo: textFieldName.bottomAnchor, constant: 10),
            textFieldLocation.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            textFieldLocation.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.6),
            
            datePicker.topAnchor.constraint(equalTo: textFieldName.bottomAnchor, constant: 10),
            datePicker.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            datePicker.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.3),
            
            recipeImage.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 16),
            recipeImage.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            recipeImage.widthAnchor.constraint(equalToConstant: 100),
            recipeImage.heightAnchor.constraint(equalToConstant: 100),
            
            recipeImageLabel.topAnchor.constraint(equalTo: recipeImage.bottomAnchor, constant: 8),
            recipeImageLabel.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            foodItemTableLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            foodItemTableLabel.topAnchor.constraint(equalTo: recipeImageLabel.bottomAnchor, constant: 16),
            
            foodItemTable.topAnchor.constraint(equalTo: foodItemTableLabel.bottomAnchor, constant: 10),
            foodItemTable.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            foodItemTable.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            foodItemTable.bottomAnchor.constraint(equalTo: myTotalPriceLabel.topAnchor, constant: -20),
            
            noSelectedItemLabel.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            noSelectedItemLabel.topAnchor.constraint(equalTo: foodItemTableLabel.bottomAnchor, constant: 32),
            
            myTotalPriceLabel.bottomAnchor.constraint(equalTo: totalPriceLabel.topAnchor, constant: -8),
            myTotalPriceLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            totalPriceLabel.bottomAnchor.constraint(equalTo: addFoodItemButton.topAnchor, constant: -16),
            totalPriceLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            myTotalPriceAmountLabel.topAnchor.constraint(equalTo: myTotalPriceLabel.topAnchor),
            myTotalPriceAmountLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            totalPriceAmountLabel.topAnchor.constraint(equalTo: totalPriceLabel.topAnchor),
            totalPriceAmountLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            addFoodItemButton.widthAnchor.constraint(equalToConstant: 48),
            addFoodItemButton.heightAnchor.constraint(equalToConstant: 48),
            addFoodItemButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addFoodItemButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
