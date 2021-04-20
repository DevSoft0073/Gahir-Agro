//
//  ForgotPasswordVC.swift
//  Gahir Agro
//
//  Created by Apple on 22/02/21.
//

import UIKit

class ForgotPasswordVC: UIViewController,UITextFieldDelegate{

    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailtxtFld: UITextField!
    var messgae = String()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func forgotPassword() {
        PKWrapperClass.svprogressHudShow(title: Constant.shared.appTitle, view: self)
        let url = Constant.shared.baseUrl + Constant.shared.ForgotPassword
        let accessToken = UserDefaults.standard.value(forKey: "accessToken")
        var deviceID = UserDefaults.standard.value(forKey: "deviceToken") as? String
        print(deviceID ?? "")
        if deviceID == nil  {
            deviceID = "777"
        }
        let params = ["email":emailtxtFld.text as? String ?? ""] as? [String : AnyObject] ?? [:]
        print(params)
        PKWrapperClass.requestPOSTWithFormData(url, params: params, imageData: []) { (response) in
            print(response.data)
           // self.view.resignFirstResponder()
            PKWrapperClass.svprogressHudDismiss(view: self)
            let status = response.data["status"] as? String ?? ""
            self.messgae = response.data["message"] as? String ?? ""
            if status == "1"{
                self.emailtxtFld.resignFirstResponder()
                showAlertMessage(title: Constant.shared.appTitle, message: self.messgae, okButton: "Ok", controller: self) {
                    self.navigationController?.popViewController(animated: true)
                }
            }else{
                self.emailtxtFld.resignFirstResponder()
                PKWrapperClass.svprogressHudDismiss(view: self)
                alert(Constant.shared.appTitle, message: self.messgae, view: self)
            }
        } failure: { (error) in
            print(error)
            PKWrapperClass.svprogressHudDismiss(view: self)
            showAlertMessage(title: Constant.shared.appTitle, message: error as? String ?? "", okButton: "Ok", controller: self, okHandler: nil)
        }
    }
    
//    MARK:- Text field delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailtxtFld.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailtxtFld {
            emailView.borderColor = #colorLiteral(red: 0.7788546085, green: 0.0326503776, blue: 0.1003007665, alpha: 1)
            emailtxtFld.placeholder = ""
        }
    }
    
//    MARK:- Button Action
    
    @IBAction func submitButton(_ sender: Any) {
        if (emailtxtFld.text?.isEmpty)!{
            
            ValidateData(strMessage: "Please enter email")
        }
        else if isValidEmail(testStr: (emailtxtFld.text)!) == false{
            
            ValidateData(strMessage: "Enter valid email")
            
        }else{
            forgotPassword()
        }
    }
    

    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
   
}
