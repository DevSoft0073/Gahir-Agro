//
//  SignUpVC.swift
//  Gahir Agro
//
//  Created by Apple on 22/02/21.
//

import UIKit

class SignUpVC: UIViewController ,UITextFieldDelegate{
    
    @IBOutlet weak var selectUnselectImage: UIImageView!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var nameTxtFld: UITextField!
    @IBOutlet weak var nameView: UIView!
    var unchecked = Bool()
    var messgae = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == nameTxtFld{
            
            nameView.borderColor = #colorLiteral(red: 0.7788546085, green: 0.0326503776, blue: 0.1003007665, alpha: 1)
            emailView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            passwordView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            
        }else if textField == emailTxtFld{
            
            nameView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            emailView.borderColor = #colorLiteral(red: 0.7788546085, green: 0.0326503776, blue: 0.1003007665, alpha: 1)
            passwordView.borderColor = #colorLiteral(red: 0.7788546085, green: 0.0326503776, blue: 0.1003007665, alpha: 1)
            
        }else if textField == passwordTxtFld{
            nameView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            emailView.borderColor = #colorLiteral(red: 0.7788546085, green: 0.0326503776, blue: 0.1003007665, alpha: 1)
            passwordView.borderColor = #colorLiteral(red: 0.7788546085, green: 0.0326503776, blue: 0.1003007665, alpha: 1)
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func checkUncheckButton(_ sender: Any) {
        if (unchecked == false)
        {
            checkButton.setBackgroundImage(UIImage(named: "check"), for: UIControl.State.normal)
            unchecked = true
        }
        else
        {
            checkButton.setBackgroundImage(UIImage(named: "uncheck"), for: UIControl.State.normal)
            unchecked = false
        }
    }
    
    @IBAction func openLink(_ sender: Any) {
        guard let url = URL(string: "https://stackoverflow.com") else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        
        if (emailTxtFld.text?.isEmpty)!{
            
            ValidateData(strMessage: " Please enter email")
            
        } else if (passwordTxtFld.text?.isEmpty)!{
            
            ValidateData(strMessage: " Please enter password")
            
        }else{
            
            self.signUp()
            
        }
        
    }
    
    
    func signUp()  {
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            PKWrapperClass.svprogressHudShow(title: Constant.shared.appTitle, view: self)
            let url = Constant.shared.baseUrl + Constant.shared.SignUp
            var deviceID = UserDefaults.standard.value(forKey: "deviceToken") as? String
            print(deviceID ?? "")
            if deviceID == nil  {
                deviceID = "777"
            }
            
            let params = ["username":nameTxtFld.text ?? "","first_name" : emailTxtFld.text ?? "","password":passwordTxtFld.text ?? "" , "device_token" : deviceID! ,"device_type" : "IOS"] as [String : Any]
            print(params)
            
            AFWrapperClass.requestPOSTURL(url, params: params, success: { (response) in
                PKWrapperClass.svprogressHudDismiss(view: self)
                let signUpStatus = response["app_signup"] as? String ?? ""
                if signUpStatus == "1"{
                    self.messgae = response["message"] as? String ?? ""
                    let status = response["status"] as? Int
                    if status == 1{
                        let allData = response as? [String:Any] ?? [:]
                        if let data = allData["data"] as? [String:Any]  {
                            UserDefaults.standard.set(1, forKey: "tokenFString")
                            UserDefaults.standard.set(data["user_id"], forKey: "id")
                            UserDefaults.standard.setValue(data["role"], forKey: "checkRole")
                        }
                        let story = UIStoryboard(name: "Main", bundle: nil)
                        let rootViewController:UIViewController = story.instantiateViewController(withIdentifier: "SideMenuControllerID")
                        self.navigationController?.pushViewController(rootViewController, animated: true)
                    }else{
                        IJProgressView.shared.hideProgressView()
                        alert(Constant.shared.appTitle, message: self.messgae, view: self)
                    }
                }else{
                    let vc = SignUpVC.instantiate(fromAppStoryboard: .Auth)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            }) { (error) in
                IJProgressView.shared.hideProgressView()
                alert(Constant.shared.appTitle, message: error.localizedDescription, view: self)
                print(error)
            }
            
        } else {
            print("Internet connection FAILED")
            alert(Constant.shared.appTitle, message: "Check internet connection", view: self)
        }
    }
    
    
    
    @IBAction func gotoSignInBUtton(_ sender: Any) {
        let vc = SignInVC.instantiate(fromAppStoryboard: .Auth)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
