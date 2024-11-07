//
//  ProfileEditViewController.swift
//  BeAnywhere
//
//  Created by Evelyn Xiao on 11/6/24.
//

import UIKit

class ProfileEditViewController: UIViewController {
    var editView = ProfileEditView()
    
    override func loadView() {
        view = editView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
