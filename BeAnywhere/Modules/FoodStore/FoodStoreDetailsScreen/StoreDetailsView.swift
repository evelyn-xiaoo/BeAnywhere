//
//  StoreDetailsView.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 11/23/24.
//

import UIKit

class StoreDetailsView: UIView {
    var storeDateLabel: UILabel!
    var totalCostAmountLabel: UILabel!
    var totalCostLabel: UILabel!
    var paidTitleLabel: UILabel!
    
    var foodStoreImageView: UIImageView!
    
    var memberWithFoodItemsTable: UITableView!
    var memberWithPaymentStatusTable: UITableView!
    
    var scrollView: UIScrollView!
    var contentView: UIView!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupScrollView()
        setupMemberWithItemaTableView()
        setUpLabels()
        setupStoreImage()
        setupDebtorWithStatusTable()
        initConstraints()
    }
    
    func setupStoreImage(){
        foodStoreImageView = UIImageView()
        foodStoreImageView.image = UIImage(systemName: "document")?.withRenderingMode(.alwaysOriginal) // MARK: Update this to use actual saved image
        foodStoreImageView.contentMode = .scaleAspectFit
        foodStoreImageView.clipsToBounds = true
        foodStoreImageView.layer.masksToBounds = true
        foodStoreImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(foodStoreImageView)
    }
    
    func setupScrollView(){
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
    }
    
    func setUpLabels() {
        storeDateLabel = UILabel()
        totalCostAmountLabel = UILabel()
        totalCostLabel = UILabel()
        paidTitleLabel = UILabel()
        
        storeDateLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        
        totalCostLabel.text = "Total"
        totalCostLabel.font = UIFont.systemFont(ofSize: 14)
        
        totalCostAmountLabel.text = "$0.00"
        totalCostAmountLabel.font = UIFont.systemFont(ofSize: 14)
        
        paidTitleLabel.text = "Paid?"
        paidTitleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        let appLabels: [UILabel] = [storeDateLabel, totalCostAmountLabel, totalCostLabel, paidTitleLabel]
        
        // apply common attributes to the labels
        for label: UILabel in appLabels {
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            contentView.addSubview(label)
        }
    }
    
    func setupMemberWithItemaTableView(){
        memberWithFoodItemsTable = UITableView()
        memberWithFoodItemsTable.register(StoreMemberCell.self, forCellReuseIdentifier: TableConfigs.foodItemMember)
        memberWithFoodItemsTable.rowHeight = 35
        memberWithFoodItemsTable.showsVerticalScrollIndicator = false
        memberWithFoodItemsTable.isScrollEnabled = false
        memberWithFoodItemsTable.contentInsetAdjustmentBehavior = .automatic
        memberWithFoodItemsTable.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(memberWithFoodItemsTable)
    }
    
    func setupDebtorWithStatusTable(){
        memberWithPaymentStatusTable = UITableView()
        memberWithPaymentStatusTable.register(DebtorTableCell.self, forCellReuseIdentifier: TableConfigs.foodItemDebtor)
        memberWithPaymentStatusTable.rowHeight = 20
        memberWithPaymentStatusTable.isScrollEnabled = false
        memberWithPaymentStatusTable.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(memberWithPaymentStatusTable)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            scrollView.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor),
            scrollView.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            storeDateLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            storeDateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            foodStoreImageView.topAnchor.constraint(equalTo: storeDateLabel.bottomAnchor, constant: 32),
            foodStoreImageView.heightAnchor.constraint(equalToConstant: 100),
            foodStoreImageView.widthAnchor.constraint(equalTo: foodStoreImageView.heightAnchor),
            foodStoreImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            memberWithFoodItemsTable.topAnchor.constraint(equalTo: foodStoreImageView.bottomAnchor, constant: 20),
            memberWithFoodItemsTable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            memberWithFoodItemsTable.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            memberWithFoodItemsTable.heightAnchor.constraint(greaterThanOrEqualToConstant: 200),
            
            paidTitleLabel.topAnchor.constraint(equalTo: memberWithFoodItemsTable.bottomAnchor, constant: 20),
            paidTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            memberWithPaymentStatusTable.topAnchor.constraint(equalTo: paidTitleLabel.bottomAnchor, constant: 10),
            memberWithPaymentStatusTable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            memberWithPaymentStatusTable.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            memberWithPaymentStatusTable.heightAnchor.constraint(greaterThanOrEqualToConstant: 150),
            
            totalCostLabel.topAnchor.constraint(equalTo: memberWithPaymentStatusTable.bottomAnchor, constant: 40),
            totalCostLabel.leadingAnchor.constraint(equalTo: memberWithPaymentStatusTable.leadingAnchor),
            totalCostLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            totalCostAmountLabel.topAnchor.constraint(equalTo: totalCostLabel.topAnchor),
            totalCostAmountLabel.trailingAnchor.constraint(equalTo: memberWithPaymentStatusTable.trailingAnchor, constant: -20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
