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
    var messgae = String()
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
    
    
    func contactUs() {
        PKWrapperClass.svprogressHudShow(title: Constant.shared.appTitle, view: self)
        let url = Constant.shared.baseUrl + Constant.shared.contactUS
        var deviceID = UserDefaults.standard.value(forKey: "deviceToken") as? String
        let accessToken = UserDefaults.standard.value(forKey: "accessToken")
        print(deviceID ?? "")
        if deviceID == nil  {
            deviceID = "777"
        }
        let params = ["name" : nameTxtFld.text ?? "" , "email" : emailTxtFld.text ?? "", "message" : messageTxtView.text ?? "" ,"access_token": accessToken]  as? [String : AnyObject] ?? [:]
        print(params)
        PKWrapperClass.requestPOSTWithFormData(url, params: params, imageData: [[:]]) { (response) in
            print(response.data)
            PKWrapperClass.svprogressHudDismiss(view: self)
            let status = response.data["status"] as? String ?? ""
            self.messgae = response.data["message"] as? String ?? ""
            if status == "1"{
                showAlertMessage(title: Constant.shared.appTitle, message: self.messgae, okButton: "Ok", controller: self) {
                }
            }else{
                PKWrapperClass.svprogressHudDismiss(view: self)
                alert(Constant.shared.appTitle, message: self.messgae, view: self)
            }
        } failure: { (error) in
            print(error)
            showAlertMessage(title: Constant.shared.appTitle, message: error as? String ?? "", okButton: "Ok", controller: self, okHandler: nil)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func backButton(_ sender: Any) {
        sideMenuController?.showLeftViewAnimated()
        
    }
    
    @IBAction func submitButton(_ sender: Any) {
        
        if nameTxtFld.text?.isEmpty == true{
            ValidateData(strMessage: "Please enter name")
        }else if emailTxtFld.text?.isEmpty == true{
            ValidateData(strMessage: "Please enter email")
        }else{
            contactUs()
        }
    }
}
