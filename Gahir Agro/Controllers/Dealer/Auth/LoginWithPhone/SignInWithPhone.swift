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

class SignInWithPhone: UIViewController {

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
    
//    MARK:- Country Picker
    
    @IBAction func countryPickerButtonAction(_ sender: Any) {
        let countryController = CountryPickerWithSectionViewController.presentController(on: self) { [weak self] (country: Country) in

           guard let self = self else { return }

            self.countryCode.setTitle(country.dialingCode, for: .normal)
            UserDefaults.standard.setValue(country.dialingCode, forKey: "code") as? String ?? "+91"
            UserDefaults.standard.setValue(country.flag?.toString() ?? "", forKey: "flagImage")
         }

         countryController.detailColor = UIColor.red
        
    }
    
//    MARK:- Button Action
    
    @IBAction func gernerateOtpButton(_ sender: Any) {
        if numberTxtFld.text?.isEmpty == true{
            ValidateData(strMessage: "Please enter phone number")
            
        }else{
            let vc = OTPVerificationVC.instantiate(fromAppStoryboard: .Auth)
            let countryCode = UserDefaults.standard.value(forKey: "code") ?? "+91"
            let number = "\(countryCode)" + "\(self.numberTxtFld.text ?? "")"
            vc.phoneNumber = number
            UserDefaults.standard.set(true, forKey: "comesFromPhoneLogin")
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
