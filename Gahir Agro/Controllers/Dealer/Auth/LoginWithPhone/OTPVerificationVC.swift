//
//  OTPVerificationVC.swift
//  Gahir Agro
//
//  Created by Apple on 23/02/21.
//

import UIKit
import Firebase
import OTPFieldView

enum DisplayType: Int {
    case circular
    case roundedCorner
    case square
    case diamond
    case underlinedBottom
}

class OTPVerificationVC: UIViewController  ,UITextFieldDelegate{
    
    @IBOutlet weak var otpView: OTPFieldView!
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
        //        getOtp()
        numberButton.setTitle(phoneNumber, for: .normal)
        setupOtpView()
//        if #available(iOS 12.0, *) {
//            textOne.textContentType = .oneTimeCode
//            textTwo.textContentType = .oneTimeCode
//            textTheww.textContentType = .oneTimeCode
//            textFour.textContentType = .oneTimeCode
//            textFifth.textContentType = .oneTimeCode
//            textSixth.textContentType = .oneTimeCode
//        }
//
//        textOne.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
//        textTwo.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
//        textTheww.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
//        textFour.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
//        textFifth.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
//        textSixth.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
//
//        self.view.resignFirstResponder()
    }
    
    func setupOtpView(){
        self.otpView.fieldsCount = 6
        self.otpView.fieldBorderWidth = 2
        self.otpView.defaultBorderColor = UIColor.black
        self.otpView.filledBorderColor = UIColor.black
        self.otpView.cursorColor = UIColor.red
        self.otpView.displayType = .underlinedBottom
        self.otpView.fieldSize = 40
        self.otpView.separatorSpace = 8
        self.otpView.shouldAllowIntermediateEditing = false
        self.otpView.delegate = self
        self.otpView.initializeUI()
        self.otpView.resignFirstResponder()
    }
    
    //    MARK:- Get Otp
    
    func getOtp() {
        PhoneAuthProvider.provider().verifyPhoneNumber(self.phoneNumber, uiDelegate: nil) { (verificationID, error) in
            PKWrapperClass.svprogressHudShow(title: Constant.shared.appTitle, view: self)
            if let error = error {
                PKWrapperClass.svprogressHudDismiss(view: self)
                print(error.localizedDescription)
                if error.localizedDescription == "Invalid format."{
                    alert(Constant.shared.appTitle, message: "Please enter valid phone number.", view: self)
                }else{
                    alert(Constant.shared.appTitle, message: "Please enter valid phone number.", view: self)
                }
            }else{
                PKWrapperClass.svprogressHudDismiss(view: self)
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            }
            PKWrapperClass.svprogressHudDismiss(view: self)
        }
        PKWrapperClass.svprogressHudDismiss(view: self)
    }
    
    //    MARK:- Text Field delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.count > 0 {
            textField.text = (string as NSString).substring(to: 1)
            if textField == textOne {
                textTwo.becomeFirstResponder()
            } else if textField == textTwo {
                textTheww.becomeFirstResponder()
            }else if textField == textTheww {
                textFour.becomeFirstResponder()
            }else if textField == textFour {
                textFifth.becomeFirstResponder()
            }else if textField == textFifth {
                textSixth.becomeFirstResponder()
            }else if textField == textSixth {
                dismissKeyboard()
            }
        }
        return true
    }
    
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
        
        self.otpText = "\(self.textOne.text ?? "")\(self.textTwo.text ?? "")\(self.textTheww.text ?? "")\(self.textFour.text ?? "")\(self.textFifth.text ?? "")\(self.textSixth.text ?? "")"
        
        print(self.otpText)
        self.view.endEditing(true)
        
    }
    
    //    MARK:- Button Action
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func verifyButton(_ sender: Any) {
        let comesFrom = UserDefaults.standard.value(forKey: "comesFromPhoneLogin") as? Bool
        if comesFrom == false{
            
            let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
            let credential = PhoneAuthProvider.provider().credential(
                withVerificationID: verificationID!,
                verificationCode: otpText)
            
            Auth.auth().signIn(with: credential) { (success, error) in
                if error == nil{
                    print(success ?? "")
                    let vc = SignUpVC.instantiate(fromAppStoryboard: .Auth)
                    vc.phoneNumber = self.phoneNumber
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    alert(Constant.shared.appTitle, message: "Invalid OTP please enter again", view: self)
                }
            }
        }else{
            let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
            let credential = PhoneAuthProvider.provider().credential(
                withVerificationID: verificationID!,
                verificationCode: otpText)
            
            Auth.auth().signIn(with: credential) { (success, error) in
                if error == nil{
                    print(success ?? "")
                    self.phoneLogin()
                }else{
                    alert(Constant.shared.appTitle, message: "Invalid OTP please enter again", view: self)
                }
            }
        }
    }
    
    //    MARK:- Resend Otp
    
    @IBAction func resendOtpButtonAction(_ sender: Any) {
        textOne.text = ""
        textTwo.text = ""
        textTheww.text = ""
        textFour.text = ""
        textFifth.text = ""
        textSixth.text = ""
        getOtp()
    }
    
    
    //    MARK:- Service Call Function
    
    func phoneLogin() {
        PKWrapperClass.svprogressHudShow(title: Constant.shared.appTitle, view: self)
        let url = Constant.shared.baseUrl + Constant.shared.PhoneLogin
        var deviceID = UserDefaults.standard.value(forKey: "deviceToken") as? String
        print(deviceID ?? "")
        if deviceID == nil  {
            deviceID = "777"
        }
        let params = ["phone": phoneNumber,"device_token": deviceID ?? "","device_type":"iOS"] as? [String : AnyObject] ?? [:]
        print(params)
        PKWrapperClass.requestPOSTWithFormData(url, params: params, imageData: []) { (response) in
            print(response.data)
            PKWrapperClass.svprogressHudDismiss(view: self)
            let status = response.data["status"] as? String ?? ""
            self.message = response.data["message"] as? String ?? ""
            UserDefaults.standard.setValue(response.data["access_token"] as? String ?? "", forKey: "accessToken")
            if status == "1"{
                UserDefaults.standard.set(true, forKey: "tokenFString")
                let allData = response.data as? [String:Any] ?? [:]
                let data = allData["user_detail"] as? [String:Any] ?? [:]
                print(data)
                UserDefaults.standard.set(data["dealer_code"] as? String ?? "", forKey: "code")
                UserDefaults.standard.set(1, forKey: "tokenFString")
                UserDefaults.standard.set(data["id"], forKey: "id")
                UserDefaults.standard.setValue(data["role"], forKey: "checkRole")
                UserDefaults.standard.setValue(data["serial_no"], forKey: "serialNumber")
                
                if data["role"] as? String ?? "" == "admin"{
                    DispatchQueue.main.async {
                        let story = UIStoryboard(name: "AdminMain", bundle: nil)
                        let rootViewController:UIViewController = story.instantiateViewController(withIdentifier: "AdminSideMenuControllerID")
                        self.navigationController?.pushViewController(rootViewController, animated: true)
                    }
                }else if data["role"] as? String ?? "" == "Sales"{
                    
                    DispatchQueue.main.async {
                        let story = UIStoryboard(name: "AdminMain", bundle: nil)
                        let rootViewController:UIViewController = story.instantiateViewController(withIdentifier: "AdminSideMenuControllerID")
                        self.navigationController?.pushViewController(rootViewController, animated: true)
                    }
                    
                }else if data["role"] as? String ?? "" == "Customer"{
                    DispatchQueue.main.async {
                        let story = UIStoryboard(name: "Main", bundle: nil)
                        let rootViewController:UIViewController = story.instantiateViewController(withIdentifier: "SideMenuControllerID")
                        self.navigationController?.pushViewController(rootViewController, animated: true)
                    }
                    
                }else if data["role"] as? String ?? "" == "Dealer"{
                    DispatchQueue.main.async {
                        let story = UIStoryboard(name: "Main", bundle: nil)
                        let rootViewController:UIViewController = story.instantiateViewController(withIdentifier: "SideMenuControllerID")
                        self.navigationController?.pushViewController(rootViewController, animated: true)
                    }
                }
            }else {
                alert(Constant.shared.appTitle, message: self.message, view: self)
            }
        } failure: { (error) in
            print(error)
            PKWrapperClass.svprogressHudDismiss(view: self)
            showAlertMessage(title: Constant.shared.appTitle, message: error as? String ?? "", okButton: "Ok", controller: self, okHandler: nil)
        }
    }
}

extension OTPVerificationVC: OTPFieldViewDelegate {
    func hasEnteredAllOTP(hasEnteredAll hasEntered: Bool) -> Bool {
        print("Has entered all OTP? \(hasEntered)")
        return false
    }
    
    func enteredOTP(otp otpString: String) {
        print("OTPString: \(otpString)")
        self.otpText = otpString
    }
}
