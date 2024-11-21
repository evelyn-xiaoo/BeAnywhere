//
//  EditTripScreenController.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 11/3/24.
//

import UIKit
import PhotosUI
import FirebaseFirestore
import FirebaseStorage

class EditTripScreenController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let editTripView = EditTripScreenView()
    var currentTrip: FoodTripFromDoc? = nil
    var groupMembers: [FirestoreUser] = []
    let searchSheetController = UserSearchBottmSheetController()
    let childProgressView = ProgressSpinnerViewController()
        var searchSheetNavController: UINavigationController!
    let notificationCenter = NotificationCenter.default
    let database = Firestore.firestore()
    let storage = Storage.storage()
    
    var pickedTripImage: UIImage?
    
    override func loadView() {
        view = editTripView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let currentTrip {
            editTripView.textFieldName.text = currentTrip.groupName
            editTripView.textFieldLocation.text = currentTrip.location
            
            Task.detached {
                let tripMembers = await UserFirebaseService().getUsers(userIds: currentTrip.memberIds)
                
                if (tripMembers == nil) {
                    showErrorAlert(message: "Unknown error. Please try to revist the page.", controller: self)
                    return
                }
                
                
                await self.groupMembers.replaceSubrange(0..<self.groupMembers.count, with: tripMembers!)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Group"
       
        let confirmButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(confirmNewGroup))
        
        navigationItem.rightBarButtonItems = [confirmButton]
        editTripView.tripImage.menu = getMenuImagePicker()
    }
    
    @objc func confirmNewGroup(){
        let newFoodTripName: String? = editTripView.textFieldName.text
        let newFoodTripLocation: String? = editTripView.textFieldLocation.text
        
        if let newFoodTripLocation, let newFoodTripName, let currentTrip{
            do {
                let newTrip: FoodTrip = FoodTrip(id: currentTrip.id, groupName: newFoodTripName, location: newFoodTripLocation, members: groupMembers, photoURL: currentTrip.photoURL, dateCreated: currentTrip.dateCreated, dateEnded: currentTrip.dateEnded, isTerminated: currentTrip.isTerminated)
                
                try saveFoodTrip(newTrip)
            }
            
        } else {
            showErrorAlert(message: "Unknown error occured. Please try again.", controller: self)
        }
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
}

extension EditTripScreenController: UIPickerViewDelegate, UIPickerViewDataSource, PHPickerViewControllerDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        print(results)
        
        let itemprovider = results.map(\.itemProvider)
        
        for item in itemprovider{
            if item.canLoadObject(ofClass: UIImage.self){
                item.loadObject(ofClass: UIImage.self, completionHandler: { (image, error) in
                    DispatchQueue.main.async{
                        if let uwImage = image as? UIImage{
                            self.editTripView.tripImage.setImage(
                                uwImage.withRenderingMode(.alwaysOriginal),
                                for: .normal
                            )
                            self.pickedTripImage = uwImage
                        }
                    }
                })
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let image = info[.editedImage] as? UIImage{
            self.editTripView.tripImage.setImage(
                image.withRenderingMode(.alwaysOriginal),
                for: .normal
            )
            self.pickedTripImage = image
        }else{
            showAlertText(text: "Failed to take photo", controller: self)
        }
    }
}

extension EditTripScreenController:ProgressSpinnerDelegate{
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
