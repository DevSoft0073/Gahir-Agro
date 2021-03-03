//
//  SignInVC.swift
//  Gahir Agro
//
//  Created by Apple on 22/02/21.
//

import UIKit

class SignInVC: UIViewController ,UITextFieldDelegate{
    
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var emailView: UIView!
    var messgae = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTxtFld{
            emailView.borderColor = #colorLiteral(red: 0.7788546085, green: 0.0326503776, blue: 0.1003007665, alpha: 1)
            passwordView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }else if textField == passwordTxtFld{
            emailView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            passwordView.borderColor = #colorLiteral(red: 0.7788546085, green: 0.0326503776, blue: 0.1003007665, alpha: 1)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        let vc = AddPhoneNumberVC.instantiate(fromAppStoryboard: .Auth)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    func logIn() {
        PKWrapperClass.svprogressHudShow(title: Constant.shared.appTitle, view: self)
        let url = Constant.shared.baseUrl + Constant.shared.SignIn
        var deviceID = UserDefaults.standard.value(forKey: "deviceToken") as? String
        print(deviceID ?? "")
        if deviceID == nil  {
            deviceID = "777"
        }
        let params = ["username":emailTxtFld.text ?? "","password":passwordTxtFld.text ?? "" , "device_token" : deviceID! ,"device_type" : "iOS"] as? [String : AnyObject] ?? [:]
        print(params)
        PKWrapperClass.requestPOSTWithFormData(url, params: params, imageData: [[:]]) { (response) in
            print(response.data)
            PKWrapperClass.svprogressHudDismiss(view: self)
            let signUpStatus = response.data["app_signup"] as? String ?? ""
            let status = response.data["status"] as? String ?? ""
            self.messgae = response.data["message"] as? String ?? ""
            UserDefaults.standard.setValue(response.data["access_token"] as? String ?? "", forKey: "accessToken")
            if status == "1"{
                if signUpStatus == "0"{
                    let vc = SignUpVC.instantiate(fromAppStoryboard: .Auth)
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    let allData = response.data as? [String:Any] ?? [:]
                    let data = allData["user_detail"] as? [String:Any] ?? [:]
                        UserDefaults.standard.set(1, forKey: "tokenFString")
                        UserDefaults.standard.set(data["id"], forKey: "id")
                        UserDefaults.standard.setValue(data["role"], forKey: "checkRole")
                    let story = UIStoryboard(name: "Main", bundle: nil)
                    let rootViewController:UIViewController = story.instantiateViewController(withIdentifier: "SideMenuControllerID")
                    self.navigationController?.pushViewController(rootViewController, animated: true)
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
    
    
    @IBAction func logInButtonAction(_ sender: Any) {
        
        if (emailTxtFld.text?.isEmpty)!{
            
            ValidateData(strMessage: " Please enter email")
            
        } else if (passwordTxtFld.text?.isEmpty)!{
            
            ValidateData(strMessage: " Please enter password")
            
        }else{
            
            self.logIn()
            
        }
        
    }
    
    @IBAction func forgotPasswordButtonAction(_ sender: Any) {
        let vc = ForgotPasswordVC.instantiate(fromAppStoryboard: .Auth)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
