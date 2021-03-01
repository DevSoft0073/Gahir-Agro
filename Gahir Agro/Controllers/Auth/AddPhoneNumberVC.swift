//
//  AddPhoneNumberVC.swift
//  Gahir Agro
//
//  Created by Apple on 23/02/21.
//

import UIKit
import Firebase

class AddPhoneNumberVC: UIViewController,UITextFieldDelegate{

    var picker  = UIPickerView()
    var pickerToolBar = UIToolbar()
    var selectedValue = String()
    var listingArray = ["Dealer","Customer","Executive Customer"]
    @IBOutlet weak var dealerTxtFld: UITextField!
    @IBOutlet weak var mobileTxtFld: UITextField!
    @IBOutlet weak var mobileNumberView: UIView!
    @IBOutlet weak var selectTypeView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        dealerTxtFld.isUserInteractionEnabled = false
//        dealerTxtFld.text = UserDefaults.standard.value(forKey: "data") as? String ?? ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @IBAction func generateOtpButton(_ sender: Any) {
        if mobileTxtFld.text?.isEmpty == true{
            ValidateData(strMessage: "Please enter phone number")
        }else if dealerTxtFld.text?.isEmpty == true{
            ValidateData(strMessage: "Please select role for your account")
        }else{
            getOtp()
            let vc = OTPVerificationVC.instantiate(fromAppStoryboard: .Auth)
            UserDefaults.standard.set("2", forKey: "comesFromPhoneLogin")
            vc.phoneNumber = mobileTxtFld.text ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    func getOtp() {
        PhoneAuthProvider.provider().verifyPhoneNumber(mobileTxtFld.text ?? "", uiDelegate: nil) { (verificationID, error) in
          if let error = error {
//            self.showMessagePrompt(error.localizedDescription)
            alert(Constant.shared.appTitle, message: error.localizedDescription, view: self)
            return
          }
          // Sign in using the verificationID and the code sent to the user
          // ...
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func openPicker(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopUpVC") as! PopUpVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegates = self
        self.present(vc, animated: true, completion: nil)
    }
    
}

//MARK:- Get data from popup view

extension AddPhoneNumberVC : PopViewControllerDelegate {
    func dismissPopUP(sendData: String) {
        self.dealerTxtFld.text = sendData
    }
}
