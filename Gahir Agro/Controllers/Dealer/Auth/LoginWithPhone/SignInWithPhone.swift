//
//  SignInWithPhone.swift
//  Gahir Agro
//
//  Created by Apple on 01/03/21.
//

import UIKit
import Firebase
import SKCountryPicker
import FirebaseAuth
import FirebaseCore

class SignInWithPhone: UIViewController ,UITextFieldDelegate{
    
    var message = String()
    @IBOutlet weak var countryCode: UIButton!
    @IBOutlet weak var numberTxtFld: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.countryCode.contentHorizontalAlignment = .center
        guard let country = CountryManager.shared.currentCountry else {
            return
        }
        countryCode.setTitle(country.countryCode, for: .highlighted)
        countryCode.clipsToBounds = true
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == numberTxtFld{
        }
    }
    
    //    MARK:- Country Picker
    
    @IBAction func countryPickerButtonAction(_ sender: Any) {
        let countryController = CountryPickerWithSectionViewController.presentController(on: self) { [weak self] (country: Country) in
            
            guard let self = self else { return }
            
            let selectedCountryCode = country.dialingCode
            let selectedCountryName = country.countryCode
            let selectedCountryVal = "(\(selectedCountryName))" + "\(selectedCountryCode ?? "")"
            self.countryCode.setTitle(selectedCountryVal, for: .normal)
            UserDefaults.standard.setValue(country.dialingCode, forKey: "countryCode") as? String ?? "+91"
            UserDefaults.standard.setValue(country.flag?.toString() ?? "", forKey: "flagImage")
        }
        
        countryController.detailColor = UIColor.red
        
    }
    
    //    MARK:- Button Action
    
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
    
    
    //    MARK:- Get Otp
    
    func getOtp() {
        let countryCode = UserDefaults.standard.value(forKey: "countryCode") ?? "+91"
        let number = "\(countryCode)" + "\(self.numberTxtFld.text ?? "")"
        PhoneAuthProvider.provider().verifyPhoneNumber(number, uiDelegate: nil) { (verificationID, error) in
            PKWrapperClass.svprogressHudShow(title: Constant.shared.appTitle, view: self)
            if let error = error {
                PKWrapperClass.svprogressHudDismiss(view: self)
                print(error.localizedDescription)
                if error.localizedDescription == "Invalid format."{
                    alert(Constant.shared.appTitle, message: "Please enter valid phone number.", view: self)
                }else{
                    alert(Constant.shared.appTitle, message: error.localizedDescription, view: self)
                }
            }else{
                PKWrapperClass.svprogressHudDismiss(view: self)
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                UserDefaults.standard.set(true, forKey: "tokenFString")
                let vc = OTPVerificationVC.instantiate(fromAppStoryboard: .Auth)
                let number = "\(UserDefaults.standard.value(forKey: "countryCode") ?? "+91")" + "\(self.numberTxtFld.text ?? "")"
                vc.phoneNumber = number
                UserDefaults.standard.set(true, forKey: "comesFromPhoneLogin")
                self.navigationController?.pushViewController(vc, animated: true)
            }
            PKWrapperClass.svprogressHudDismiss(view: self)
        }
        PKWrapperClass.svprogressHudDismiss(view: self)
    }
}
