//
//  FoodItemAddBottomSheetView.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 11/7/24.
//

import UIKit

class FoodItemAddBottomSheetView: UIView {
    var searchBar: UISearchBar!
    var tableViewSearchResults: UITableView!
    var itemNameTextField: UITextField!
    var itemPriceTextField: UITextField!
    var foodImageButton: UIButton!
    var saveItemButton: UIButton!
    var foodImageButtonLabel: UILabel!
    var imageClearButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        setupMembersTable()
        setupButtonImage()
        setupTextButton()
        setupTextFields()
        setupLabels()
        
        initConstraints()
    }
    
    func setupMembersTable() {
        //MARK: Table view...
        tableViewSearchResults = UITableView()
        tableViewSearchResults.register(FoodItemAddTableViewCell.self, forCellReuseIdentifier: TableConfigs.memberCheckBox)
        tableViewSearchResults.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableViewSearchResults)
    }
    
    func setupButtonImage() {
        foodImageButton = UIButton(type: .system)
        foodImageButton.setTitle("", for: .normal)
        foodImageButton.setImage(UIImage(systemName: "photo"), for: .normal)
        foodImageButton.tintColor = .gray
        foodImageButton.contentHorizontalAlignment = .fill
        foodImageButton.contentVerticalAlignment = .fill
        foodImageButton.imageView?.contentMode = .scaleAspectFill
        foodImageButton.translatesAutoresizingMaskIntoConstraints = false
        foodImageButton.showsMenuAsPrimaryAction = true
        foodImageButton.layer.cornerRadius = 10
        foodImageButton.clipsToBounds = true
        self.addSubview(foodImageButton)
    }
    
    func setupTextButton() {
        saveItemButton = UIButton(type: .system)
        saveItemButton.setTitle("Done", for: .normal)
        saveItemButton.contentHorizontalAlignment = .fill
        saveItemButton.contentVerticalAlignment = .fill
        saveItemButton.layer.cornerRadius = 16
        saveItemButton.translatesAutoresizingMaskIntoConstraints = false
        
        imageClearButton = UIButton(type: .system)
        imageClearButton.setTitle("Clear", for: .normal)
        imageClearButton.contentHorizontalAlignment = .fill
        imageClearButton.contentVerticalAlignment = .fill
        imageClearButton.layer.cornerRadius = 16
        imageClearButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(saveItemButton)
        self.addSubview(imageClearButton)
    }
    
    func setupTextFields() {
        itemNameTextField = UITextField()
        itemNameTextField.placeholder = "Item name"
        
        itemPriceTextField = UITextField()
        itemPriceTextField.placeholder = "Cost"
        itemPriceTextField.keyboardType = .decimalPad
        
        let textFields: [UITextField] = [itemNameTextField, itemPriceTextField]
        
        
        // MARK: apply common attributes
        for textField: UITextField in textFields {
            textField.keyboardType = .default
            textField.borderStyle = .roundedRect
            textField.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(textField)
        }
    }
    
    func setupLabels() {
        foodImageButtonLabel = UILabel()
        
        let appLabels: [UILabel] = [ foodImageButtonLabel ]
        
        foodImageButtonLabel.font = UIFont.boldSystemFont(ofSize: 15)
        foodImageButtonLabel.text = "Item image (optional)"
        
        // apply common attributes to the labels
        for label: UILabel in appLabels {
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            self.addSubview(label)
        }
    }
    
    func initConstraints() {
        //MARK: constraints...
        NSLayoutConstraint.activate([
            itemNameTextField.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 32),
            itemNameTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            itemNameTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            itemPriceTextField.topAnchor.constraint(equalTo: itemNameTextField.bottomAnchor, constant: 8),
            itemPriceTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            itemPriceTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            foodImageButton.topAnchor.constraint(equalTo: itemPriceTextField.bottomAnchor, constant: 16),
            foodImageButton.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            foodImageButton.widthAnchor.constraint(equalToConstant: 100),
            foodImageButton.heightAnchor.constraint(equalToConstant: 100),
            
            foodImageButtonLabel.topAnchor.constraint(equalTo: foodImageButton.bottomAnchor, constant: 8),
            foodImageButtonLabel.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            imageClearButton.topAnchor.constraint(equalTo: foodImageButtonLabel.bottomAnchor, constant: 8),
            imageClearButton.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            tableViewSearchResults.topAnchor.constraint(equalTo: imageClearButton.bottomAnchor, constant: 8),
            tableViewSearchResults.bottomAnchor.constraint(equalTo:saveItemButton.topAnchor, constant: -16),
            tableViewSearchResults.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor),
            
            saveItemButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            saveItemButton.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
        
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
