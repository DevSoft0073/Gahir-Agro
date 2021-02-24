//
//  ProfileVC.swift
//  Gahir Agro
//
//  Created by Apple on 24/02/21.
//

import UIKit
import LGSideMenuController

class ProfileVC: UIViewController {

    @IBOutlet weak var bioTxtView: UITextView!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var addressTxtFld: UITextField!
    @IBOutlet weak var emailtxtFld: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailtxtFld.isUserInteractionEnabled = false
        passwordTxtFld.isUserInteractionEnabled = false
        addressTxtFld.isUserInteractionEnabled = false

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = profileImage.frame.height/2
    }
    
    
    
    @IBAction func gotoEditProfile(_ sender: Any) {
    }
    
    @IBAction func menuButton(_ sender: Any) {
        sideMenuController?.showLeftViewAnimated()
    }
    
}
