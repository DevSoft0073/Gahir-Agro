//
//  OTPVerificationForCustomerVC.swift
//  Gahir Agro
//
//  Created by Apple on 12/03/21.
//

import UIKit
import Firebase

class OTPVerificationForCustomerVC: UIViewController,UITextFieldDelegate{
    
    @IBOutlet weak var sixthTF: UITextField!
    @IBOutlet weak var fifthTF: UITextField!
    @IBOutlet weak var fourthTF: UITextField!
    @IBOutlet weak var thirdTF: UITextField!
    @IBOutlet weak var secondTF: UITextField!
    @IBOutlet weak var firstTF: UITextField!
    
    var message = String()
    var phoneNumber = String()
    var otpText = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if #available(iOS 12.0, *) {
            firstTF.textContentType = .oneTimeCode
            secondTF.textContentType = .oneTimeCode
            thirdTF.textContentType = .oneTimeCode
            fourthTF.textContentType = .oneTimeCode
            fifthTF.textContentType = .oneTimeCode
            sixthTF.textContentType = .oneTimeCode
        }
        
        firstTF.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        secondTF.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        thirdTF.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        fourthTF.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        fifthTF.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        sixthTF.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        
        // Do any additional setup after loading the view.
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    @objc func textFieldDidChange(textField: UITextField){
        let text = textField.text
        if  text?.count == 1 {
            switch textField{
            
            case firstTF:
                secondTF.becomeFirstResponder()
                
            case secondTF:
                thirdTF.becomeFirstResponder()
                
            case thirdTF:
                fourthTF.becomeFirstResponder()
                
            case fourthTF:
                fifthTF.becomeFirstResponder()
                
            case fifthTF:
                sixthTF.becomeFirstResponder()
                
            case sixthTF:
                sixthTF.becomeFirstResponder()
                self.dismissKeyboard()
            default:
                break
            }
        }
        if  text?.count == 0 {
            switch textField{
            case firstTF:
                firstTF.becomeFirstResponder()
            case secondTF:
                firstTF.becomeFirstResponder()
            case thirdTF:
                secondTF.becomeFirstResponder()
            case fourthTF:
                thirdTF.becomeFirstResponder()
            case fifthTF:
                fourthTF.becomeFirstResponder()
            case sixthTF:
                fifthTF.becomeFirstResponder()
            default:
                break
            }
        }
        else{
            
        }
    }
    
    func dismissKeyboard(){
        
        self.otpText = "\(self.firstTF.text ?? "")\(self.secondTF.text ?? "")\(self.thirdTF.text ?? "")\(self.fourthTF.text ?? "")\(self.fifthTF.text ?? "")\(self.sixthTF.text ?? "")"
        
        print(self.otpText)
        self.view.endEditing(true)
        
    }
    
    
    func updateNumberApi() {
        
        let signUpWithPhoneUrl = Constant.shared.baseUrl + Constant.shared.CustomerLogin
        PKWrapperClass.svprogressHudShow(title: Constant.shared.appTitle, view: self)
        var deviceID = UserDefaults.standard.value(forKey: "deviceToken") as? String
        print(deviceID ?? "")
        if deviceID == nil  {
            deviceID = "777"
        }
        let parms : [String:Any] = ["phone": phoneNumber,"device_token": deviceID ?? "","device_type":"1"]
        print(parms)
        AFWrapperClass.requestPOSTURL(signUpWithPhoneUrl, params: parms, success: { (response) in
            PKWrapperClass.svprogressHudDismiss(view: self)
            self.message = response["message"] as? String ?? ""
            if let status = response["status"] as? Int{
                if status == 1{
                    UserDefaults.standard.set(true, forKey: "tokenFString")
                    
                    if let dataDict = response as? NSDictionary{
                        print(dataDict)
                        let userId = dataDict["user_id"] as? String
                        print(userId ?? 0)
                        UserDefaults.standard.set(userId, forKey: "userId")
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
                        let newViewController = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                        self.navigationController?.pushViewController(newViewController, animated: true)
                    }
                }else {
                    let vc = SignUpVC.instantiate(fromAppStoryboard: .Auth)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }) { (error) in
            IJProgressView.shared.hideProgressView()
            alert(Constant.shared.appTitle, message: "Data not found", view: self)
            print(error)
        }
        
    }
    
    
    @IBAction func resendOtpButtonAction(_ sender: Any) {
    }
    
    
    @IBAction func varifyButtonAction(_ sender: Any) {
        
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID!,
            verificationCode: otpText)
        
        Auth.auth().signIn(with: credential) { (success, error) in
            if error == nil{
                print(success ?? "")
                //  print(Auth.auth().currentUser?.uid)
                self.updateNumberApi()
            }else{
                alert(Constant.shared.appTitle, message: error?.localizedDescription ?? "", view: self)
                //   print(error?.localizedDescription)
            }
        }
        
        
        //        let story = UIStoryboard(name: "Customer", bundle: nil)
        //        let rootViewController:UIViewController = story.instantiateViewController(withIdentifier: "SideMenuControllerID's")
        //        self.navigationController?.pushViewController(rootViewController, animated: true)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
