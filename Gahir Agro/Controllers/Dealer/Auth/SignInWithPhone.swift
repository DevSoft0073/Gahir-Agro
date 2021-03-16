//
//  SignInWithPhone.swift
//  Gahir Agro
//
//  Created by Apple on 01/03/21.
//

import UIKit
import Firebase
import SKCountryPicker

class SignInWithPhone: UIViewController {

    @IBOutlet weak var countryCode: UIButton!
    @IBOutlet weak var numberTxtFld: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.countryCode.contentHorizontalAlignment = .right
        guard let country = CountryManager.shared.currentCountry else {
//            self.countryPicker.isHidden = true
            return
        }

        countryCode.setTitle(country.countryCode, for: .highlighted)
        countryCode.clipsToBounds = true
        
        // Do any additional setup after loading the view.
    }
    @IBAction func countryPickerButtonAction(_ sender: Any) {
        let countryController = CountryPickerWithSectionViewController.presentController(on: self) { [weak self] (country: Country) in

           guard let self = self else { return }

            self.countryCode.setTitle(country.dialingCode, for: .normal)
            UserDefaults.standard.setValue(country.dialingCode, forKey: "code") as? String ?? "+91"
            UserDefaults.standard.setValue(country.flag?.toString() ?? "", forKey: "flagImage")
         }

         // can customize the countryPicker here e.g font and color
         countryController.detailColor = UIColor.red
        
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
            let countryCode = UserDefaults.standard.value(forKey: "code")
            let number = "\(countryCode)" + "\(self.numberTxtFld.text ?? "")"
            vc.phoneNumber = number
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
