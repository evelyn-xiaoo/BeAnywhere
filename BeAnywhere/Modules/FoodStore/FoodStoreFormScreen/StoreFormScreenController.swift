//
//  StoreFormScreenController.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 11/3/24.
//

import UIKit
import PhotosUI
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

class StoreFormScreenController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let addStoreView = StoreFormScreenView()
    let searchSheetController = FoodItemAddBottmSheetController()
    let childProgressView = ProgressSpinnerViewController()
    var searchSheetNavController: UINavigationController!
    let notificationCenter = NotificationCenter.default
    let database = Firestore.firestore()
    let storage = Storage.storage()
    let currentUser = Auth.auth().currentUser!
    var currentFirestoreUser: FirestoreUser? = nil
    
    var foodItems: [FoodItemInForm] = []
    var pickedRecipeImage: UIImageView!
    
    // MARK: Fields that need to be initialized from other calls
    var currentTrip: FoodTripFromDoc? = nil
    
    // MARK: Fields that can be initialized from other calls
    var selectedFoodStore: FoodStore? = nil
    
    
    override func loadView() {
        view = addStoreView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        pickedRecipeImage = UIImageView()
        
        // MARK: load the current user from Firestore
        Task.detached {
            self.showActivityIndicator()
            let currentFirestoreUser = await UserFirebaseService().getUser(uid: self.currentUser.uid)
            
            if let currentFirestoreUser {
                self.currentFirestoreUser = currentFirestoreUser
                await self.prefillViewFields()
            } else {
                showErrorAlert(message: "Cannot load user information. Please try again later.", controller: self)
            }
            self.hideActivityIndicator()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = selectedFoodStore == nil ? "New Food Store" : "Edit Food Store"
       
        //MARK: setting the delegate and data source...
        addStoreView.foodItemTable.dataSource = self
        addStoreView.foodItemTable.delegate = self
        //MARK: removing the separator line...
        addStoreView.foodItemTable.separatorStyle = .none
        addStoreView.foodItemTable.rowHeight = 81
        
        let confirmButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(confirmNewFoodStore))
        
        navigationItem.rightBarButtonItems = [confirmButton]
        addStoreView.recipeImage.menu = getMenuImagePicker()
        
        addStoreView.addFoodItemButton.addTarget(self, action: #selector(onFindButtonTapped), for: .touchUpInside)
        
        // MARK: setup notification observer to listen new added food item
        notificationCenter.addObserver(
                    self,
                    selector: #selector(notificationReceivedForFoodItemAdded(notification:)),
                    name: Notification.Name(NotificationConfigs.NewFoodItemObserverName),
                    object: nil)
    }
    
    func prefillViewFields() async {
        if let selectedFoodStore {
            // MARK: indicates the controller is used for existing food store edit
            addStoreView.textFieldName.text = selectedFoodStore.storeName
            addStoreView.textFieldLocation.text = selectedFoodStore.address
            addStoreView.datePicker.date = selectedFoodStore.dateCreated
            addStoreView.totalPriceAmountLabel.text = selectedFoodStore.foodItems.reduce(0) { $0 + $1.price }.formatted()
            
            self.addStoreView.myTotalPriceAmountLabel.text = selectedFoodStore.foodItems.filter({$0.payers.contains(where: {$0.id == self.currentFirestoreUser!.id
                })}).reduce(0) { $0 + $1.price }.formatted()
            
            // Load the recipe image
            await setRecipeImageFromURL(imageUrlString: selectedFoodStore.recipeImage)
            
            // Load food item's images
            for foodItem in selectedFoodStore.foodItems {
                foodItems.append(FoodItemInForm(id: foodItem.id, name: foodItem.name, price: foodItem.price, payers: foodItem.payers, imageUrlToLoad: foodItem.foodImage))
            }
                                 
            addStoreView.foodItemTable.reloadData()
        } else {
            // MARK: indicates the controller is used for adding a new food store
            addStoreView.datePicker.date = Date.now
            addStoreView.totalPriceAmountLabel.text = "$ 0"
            addStoreView.myTotalPriceAmountLabel.text = "$ 0"
        }
    }
    
    // MARK: adds the new food item in the form and closes the bottom sheet
    @objc func notificationReceivedForFoodItemAdded(notification: Notification){
        let newFoodItemWithImage = notification.object as! FoodItemInForm
        
        foodItems.append(newFoodItemWithImage)
        addStoreView.foodItemTable.reloadData()
        updateTotalAmount()
        dismiss(animated: true)
    }
    
    @objc func confirmNewFoodStore() {
        let newFoodStoreName: String? = addStoreView.textFieldName.text
        let newFoodStoreLocation: String? = addStoreView.textFieldLocation.text
        let newFoodStoreDate: Date = addStoreView.datePicker.date
        let newDebtors = getNewDebtorsFromFoodItems()
        
        if (newDebtors.isEmpty) {
            showErrorAlert(message: "There should be at least one debtor who pays your bill. Please try again.", controller: self)
            return
        }
        
        if let newFoodStoreName, let newFoodStoreLocation, let currentTrip  {
            do {
                if var selectedFoodStore {
                    // MARK: update the new edited food store in the Firestore
                    
                    
                    let newFoodStore: FoodStoreInForm = FoodStoreInForm(id: selectedFoodStore.id, storeName: newFoodStoreName, address: newFoodStoreLocation, submitter: self.currentFirestoreUser!, dateCreated: newFoodStoreDate, recipeImage: "", foodItems: self.foodItems, debtors: newDebtors)
                    
                    Task.detached{
                        await self.updateExistingFoodStore(newStore: newFoodStore, tripId: currentTrip.id)
                    }
                } else {
                    // MARK: save a new food store in the Firestore
                    let newFoodStore: FoodStoreInForm = FoodStoreInForm(id: "", storeName: newFoodStoreName, address: newFoodStoreLocation, submitter: self.currentFirestoreUser!, dateCreated: newFoodStoreDate, recipeImage: "", foodItems: self.foodItems, debtors: newDebtors)
                    
                    Task.detached {
                            await self.saveNewFoodStore(newFoodStore, tripId: currentTrip.id)
                        
                    }
                }
            }
            
        } else {
            showErrorAlert(message: "Failed to create new food store. Please try again.", controller: self)
        }
    }
    
    func setRecipeImageFromURL(imageUrlString: String) async  {
        if let imageURL = URL(string: imageUrlString) {
            await pickedRecipeImage.loadRemoteImage(from: imageURL)
            await addStoreView.recipeImage.loadRemoteImage(from: imageURL)
        } else {
            pickedRecipeImage.setSymbolImage(UIImage(systemName: "photo")!.withRenderingMode(.alwaysOriginal), contentTransition: .automatic)
        }
        
    }
    
    // MARK: Updates the total food item prices
    func updateTotalAmount() {
        var currentUserTotal: Double = 0.0
        var totalPriceAmount: Double = 0.0
        
        for foodItem in foodItems {
            if (foodItem.payers.contains(where: { $0.id == currentUser.uid })) {
                currentUserTotal += foodItem.price / Double(foodItem.payers.count)
            }
            totalPriceAmount += foodItem.price
        }
        
        addStoreView.myTotalPriceAmountLabel.text = "$ \(roundToTwoPlace(currentUserTotal))"
        addStoreView.totalPriceAmountLabel.text = "$ \(roundToTwoPlace(totalPriceAmount))"
    }
    
    func getNewDebtorsFromFoodItems() -> [Debtor] {
        var debtors: [Debtor] = []
        for foodItem in foodItems {
            for member in foodItem.payers {
                if (!debtors.contains(where: { member.id == $0.user.id}) && member.id != currentUser.uid) {
                    debtors.append(Debtor(id: "", user: member, dateCreated: Date.now, paymentStatus: PaymentStatus.pending))
                }
            }
        }
        return debtors
    }
    
    func setupFoodItemBottomSheet(){
        if let currentTrip {
            searchSheetController.tripMemberIds = currentTrip.memberIds
                //MARK: setting up bottom search sheet...
                searchSheetNavController = UINavigationController(rootViewController: searchSheetController)
                
                // MARK: setting up modal style...
                searchSheetNavController.modalPresentationStyle = .pageSheet
                
                if let bottomSearchSheet = searchSheetNavController.sheetPresentationController{
                    bottomSearchSheet.detents = [.large()]
                    bottomSearchSheet.prefersGrabberVisible = true
                }
            present(searchSheetNavController, animated: true)
        } else {
            showErrorAlert(message: "Unknown error ocurred. Please try again later.", controller: self)
        }
    }
    
    @objc func onFindButtonTapped(){
        setupFoodItemBottomSheet()
    }
    
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
        requestCameraAccess { [weak self] isAuthorized in
            guard let self = self else { return }
            
            if isAuthorized {
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = .camera
                imagePicker.delegate = self
                self.present(imagePicker, animated: true)
            } else {
                showErrorAlert(message: "Camera access is required to capture a profile picture.", controller: self)
            }
        }
    }


    
    func requestCameraAccess(completion: @escaping (Bool) -> Void) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:
            completion(true) // Already authorized
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        default:
            completion(false) // Access denied or restricted
        }
    }

    
    func pickPhotoFromGallery() {
        requestPhotoLibraryAccess { isAuthorized in
            if isAuthorized {
                var configuration = PHPickerConfiguration()
                configuration.filter = .images
                configuration.selectionLimit = 1
                let picker = PHPickerViewController(configuration: configuration)
                picker.delegate = self
                self.present(picker, animated: true)
            } else {
                showErrorAlert(message: "Photo library access is required to select a profile picture.", controller: self)
            }
        }
    }

    
    func requestPhotoLibraryAccess(completion: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .authorized:
            completion(true) // Already authorized
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { newStatus in
                DispatchQueue.main.async {
                    completion(newStatus == .authorized)
                }
            }
        default:
            completion(false) // Access denied or restricted
        }
    }
    
    func deleteFoodItem(index: Int) {
        foodItems.remove(at: index)
        addStoreView.foodItemTable.reloadData()
        updateTotalAmount()
    }
}

extension StoreFormScreenController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (foodItems.isEmpty) {
            addStoreView.noSelectedItemLabel.text = "No items added yet. \n\n Add item by clicking bottom right button."
            addStoreView.noSelectedItemLabel.layer.zPosition = 1
        } else {
            addStoreView.noSelectedItemLabel.text = ""
            addStoreView.foodItemTable.layer.zPosition = -1
        }
        return foodItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableConfigs.tableFoodItem, for: indexPath) as! FoodItemTableViewCell
        let foodItemImage = foodItems[indexPath.row].foodImage
        cell.itemNameLabel.text = foodItems[indexPath.row].name
        cell.itemCostLabel.text = "$ \(foodItems[indexPath.row].price.formatted())"
        cell.itemPayersLabel.text = foodItems[indexPath.row].payers.map({$0.name}).joined(separator: ", ")
        
        if let foodItemImage {
                cell.itemImage.setSymbolImage(foodItemImage, contentTransition: .automatic)
            
        } else if let imageUrlToLoad = foodItems[indexPath.row].imageUrlToLoad {
            if let foodItemUrl = URL(string: imageUrlToLoad) {
                Task.detached {
                    await cell.itemImage.loadRemoteImage(from: foodItemUrl)
                    self.foodItems[indexPath.row].foodImage = cell.itemImage.image
                }
            }
        }
        
        if (foodItems[indexPath.row].payers.contains(where: ({$0.id == self.currentUser.uid}))) {
            cell.checkBoxImage.setSymbolImage(UIImage(systemName: "square.fill")!, contentTransition: .automatic)
        }
        
        // MARK: creating an accessory button...
        let buttonOptions = UIButton(type: .system)
        buttonOptions.sizeToFit()
        buttonOptions.showsMenuAsPrimaryAction = true
        buttonOptions.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
        
        //MARK: setting up menu for button options click...
        buttonOptions.menu = UIMenu(title: "Delete?",
                                    children: [
                                        UIAction(title: "Delete",handler: {(_) in
                                            self.deleteFoodItem(index: indexPath.row)
                                        })
                                    ])
        //MARK: setting the button as an accessory of the cell...
        cell.accessoryView = buttonOptions
     
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // MARK: on current trip box click -> navigate to trip details page
    }
}

extension StoreFormScreenController: UIPickerViewDelegate, UIPickerViewDataSource, PHPickerViewControllerDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        let itemprovider = results.map(\.itemProvider)
        
        for item in itemprovider {
            if item.canLoadObject(ofClass: UIImage.self){
                item.loadObject(ofClass: UIImage.self, completionHandler: { (image, error) in
                    DispatchQueue.main.async {
                        if let uwImage = image as? UIImage{
                            self.addStoreView.recipeImage.setImage(
                                uwImage.withRenderingMode(.alwaysOriginal),
                                for: .normal
                            )
                            self.pickedRecipeImage.image = uwImage
                        }
                    }
                })
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let image = info[.editedImage] as? UIImage{
            self.addStoreView.recipeImage.setImage(
                image.withRenderingMode(.alwaysOriginal),
                for: .normal
            )
            self.pickedRecipeImage.image = image
        }else{
            showAlertText(text: "Failed to take photo", controller: self)
        }
    }
}

extension StoreFormScreenController:ProgressSpinnerDelegate{
    func showActivityIndicator(){
        addChild(childProgressView)
        view.addSubview(childProgressView.view)
        childProgressView.didMove(toParent: self)
    }
    
    func hideActivityIndicator(){
        childProgressView.willMove(toParent: nil)
        childProgressView.view.removeFromSuperview()
        childProgressView.removeFromParent()
    }
}
