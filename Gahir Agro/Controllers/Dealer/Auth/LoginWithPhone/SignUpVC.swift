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
    var phoneNumber = String()
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
            passwordView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            
        }else if textField == passwordTxtFld{
            nameView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            emailView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
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
        
        
        if (nameTxtFld.text?.isEmpty)!{
            
            ValidateData(strMessage: " Please enter name")
            
        } else if (emailTxtFld.text?.isEmpty)!{
            
            ValidateData(strMessage: " Please enter email")
            
        } else if (passwordTxtFld.text?.isEmpty)!{
            
            ValidateData(strMessage: " Please enter password")
            
        }  else if unchecked == false{
            
            ValidateData(strMessage: "Please agree with terms and conditions")
            
        } else {
            
            self.signUp()
            
        }
    }
    
    func signUp()  {
        
        PKWrapperClass.svprogressHudShow(title: Constant.shared.appTitle, view: self)
        var SignUpUrl = String()
        var params = [String : AnyObject]()
        var deviceID = UserDefaults.standard.value(forKey: "deviceToken") as? String
        let dealerCode = UserDefaults.standard.value(forKey: "dealerCode")
        print(deviceID ?? "")
        if deviceID == nil  {
            deviceID = "777"
        }
        
        let roleVal = UserDefaults.standard.value(forKey: "getRole") as? String ?? ""
        if roleVal == "Dealer Code" {
            SignUpUrl = Constant.shared.baseUrl + Constant.shared.SignUp
            
            params = ["username":emailTxtFld.text ?? "", "first_name" : nameTxtFld.text ?? "", "password":passwordTxtFld.text ?? "" , "device_token" : deviceID! ,"device_type" : "iOS","dealer_code" : dealerCode , "phone" : self.phoneNumber] as? [String : AnyObject] ?? [:]
        }else{
            SignUpUrl = Constant.shared.baseUrl + Constant.shared.CustomerNewSignUp            
            
            params = ["username":emailTxtFld.text ?? "", "first_name" : nameTxtFld.text ?? "", "password":passwordTxtFld.text ?? "" , "device_token" : deviceID! ,"device_type" : "iOS","serial_no" : dealerCode , "phone" : self.phoneNumber] as? [String : AnyObject] ?? [:]
        }
        print(params)
        PKWrapperClass.requestPOSTWithFormData(SignUpUrl, params: params, imageData: []) { (response) in
            print(response.data)
            PKWrapperClass.svprogressHudDismiss(view: self)
            let signUpStatus = response.data["app_signup"] as? Int ?? 0
            let status = response.data["status"] as? String ?? ""
            self.messgae = response.data["message"] as? String ?? ""
            UserDefaults.standard.setValue(response.data["access_token"] as? String ?? "", forKey: "accessToken")
            if status == "1"{
                if signUpStatus == 0{
                    let vc = SignUpVC.instantiate(fromAppStoryboard: .Auth)
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    UserDefaults.standard.set(true, forKey: "tokenFString")
                    let allData = response.data as? [String:Any] ?? [:]
                    let data = allData["user_detail"] as? [String:Any] ?? [:]
                    UserDefaults.standard.set(1, forKey: "tokenFString")
                    UserDefaults.standard.set(data["id"], forKey: "id")
                    UserDefaults.standard.setValue(data["role"], forKey: "checkRole")
                    UserDefaults.standard.setValue(data["serial_no"], forKey: "serialNumber")
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
    
    
    
    @IBAction func gotoSignInBUtton(_ sender: Any) {
        let vc = SignInVC.instantiate(fromAppStoryboard: .Auth)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
