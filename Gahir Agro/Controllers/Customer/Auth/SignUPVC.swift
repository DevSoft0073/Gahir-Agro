//
//  SignUPVC.swift
//  Gahir Agro
//
//  Created by Apple on 12/03/21.
//

import UIKit
import SKCountryPicker
import Firebase
import FirebaseAuth

class SignUPVC: UIViewController {
    
    @IBOutlet weak var serialNumberTxtFld: UITextField!
    @IBOutlet weak var numberTxtFld: UITextField!
    @IBOutlet weak var countryButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.countryButton.contentHorizontalAlignment = .center
        guard let country = CountryManager.shared.currentCountry else {
            return
        }
        countryButton.setTitle(country.countryCode, for: .highlighted)
        countryButton.clipsToBounds = true
    }
    
    
    func getOtp() {
        PhoneAuthProvider.provider().verifyPhoneNumber(numberTxtFld.text ?? "", uiDelegate: nil) { (verificationID, error) in
          if let error = error {
            alert(Constant.shared.appTitle, message: error.localizedDescription, view: self)
            return
          }
            print(verificationID)
            UserDefaults.standard.setValue(verificationID, forKey: "authVerificationID")
            let vc = OTPVerificationVC.instantiate(fromAppStoryboard: .AuthForCustomer)
            let countryCode = UserDefaults.standard.value(forKey: "code")
            let number = "\(countryCode)" + "\(self.numberTxtFld.text ?? "")"
            vc.phoneNumber = number
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func generateButtonAction(_ sender: Any) {
        if numberTxtFld.text?.isEmpty == true{
            ValidateData(strMessage: "Please enter phone number")
        }else if serialNumberTxtFld.text?.isEmpty == true{
            ValidateData(strMessage: "Please enter serial number")
        }else{
            getOtp()
//            let vc = OTPVerificationVC.instantiate(fromAppStoryboard: .Auth)
//            UserDefaults.standard.set("2", forKey: "comesFromPhoneLogin")
//            let countryCode = UserDefaults.standard.value(forKey: "code")
//            let number = "\(countryCode)" + "\(numberTxtFld.text ?? "")"
//            vc.phoneNumber = number
//            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func openCountryPickerButtonAction(_ sender: Any) {
        let countryController = CountryPickerWithSectionViewController.presentController(on: self) { [weak self] (country: Country) in
            
            guard let self = self else { return }
            
            self.countryButton.setTitle(country.dialingCode, for: .normal)
            UserDefaults.standard.setValue(country.dialingCode, forKey: "code") as? String ?? "+91"
            UserDefaults.standard.setValue(country.flag?.toString() ?? "", forKey: "flagImage")
        }
    }
    
}
