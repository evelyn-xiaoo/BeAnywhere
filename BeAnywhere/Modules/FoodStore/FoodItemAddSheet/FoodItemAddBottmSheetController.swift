//
//  FoodItemAddBottmSheetController.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 11/7/24.
//

import UIKit
import PhotosUI
import FirebaseFirestore

class FoodItemAddBottmSheetController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let searchSheet = FoodItemAddBottomSheetView()
    let database = Firestore.firestore()
    let notificationCenter = NotificationCenter.default
    
    var selectedPayers: [FirestoreUser] = []
    var pickedItemImage: UIImage?
    var allTripMembers = [FirestoreUser]()
    
    // MARK: a field that gets initialized from trip details controller
    var tripMemberIds = [String]()
        
        
    override func loadView() {
        view = searchSheet
    }
    
    override func viewWillAppear(_ animated: Bool) {
        selectedPayers.removeAll()
        Task.detached {
            let tripMembers = await UserFirebaseService().getUsers(userIds: self.tripMemberIds)
            if let tripMembers {
                self.allTripMembers.replaceSubrange(0..<self.allTripMembers.count, with: tripMembers)
                await self.searchSheet.tableViewSearchResults.reloadData()
            } else {
                showErrorAlert(message: "Failed to get members info. Please try again later.", controller: self)
            }
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchSheet.foodImageButton.menu = getMenuImagePicker()
        
        //MARK: setting up Table View data source and delegate...
        searchSheet.tableViewSearchResults.delegate = self
        searchSheet.tableViewSearchResults.dataSource = self
        
        searchSheet.saveItemButton.addTarget(self, action: #selector(onItemSaveButtonClick), for: .touchUpInside)
        
        searchSheet.imageClearButton.addTarget(self, action: #selector(onImageClearButtonClick), for: .touchUpInside)
        
    }
    
    @objc func onItemSaveButtonClick() {
        let newFoodItemName = searchSheet.itemNameTextField.text
        let newFoodItemPrice = searchSheet.itemPriceTextField.text
        
        if let newFoodItemName, let newFoodItemPrice {
            let priceAmount = Double(newFoodItemPrice)
            if let priceAmount, priceAmount > 0.0 {
                
                if (selectedPayers.isEmpty) {
                    showErrorAlert(message: "Choose at least one payer.", controller: self)
                    return
                }
                 
                
                if (newFoodItemName == "" || newFoodItemPrice == "") {
                    showErrorAlert(message: "Name and price cannot be empty. Please try again.", controller: self)
                    return
                }
                
                let newFoodItem = FoodItemInForm(id: "", name: newFoodItemName, price: roundToTwoPlace(priceAmount), payers: selectedPayers, foodImage: pickedItemImage)
                
                notificationCenter.post(
                    name: Notification.Name(NotificationConfigs.NewFoodItemObserverName),
                    object: newFoodItem)
                
            } else {
                showErrorAlert(message: "Invalid item price. Please enter a valid price.", controller: self)
            }
            
        } else {
            showErrorAlert(message: "Invalid text fields. Please try again.", controller: self)
        }
    }
    
    @objc func onImageClearButtonClick() {
        if pickedItemImage != nil {
            pickedItemImage = nil
            searchSheet.foodImageButton.setImage(UIImage(systemName: "photo"), for: .normal)
        }
    }
    
    // MARK: Image picker methods
    func getMenuImagePicker() -> UIMenu {
        let menuItems = [
                    UIAction(title: "Camera",handler: {(_) in
                        self.pickUsingCamera()
                    }),
                    UIAction(title: "Gallery",handler: {(_) in
                        self.pickPhotoFromGallery()
                    })
                ]
                
        return UIMenu(title: "Select source", children: menuItems)
    }
    
    func pickUsingCamera() {
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = .camera
                imagePicker.delegate = self
                self.present(imagePicker, animated: true)
            
    }
    
    func pickPhotoFromGallery() {
    
                var configuration = PHPickerConfiguration()
                configuration.filter = .images
                configuration.selectionLimit = 1
                let picker = PHPickerViewController(configuration: configuration)
                picker.delegate = self
                self.present(picker, animated: true)
            
    }

    
    
}

//MARK: adopting Table View protocols...
extension FoodItemAddBottmSheetController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTripMembers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: TableConfigs.memberCheckBox, for: indexPath) as! FoodItemAddTableViewCell
        
        cell.labelTitle.text = allTripMembers[indexPath.row].name
        cell.checkBox.setSymbolImage(UIImage(systemName: "square")!, contentTransition: .replace)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? FoodItemAddTableViewCell else {
                return
            }
        let selectedUser: FirestoreUser = allTripMembers[indexPath.row]
        
        if (selectedPayers.contains(where: ({$0.id == selectedUser.id}))) {
            selectedPayers.removeAll(where: ({$0.id == selectedUser.id}))
            cell.checkBox.setSymbolImage(UIImage(systemName: "square")!, contentTransition: .automatic)
        } else {
            selectedPayers.append(selectedUser)
            cell.checkBox.setSymbolImage(UIImage(systemName: "square.fill")!, contentTransition: .automatic)
        }
        
    }
}

extension FoodItemAddBottmSheetController: UIPickerViewDelegate, UIPickerViewDataSource, PHPickerViewControllerDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        let itemprovider = results.map(\.itemProvider)
        
        for item in itemprovider{
            if item.canLoadObject(ofClass: UIImage.self){
                item.loadObject(ofClass: UIImage.self, completionHandler: { (image, error) in
                    DispatchQueue.main.async{
                        if let uwImage = image as? UIImage{
                            self.searchSheet.foodImageButton.setImage(
                                uwImage.withRenderingMode(.alwaysOriginal),
                                for: .normal
                            )
                            self.pickedItemImage = uwImage
                        }
                    }
                })
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let image = info[.editedImage] as? UIImage{
            self.searchSheet.foodImageButton.setImage(
                image.withRenderingMode(.alwaysOriginal),
                for: .normal
            )
            self.pickedItemImage = image
        }else{
            showAlertText(text: "Failed to take photo", controller: self)
        }
    }
}
