//
//  SignINVC.swift
//  Gahir Agro
//
//  Created by Apple on 12/03/21.
//

import UIKit
import SKCountryPicker
import Firebase
import FirebaseAuth

class SignINVC: UIViewController {

    @IBOutlet weak var countryCode: UIButton!
    @IBOutlet weak var phoneNumberTxtFld: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.countryCode.contentHorizontalAlignment = .right
        guard let country = CountryManager.shared.currentCountry else {
            return
        }

        countryCode.setTitle(country.countryCode, for: .highlighted)
        countryCode.clipsToBounds = true
        

    }
    
    func getOtp() {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumberTxtFld.text ?? "", uiDelegate: nil) { (verificationID, error) in
          if let error = error {
            alert(Constant.shared.appTitle, message: error.localizedDescription, view: self)
            return
          }
            print(verificationID)
            UserDefaults.standard.setValue(verificationID, forKey: "authVerificationID")
            let vc = OTPVerificationVC.instantiate(fromAppStoryboard: .Auth)
            let countryCode = UserDefaults.standard.value(forKey: "code")
            let number = "\(countryCode)" + "\(self.phoneNumberTxtFld.text ?? "")"
            vc.phoneNumber = number
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func openCountryCodePicker(_ sender: Any) {
        let countryController = CountryPickerWithSectionViewController.presentController(on: self) { [weak self] (country: Country) in

           guard let self = self else { return }

            self.countryCode.setTitle(country.dialingCode, for: .normal)
            UserDefaults.standard.setValue(country.dialingCode, forKey: "code") as? String ?? "+91"
            UserDefaults.standard.setValue(country.flag?.toString() ?? "", forKey: "flagImage")
         }
    }
    
    @IBAction func generateOtpButtonAction(_ sender: Any) {
        
//        if numberTxtFld.text?.isEmpty == true{
//            ValidateData(strMessage: "Please enter phone number")
//
//        }else{
//            getOtp()
//        }
        
        let vc = OTPVerificationForCustomerVC.instantiate(fromAppStoryboard: .AuthForCustomer)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
    }

}
