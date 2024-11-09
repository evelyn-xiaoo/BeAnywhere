//
//  RegisterScreenController.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 10/25/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import PhotosUI
import AVFoundation
import FirebaseStorage

class RegisterScreenController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var delegate: RegisterScreenView!
    var pickedImage: UIImage?
    var loginDelegate: LoginScreenController!
    
    let registerView = RegisterScreenView()
    
    let childProgressView = ProgressSpinnerViewController()
    
    let database = Firestore.firestore()
    let storage = Storage.storage()
        override func loadView() {
            view = registerView
        }
        override func viewDidLoad() {
            super.viewDidLoad()
            navigationController?.navigationBar.prefersLargeTitles = true
            registerView.buttonRegister.addTarget(self, action: #selector(onRegisterTapped), for: .touchUpInside)
            
            registerView.profileImage.menu = getMenuImagePicker()
            
        }
        
        @objc func onRegisterTapped(){
            //MARK: creating a new user on Firebase...
            
            guard registerView.textFieldPassword.text == registerView.textFieldVerifyPassword.text else {
                showAlertText(text: "Passwords do not match!", controller: self)
                    return
                }
                
            // Array to keep track of any empty fields
            var emptyFields: [String] = []
            
            // Check each field and add to the emptyFields array if empty
            if registerView.textFieldName.text?.isEmpty ?? true {
                emptyFields.append("Name")
            }
            if registerView.textFieldEmail.text?.isEmpty ?? true {
                emptyFields.append("Email")
            }
            if registerView.textFieldUsername.text?.isEmpty ?? true {
                emptyFields.append("Username")
            }
            if registerView.textFieldPassword.text?.isEmpty ?? true {
                emptyFields.append("Password")
            }
            
            // If there are any empty fields, show an alert specifying which ones
            if !emptyFields.isEmpty {
                let fieldList = emptyFields.joined(separator: ", ")
                showEmptyAlertText(text: "\(fieldList)", controller: self)
            } else {
                // All checks passed, proceed with registration
                registerNewAccount()
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

extension RegisterScreenController: UIPickerViewDelegate, UIPickerViewDataSource, PHPickerViewControllerDelegate{
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
                            self.registerView.profileImage.setImage(
                                uwImage.withRenderingMode(.alwaysOriginal),
                                for: .normal
                            )
                            self.pickedImage = uwImage
                        }
                    }
                })
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let image = info[.editedImage] as? UIImage{
            self.registerView.profileImage.setImage(
                image.withRenderingMode(.alwaysOriginal),
                for: .normal
            )
            self.pickedImage = image
        }else{
            showAlertText(text: "Failed to take photo", controller: self)
        }
    }
}


extension RegisterScreenController:ProgressSpinnerDelegate{
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
