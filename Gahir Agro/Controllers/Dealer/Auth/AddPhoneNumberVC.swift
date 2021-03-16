//
//  AddPhoneNumberVC.swift
//  Gahir Agro
//
//  Created by Apple on 23/02/21.
//

import UIKit
import Firebase
import SKCountryPicker

class AddPhoneNumberVC: UIViewController,UITextFieldDelegate{

    @IBOutlet weak var countryPicker: UIButton!
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
        self.countryPicker.contentHorizontalAlignment = .right
        guard let country = CountryManager.shared.currentCountry else {
//            self.countryPicker.isHidden = true
            return
        }

        countryPicker.setTitle(country.countryCode, for: .highlighted)
        countryPicker.clipsToBounds = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func countrypickerButtonAction(_ sender: Any) {
        let countryController = CountryPickerWithSectionViewController.presentController(on: self) { [weak self] (country: Country) in

           guard let self = self else { return }

            self.countryPicker.setTitle(country.dialingCode, for: .normal)
            UserDefaults.standard.setValue(country.dialingCode, forKey: "code") as? String ?? "+91"
            UserDefaults.standard.setValue(country.flag?.toString() ?? "", forKey: "flagImage")
         }

         // can customize the countryPicker here e.g font and color
         countryController.detailColor = UIColor.red
    }
    
    @IBAction func generateOtpButton(_ sender: Any) {
        if mobileTxtFld.text?.isEmpty == true{
            ValidateData(strMessage: "Please enter phone number")
        }else{
            getOtp()
            let vc = OTPVerificationVC.instantiate(fromAppStoryboard: .Auth)
            UserDefaults.standard.set("2", forKey: "comesFromPhoneLogin")
            let countryCode = UserDefaults.standard.value(forKey: "code")
            let number = "\(countryCode)" + "\(mobileTxtFld.text ?? "")"
            vc.phoneNumber = number
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
