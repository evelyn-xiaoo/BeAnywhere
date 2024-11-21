//
//  MessagingView.swift
//  BeAnywhere
//
//  Created by Evelyn Xiao on 11/21/24.
//

import UIKit

class MessagingView: UIView, UITextViewDelegate {
    var itemsTable: UITableView!
    
    var scrollView: UIScrollView!
    var contentView: UIView!
    var selectItem: UIButton!
    var textField: UITextView!
    var dropDownView: UITableView!

    override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupSelect()
        setupTextFields()
        setupScrollView()
        setupTable()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSelect(){
        selectItem = UIButton()
        selectItem = UIButton(type: .system)
        selectItem.setTitle("Select Item", for: .normal)
        selectItem.titleLabel?.textAlignment = .left
        selectItem.setTitleColor(.black, for: .normal)
        selectItem.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        selectItem.layer.cornerRadius = 5
        selectItem.layer.borderWidth = 1
        selectItem.layer.borderColor = UIColor.black.cgColor
        selectItem.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(selectItem)
        
        dropDownView = UITableView()
        dropDownView.translatesAutoresizingMaskIntoConstraints = false
        dropDownView.layer.borderColor = UIColor.black.cgColor
        dropDownView.layer.borderWidth = 1
        dropDownView.separatorStyle = .singleLine
        dropDownView.isHidden = true
        dropDownView.register(DropdownCell.self, forCellReuseIdentifier: TableConfigs.selectDropdown)
        dropDownView.rowHeight = UITableView.automaticDimension
        self.addSubview(dropDownView)
    }
    
    func setupTextFields(){
        textField = UITextView()
        textField.text = "Enter Message"
        textField.textColor = .black
        textField.font = .systemFont(ofSize: 16, weight: .regular)
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isScrollEnabled = false
        textField.delegate = self
        
        self.addSubview(textField)
    }
    
    func setupScrollView(){
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(scrollView)
        
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
    }
    
    func setupTable(){
        itemsTable = UITableView()
        itemsTable.translatesAutoresizingMaskIntoConstraints = false
        itemsTable.register(MessagingCell.self, forCellReuseIdentifier: TableConfigs.message)
        itemsTable.rowHeight = UITableView.automaticDimension
        contentView.addSubview(itemsTable)
        
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: selectItem.topAnchor, constant: -20),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            itemsTable.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            itemsTable.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            itemsTable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            itemsTable.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            itemsTable.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),
            
            dropDownView.bottomAnchor.constraint(equalTo: selectItem.topAnchor), // Position above the button
            dropDownView.centerXAnchor.constraint(equalTo: dropDownView.centerXAnchor),
            dropDownView.widthAnchor.constraint(equalTo: dropDownView.widthAnchor),
            dropDownView.heightAnchor.constraint(equalToConstant: 200),
            
            selectItem.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 20),
            selectItem.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            selectItem.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            textField.topAnchor.constraint(equalTo: selectItem.bottomAnchor, constant: 10),
            textField.widthAnchor.constraint(equalTo: selectItem.widthAnchor),
            textField.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            textField.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -40),
        ])
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)

        // Update height constraint
        textView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }

        textView.isScrollEnabled = false // Prevent scrolling
    }

}
