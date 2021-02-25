//
//  ForgotPasswordVC.swift
//  Gahir Agro
//
//  Created by Apple on 22/02/21.
//

import UIKit

class ForgotPasswordVC: UIViewController , UITextFieldDelegate{

    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailtxtFld: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailtxtFld {
            emailView.borderColor = #colorLiteral(red: 0.7788546085, green: 0.0326503776, blue: 0.1003007665, alpha: 1)
        }
    }
    
    

    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
   
}
