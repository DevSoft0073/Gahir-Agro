//
//  LogInVC.swift
//  Gahir Agro
//
//  Created by Apple on 16/03/21.
//

import UIKit

class LogInVC: UIViewController {
    
    var messgae = String()
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var emailView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func logIn() {
        PKWrapperClass.svprogressHudShow(title: Constant.shared.appTitle, view: self)
        let url = Constant.shared.baseUrl + Constant.shared.AdminSignIn
        var deviceID = UserDefaults.standard.value(forKey: "deviceToken") as? String
        print(deviceID ?? "")
        if deviceID == nil  {
            deviceID = "777"
        }
        let params = ["username":emailTxtFld.text ?? "","password":passwordTxtFld.text ?? "" , "device_token" : deviceID! ,"device_type" : "iOS"] as? [String : AnyObject] ?? [:]
        print(params)
        PKWrapperClass.requestPOSTWithFormData(url, params: params, imageData: []) { (response) in
            print(response.data)
            PKWrapperClass.svprogressHudDismiss(view: self)
            let signUpStatus = response.data["app_signup"] as? String ?? ""
            let status = response.data["status"] as? String ?? ""
            self.messgae = response.data["message"] as? String ?? ""
            UserDefaults.standard.setValue(response.data["access_token"] as? String ?? "", forKey: "accessToken")
            if status == "1"{
                self.emailTxtFld.resignFirstResponder()
                self.passwordTxtFld.resignFirstResponder()
                if signUpStatus == "0"{
                    self.emailTxtFld.resignFirstResponder()
                    self.passwordTxtFld.resignFirstResponder()
                    let vc = SignUpVC.instantiate(fromAppStoryboard: .Auth)
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    self.emailTxtFld.resignFirstResponder()
                    self.passwordTxtFld.resignFirstResponder()
                    let allData = response.data as? [String:Any] ?? [:]
                    let data = allData["user_detail"] as? [String:Any] ?? [:]
                    UserDefaults.standard.set(1, forKey: "tokenFString")
                    UserDefaults.standard.set(data["id"], forKey: "id")
                    UserDefaults.standard.setValue(data["role"], forKey: "checkRole")
                    DispatchQueue.main.async {
                        let story = UIStoryboard(name: "AdminMain", bundle: nil)
                        let rootViewController:UIViewController = story.instantiateViewController(withIdentifier: "AdminSideMenuControllerID")
                        self.navigationController?.pushViewController(rootViewController, animated: true)
                    }
                }
                self.emailTxtFld.resignFirstResponder()
                self.passwordTxtFld.resignFirstResponder()
            }else if status == "0"{
                self.emailTxtFld.resignFirstResponder()
                self.passwordTxtFld.resignFirstResponder()
                PKWrapperClass.svprogressHudDismiss(view: self)
                alert(Constant.shared.appTitle, message: self.messgae, view: self)
            } else if status == "100"{
                self.emailTxtFld.resignFirstResponder()
                self.passwordTxtFld.resignFirstResponder()
                showAlertMessage(title: Constant.shared.appTitle, message: self.messgae, okButton: "Ok", controller: self) {
                    UserDefaults.standard.removeObject(forKey: "tokenFString")
                    let appDel = UIApplication.shared.delegate as! AppDelegate
                    appDel.Logout1()
                }
            }
        } failure: { (error) in
            print(error)
            PKWrapperClass.svprogressHudDismiss(view: self)
            showAlertMessage(title: Constant.shared.appTitle, message: error as? String ?? "", okButton: "Ok", controller: self, okHandler: nil)
        }
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        
    }
    
    @IBAction func logInButtonAction(_ sender: Any) {
        if (emailTxtFld.text?.isEmpty)!{
            
            ValidateData(strMessage: " Please enter email")
            
        } else if isValidEmail(testStr: (emailTxtFld.text)!) == false{

            ValidateData(strMessage: "Enter valid email")
            
        }else if (passwordTxtFld.text?.isEmpty)!{
            
            ValidateData(strMessage: " Please enter password")
            
        }else if (passwordTxtFld!.text!.count) < 4 || (passwordTxtFld!.text!.count) > 15{
            

            ValidateData(strMessage: "Please enter minimum 4 digit password")
            UserDefaults.standard.string(forKey: "password")

        }else{
            
            self.logIn()
            
        }
    }
    
    @IBAction func forgotPasswordButton(_ sender: Any) {
    }    
}
