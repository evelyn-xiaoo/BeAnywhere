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
import TOCropViewController
import AVFoundation
import FirebaseStorage



class RegisterScreenController: UIViewController, PHPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TOCropViewControllerDelegate {
    
    var delegate: RegisterScreenView!
    var pickedImage: UIImage?
    
    let registerView = RegisterScreenView()
    let profileController = ProfileScreenController()
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
            showAlertText(text: "Passwords do not match!")
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
        if registerView.textFieldPassword.text?.isEmpty ?? true || registerView.textFieldVerifyPassword.text?.isEmpty ?? true {
            emptyFields.append("Password")
        }
        
        // If there are any empty fields, show an alert specifying which ones
        if !emptyFields.isEmpty {
            let fieldList = emptyFields.joined(separator: ", ")
            showEmptyAlertText(text: "\(fieldList)")
        } else {
            // All checks passed, proceed with registration
            uploadProfilePhotoToStorage()
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
                self.showErrorAlert(message: "Camera access is required to capture a profile picture.")
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
                self.showErrorAlert(message: "Photo library access is required to select a profile picture.")
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
    
    /*
    
    func presentCropViewController(with image: UIImage) {
        let cropViewController = TOCropViewController(croppingStyle: .circular, image: image)
        cropViewController.delegate = self
        present(cropViewController, animated: true)
    }
    */
    
    func showErrorAlert(message: String){
            let alert = UIAlertController(title: "Error", message: "\(message) Please try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
    }
    
    func showSuccessAlert(message: String){
            let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
    }
    
    func showEmptyAlertText(text:String){
        let alert = UIAlertController(
            title: "Empty input",
            message: "\(text) cannot be empty!",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    func showAlertText(text:String){
        let alert = UIAlertController(
            title: "Error",
            message: "\(text)",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }

}

extension RegisterScreenController: UIPickerViewDelegate, UIPickerViewDataSource{
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
            showAlertText(text: "Failed to take photo")
        }
    }
    
    
    /*
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        // Get the first selected image (since selectionLimit is 1)
        if let result = results.first, result.itemProvider.canLoadObject(ofClass: UIImage.self) {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                DispatchQueue.main.async {
                    if let image = image as? UIImage {
                        // Present TOCropViewController with the selected image
                        self?.presentCropViewController(with: image)
                    } else {
                        self?.showErrorAlert(message: "Failed to load image.")
                    }
                }
            }
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) { // Dismiss the picker before presenting TOCropViewController
            if let image = info[.originalImage] as? UIImage {
                print("Cropping image")
                self.presentCropViewController(with: image)
            } else {
                self.showAlertText(text: "Failed to take photo")
            }
        }
    }


    func cropViewController(_ cropViewController: TOCropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        print("Delegate method for cropping triggered")
        cropViewController.dismiss(animated: true)
        DispatchQueue.main.async {
            print("here")
            self.registerView.profileImage.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
            self.pickedImage = image
        }
    }
     */
    
    func uploadProfilePhotoToStorage(){
        var profilePhotoURL:URL?
        
        //MARK: Upload the profile photo if there is any...
        if let image = pickedImage{
            if let jpegData = image.jpegData(compressionQuality: 80){
                let storageRef = Storage.storage().reference()
                let imagesRepo = storageRef.child("imagesUsers")
                let imageRef = imagesRepo.child("\(NSUUID().uuidString).jpg")
                
                let uploadTask = imageRef.putData(jpegData, completion: {(metadata, error) in
                    if error == nil{
                        imageRef.downloadURL(completion: {(url, error) in
                            if error == nil{
                                profilePhotoURL = url
                                self.registerNewAccount(photoURL: profilePhotoURL)
                            }
                        })
                    }
                })
            }
        }else{
            self.registerNewAccount(photoURL: profilePhotoURL)
        }
    }
    
}
