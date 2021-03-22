//
//  AddPhoneNumberVC.swift
//  Gahir Agro
//
//  Created by Apple on 23/02/21.
//

import UIKit
import Firebase
import SKCountryPicker
import FirebaseAuth

class AddPhoneNumberVC: UIViewController,UITextFieldDelegate{

    @IBOutlet weak var delaerorCustomerCodeLbl: UILabel!
    @IBOutlet weak var serialNumberTxtFld: UITextField!
    @IBOutlet weak var serialnumberView: UIView!
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var countryPicker: UIButton!
    var picker  = UIPickerView()
    var pickerToolBar = UIToolbar()
    var selectedValue = String()
    var delaerOrCustomerCode = String()
    var listingArray = ["Dealer","Customer","Executive Customer"]
    @IBOutlet weak var mobileTxtFld: UITextField!
    @IBOutlet weak var mobileNumberView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        titlelbl.text = selectedValue
        delaerorCustomerCodeLbl.text = delaerOrCustomerCode
        serialNumberTxtFld.placeholder = delaerOrCustomerCode
        guard let country = CountryManager.shared.currentCountry else {
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

         countryController.detailColor = UIColor.red
    }
    
    @IBAction func generateOtpButton(_ sender: Any) {
        if mobileTxtFld.text?.isEmpty == true{
            ValidateData(strMessage: "Please enter phone number")
        }else if serialNumberTxtFld.text?.isEmpty == true{
            if selectedValue == "Dealer SignUp"{
                ValidateData(strMessage: "Please enter Dealer Code")
            }else{
                ValidateData(strMessage: "Please enter serial number")
            }
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
            alert(Constant.shared.appTitle, message: error.localizedDescription, view: self)
            return
          }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

//MARK:- Get data from popup view

extension AddPhoneNumberVC : PopViewControllerDelegate {
    func dismissPopUP(sendData: String) {
//        self.dealerTxtFld.text = sendData
    }
}
