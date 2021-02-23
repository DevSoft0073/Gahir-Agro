//
//  AddPhoneNumberVC.swift
//  Gahir Agro
//
//  Created by Apple on 23/02/21.
//

import UIKit

class AddPhoneNumberVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var dealerTxtFld: UITextField!
    @IBOutlet weak var mobileTxtFld: UITextField!
    @IBOutlet weak var openPickerOnbutton: UIButton!
    @IBOutlet weak var mobileNumberView: UIView!
    @IBOutlet weak var selectTypeView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func generateOtpButton(_ sender: Any) {
    }
    
}
