//
//  SignInWithPhone.swift
//  Gahir Agro
//
//  Created by Apple on 01/03/21.
//

import UIKit
import Firebase

class SignInWithPhone: UIViewController {

    @IBOutlet weak var numberTxtFld: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func getOtp() {
        PhoneAuthProvider.provider().verifyPhoneNumber(numberTxtFld.text ?? "", uiDelegate: nil) { (verificationID, error) in
          if let error = error {
//            self.showMessagePrompt(error.localizedDescription)
            alert(Constant.shared.appTitle, message: error.localizedDescription, view: self)
            return
          }
          // Sign in using the verificationID and the code sent to the user
          // ...
            print(verificationID)
            UserDefaults.standard.setValue(verificationID, forKey: "authVerificationID")
            let vc = OTPVerificationVC.instantiate(fromAppStoryboard: .Auth)
            vc.phoneNumber = self.numberTxtFld.text ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func gernerateOtpButton(_ sender: Any) {
        if numberTxtFld.text?.isEmpty == true{
            ValidateData(strMessage: "Please enter phone number")
            
        }else{
            getOtp()
        }
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
