//
//  AlertDialog.swift
//  BeAnywhere
//
//  Created by Jimin Kim on 11/6/24.
//

import Foundation
import UIKit

func showErrorAlert(message: String, controller: UIViewController){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
    controller.present(alert, animated: true)
}

func showSuccessAlert(message: String, controller: UIViewController){
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        controller.present(alert, animated: true)
}

func showEmptyAlertText(text:String, controller: UIViewController){
    let alert = UIAlertController(
        title: "Empty input",
        message: "\(text) cannot be empty!",
        preferredStyle: .alert
    )
    
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    controller.present(alert, animated: true)
}

func showAlertText(text:String, controller: UIViewController){
    let alert = UIAlertController(
        title: "Error",
        message: "\(text)",
        preferredStyle: .alert
    )
    
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    controller.present(alert, animated: true)
}

