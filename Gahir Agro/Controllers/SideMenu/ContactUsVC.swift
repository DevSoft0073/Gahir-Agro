//
//  ContactUsVC.swift
//  Gahir Agro
//
//  Created by Apple on 24/02/21.
//

import UIKit
import LGSideMenuController

class ContactUsVC: UIViewController ,UITextFieldDelegate , UITextViewDelegate{

    @IBOutlet weak var messageTxtView: UITextView!
    @IBOutlet weak var messageVIew: UIView!
    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var nameTxtFld: UITextField!
    @IBOutlet weak var nameView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == nameTxtFld {
            nameView.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            emailView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            messageVIew.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            
            
        } else if textField == emailTxtFld{
            nameView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            emailView.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            messageVIew.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == messageTxtView{
            emailView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            emailView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            messageVIew.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        }
    }
    
    
    
    @IBAction func backButton(_ sender: Any) {
        sideMenuController?.showLeftViewAnimated()

    }
    
    @IBAction func submitButton(_ sender: Any) {
    }
}
