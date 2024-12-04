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
    var msgSendButton: UIButton!
    var textField: UITextField!
    var dropDownView: UITableView!
    var messagesTable: UITableView!

    override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupSelect()
        setupTextFields()
        //setupScrollView()
        setupTable()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSelect(){
        msgSendButton = UIButton()
        msgSendButton = UIButton(type: .system)
        msgSendButton.setTitle("Send", for: .normal)
        msgSendButton.titleLabel?.textAlignment = .left
        msgSendButton.setTitleColor(.black, for: .normal)
        msgSendButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        msgSendButton.layer.cornerRadius = 5
        msgSendButton.layer.borderWidth = 1
        msgSendButton.layer.borderColor = UIColor.black.cgColor
        msgSendButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(msgSendButton)
        
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
        textField = UITextField()
        textField.placeholder = "Enter Message"
        textField.textColor = .black
        textField.font = .systemFont(ofSize: 16, weight: .regular)
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 1
        textField.keyboardType = .default
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.black.cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        
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
        // contentView.addSubview(itemsTable)
        
        messagesTable = UITableView()
        messagesTable.register(MessageTableViewCell.self, forCellReuseIdentifier: TableConfigs.tableViewMessages)
        messagesTable.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(messagesTable)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
//
//            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
//            scrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
//            scrollView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
//            scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
//            
//            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
//            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
//            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
//            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
//            
//            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            messagesTable.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            messagesTable.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            messagesTable.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            messagesTable.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor, multiplier: 0.8),
            
//            dropDownView.bottomAnchor.constraint(equalTo: msgSendButton.topAnchor), // Position above the button
//            dropDownView.centerXAnchor.constraint(equalTo: dropDownView.centerXAnchor),
//            dropDownView.widthAnchor.constraint(equalTo: dropDownView.widthAnchor),
//            dropDownView.heightAnchor.constraint(equalToConstant: 200),
            
            textField.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 20),
            textField.widthAnchor.constraint(equalTo: msgSendButton.widthAnchor),
            textField.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            textField.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            
            msgSendButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 10),
            msgSendButton.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            msgSendButton.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
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
