//
//  OTPVerificationVC.swift
//  Gahir Agro
//
//  Created by Apple on 23/02/21.
//

import UIKit
import Firebase

class OTPVerificationVC: UIViewController  ,UITextFieldDelegate{
    
    @IBOutlet weak var numberButton: UIButton!
    @IBOutlet weak var textSixth: UITextField!
    @IBOutlet weak var textFifth: UITextField!
    @IBOutlet weak var textFour: UITextField!
    @IBOutlet weak var textTheww: UITextField!
    @IBOutlet weak var textTwo: UITextField!
    @IBOutlet weak var textOne: UITextField!
    var phoneNumber = String()
    var otpText = String()
    var message = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberButton.setTitle(phoneNumber, for: .normal)
        
        if #available(iOS 12.0, *) {
            textOne.textContentType = .oneTimeCode
            textTwo.textContentType = .oneTimeCode
            textTheww.textContentType = .oneTimeCode
            textFour.textContentType = .oneTimeCode
            textFifth.textContentType = .oneTimeCode
            textSixth.textContentType = .oneTimeCode
        }
        
        textOne.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        textTwo.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        textTheww.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        textFour.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        textFifth.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        textSixth.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        //        textOne.becomeFirstResponder()
        
        self.view.resignFirstResponder()
        // Do any additional setup after loading the view.
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    //When changed value in textField
    @objc func textFieldDidChange(textField: UITextField){
        let text = textField.text
        if  text?.count == 1 {
            switch textField{
            
            case textOne:
                textTwo.becomeFirstResponder()
                
            case textTwo:
                textTheww.becomeFirstResponder()
                
            case textTheww:
                textFour.becomeFirstResponder()
                
            case textFour:
                textFifth.becomeFirstResponder()
                
            case textFifth:
                textSixth.becomeFirstResponder()
                
            case textSixth:
                textSixth.becomeFirstResponder()
                self.dismissKeyboard()
            default:
                break
            }
        }
        if  text?.count == 0 {
            switch textField{
            case textOne:
                textOne.becomeFirstResponder()
            case textTwo:
                textOne.becomeFirstResponder()
            case textTheww:
                textTwo.becomeFirstResponder()
            case textFour:
                textTheww.becomeFirstResponder()
            case textFifth:
                textFour.becomeFirstResponder()
            case textSixth:
                textFifth.becomeFirstResponder()
            default:
                break
            }
        }
        else{
            
        }
    }
    
    func dismissKeyboard(){
        
        self.otpText = "\(self.textOne.text ?? "")\(self.textTwo.text ?? "")\(self.textTheww.text ?? "")\(self.textFour.text ?? "")"
        
        print(self.otpText)
        self.view.endEditing(true)
        
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func verifyButton(_ sender: Any) {
        
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
        
    }
    
    func updateNumberApi() {
        
        
        let signUpWithPhoneUrl = Constant.shared.baseUrl + Constant.shared.PhoneLogin
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
    
}
