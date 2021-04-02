//
//  ChangePasswordVC.swift
//  Gahir Agro
//
//  Created by Apple on 18/03/21.
//

import UIKit

class ChangePasswordVC: UIViewController {

    var messgae = String()
    @IBOutlet weak var confirmPasswordTxtFld: UITextField!
    @IBOutlet weak var newPasswordTxtFld: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func doneButton(_ sender: Any) {
        
        if (newPasswordTxtFld.text!.isEmpty){
            
            ValidateData(strMessage: "Please enter new password")
            
        }else if (newPasswordTxtFld!.text!.count) < 4 || (newPasswordTxtFld!.text!.count) > 15{
            
            ValidateData(strMessage: "Please enter minimum 4 digit password")
        }
        else if(confirmPasswordTxtFld.text!.isEmpty){
            
            ValidateData(strMessage: "Please enter confirm password")
            
        }
        else if newPasswordTxtFld.text != confirmPasswordTxtFld.text{
            
            ValidateData(strMessage: "New password and Confirm password should be same")
            
        }else{
            changePassword()
        }
        
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func changePassword() {
        PKWrapperClass.svprogressHudShow(title: Constant.shared.appTitle, view: self)
        let url = Constant.shared.baseUrl + Constant.shared.ChangePassword
        var deviceID = UserDefaults.standard.value(forKey: "deviceToken") as? String
        let accessToken = UserDefaults.standard.value(forKey: "accessToken")
        print(deviceID ?? "")
        if deviceID == nil  {
            deviceID = "777"
        }
        let params = ["password" : newPasswordTxtFld.text,"access_token": accessToken]  as? [String : AnyObject] ?? [:]
        print(params)
        PKWrapperClass.requestPOSTWithFormData(url, params: params, imageData: []) { (response) in
            print(response.data)
            PKWrapperClass.svprogressHudDismiss(view: self)
            let status = response.data["status"] as? String ?? ""
            self.messgae = response.data["message"] as? String ?? ""
            if status == "1"{
                self.newPasswordTxtFld.resignFirstResponder()
                self.confirmPasswordTxtFld.resignFirstResponder()
                showAlertMessage(title: Constant.shared.appTitle, message: self.messgae, okButton: "Ok", controller: self) {
                    self.navigationController?.popViewController(animated: true)
                }
            }else{
                self.newPasswordTxtFld.resignFirstResponder()
                self.confirmPasswordTxtFld.resignFirstResponder()
                PKWrapperClass.svprogressHudDismiss(view: self)
                alert(Constant.shared.appTitle, message: self.messgae, view: self)
            }
        } failure: { (error) in
            print(error)
            PKWrapperClass.svprogressHudDismiss(view: self)
            showAlertMessage(title: Constant.shared.appTitle, message: error as? String ?? "", okButton: "Ok", controller: self, okHandler: nil)
        }
    }
}
