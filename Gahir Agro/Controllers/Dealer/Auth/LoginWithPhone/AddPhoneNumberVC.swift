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
    var messgae = String()
    var listingArray = ["Dealer","Customer","Executive Customer"]
    @IBOutlet weak var mobileTxtFld: UITextField!
    @IBOutlet weak var mobileNumberView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        titlelbl.text = selectedValue
        delaerorCustomerCodeLbl.text = delaerOrCustomerCode
        serialNumberTxtFld.placeholder = delaerOrCustomerCode
        UserDefaults.standard.set(delaerOrCustomerCode, forKey: "getRole")
        guard let country = CountryManager.shared.currentCountry else {
            return
        }

        countryPicker.setTitle(country.countryCode, for: .highlighted)
        countryPicker.clipsToBounds = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
//    MARK:- Button Action
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

    
    @IBAction func countrypickerButtonAction(_ sender: Any) {
        let countryController = CountryPickerWithSectionViewController.presentController(on: self) { [weak self] (country: Country) in

           guard let self = self else { return }
            let selectedCountryCode = country.dialingCode
            let selectedCountryName = country.countryCode
            let selectedCountryVal = "(\(selectedCountryName))" + "\(selectedCountryCode ?? "")"
            self.countryPicker.setTitle(selectedCountryVal, for: .normal)
            UserDefaults.standard.setValue(country.dialingCode, forKey: "code") as? String ?? "+91"
            UserDefaults.standard.setValue(country.flag?.toString() ?? "", forKey: "flagImage")
         }

         countryController.detailColor = UIColor.red
    }
    
    
    @IBAction func generateOtpButton(_ sender: Any) {
        
//        let vc = OTPVerificationVC.instantiate(fromAppStoryboard: .Auth)
//        self.navigationController?.pushViewController(vc, animated: true)
//        
        if mobileTxtFld.text?.isEmpty == true{
            ValidateData(strMessage: "Please enter phone number")
        }else if serialNumberTxtFld.text?.isEmpty == true{
            if selectedValue == "Dealer SignUp"{
                ValidateData(strMessage: "Please enter Dealer Code")
            }else{
                ValidateData(strMessage: "Please enter serial number")
            }
        }else{
            verifyUser()
        }
    }
    
//    MARK:- Service Call Method
    
    func verifyUser() {
        PKWrapperClass.svprogressHudShow(title: Constant.shared.appTitle, view: self)
        var verifyUrl = String()
        var params = [String : AnyObject]()
        var deviceID = UserDefaults.standard.value(forKey: "deviceToken") as? String
        let accessToken = UserDefaults.standard.value(forKey: "accessToken")
        let countryCode = UserDefaults.standard.value(forKey: "code") ?? "+91"
        let number = "\(countryCode)" + "\(mobileTxtFld.text ?? "")"
        print(deviceID ?? "")
        if deviceID == nil  {
            deviceID = "777"
        }
        if delaerOrCustomerCode == "Dealer Code"{
            verifyUrl = Constant.shared.baseUrl + Constant.shared.VerifyDealer
            params = ["dealer_code" : serialNumberTxtFld.text ?? "" , "phone" : number] as? [String : AnyObject] ?? [:]
        }else{
            verifyUrl = Constant.shared.baseUrl + Constant.shared.VerifyCustomer
            params = ["serial_no" : serialNumberTxtFld.text ?? "" , "phone" : number] as? [String : AnyObject] ?? [:]
        }
        print(params)
        self.serialNumberTxtFld.resignFirstResponder()
        self.mobileTxtFld.resignFirstResponder()

        PKWrapperClass.requestPOSTWithFormData(verifyUrl, params: params, imageData: []) { (response) in
            print(response.data)
            PKWrapperClass.svprogressHudDismiss(view: self)
            let status = response.data["status"] as? String ?? ""
            let signupStatus = response.data["app_signup"] as? Int ?? 0
            self.messgae = response.data["message"] as? String ?? ""
            if status == "1"{
                self.serialNumberTxtFld.resignFirstResponder()
                self.mobileTxtFld.resignFirstResponder()
                if signupStatus == 0{
                    self.serialNumberTxtFld.resignFirstResponder()
                    self.mobileTxtFld.resignFirstResponder()
                    let vc = OTPVerificationVC.instantiate(fromAppStoryboard: .Auth)
                    UserDefaults.standard.set(false, forKey: "comesFromPhoneLogin")
                    UserDefaults.standard.set(self.serialNumberTxtFld.text, forKey: "dealerCode")
                    let countryCode = UserDefaults.standard.value(forKey: "code") ?? "+91"
                    let number = "\(countryCode)" + "\(self.mobileTxtFld.text ?? "")"
                    vc.phoneNumber = number
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
                
            }else{
                self.serialNumberTxtFld.resignFirstResponder()
                self.mobileTxtFld.resignFirstResponder()
                PKWrapperClass.svprogressHudDismiss(view: self)
                alert(Constant.shared.appTitle, message: self.messgae, view: self)
            }
        } failure: { (error) in
            print(error)
            showAlertMessage(title: Constant.shared.appTitle, message: error as? String ?? "", okButton: "Ok", controller: self, okHandler: nil)
        }
    }
    
//    MARK:- Get Otp
    
//    func getOtp() {
//        let countryCode = UserDefaults.standard.value(forKey: "code") ?? "+91"
//        let number = "\(countryCode)" + "\(mobileTxtFld.text ?? "")"
//        PhoneAuthProvider.provider().verifyPhoneNumber(number, uiDelegate: nil) { (verificationID, error) in
//            PKWrapperClass.svprogressHudShow(title: Constant.shared.appTitle, view: self)
//            if let error = error {
//                PKWrapperClass.svprogressHudDismiss(view: self)
//                print(error.localizedDescription)
//                if error.localizedDescription == "Invalid format."{
//                  alert(Constant.shared.appTitle, message: "please enter valid phone number.", view: self)
//                }else{
//                   alert(Constant.shared.appTitle, message: error.localizedDescription, view: self)
//                }
//
//            }else{
//                PKWrapperClass.svprogressHudDismiss(view: self)
//                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
//                print(verificationID)
//                let vc = OTPVerificationVC.instantiate(fromAppStoryboard: .Auth)
//                UserDefaults.standard.set("2", forKey: "comesFromPhoneLogin")
//                let countryCode = UserDefaults.standard.value(forKey: "code")
//                let number = "\(countryCode)" + "\(self.mobileTxtFld.text ?? "")"
//                vc.phoneNumber = number
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
//            PKWrapperClass.svprogressHudDismiss(view: self)
//        }
//        PKWrapperClass.svprogressHudDismiss(view: self)
//    }
}

//MARK:- Get data from popup view

extension AddPhoneNumberVC : PopViewControllerDelegate {
    func dismissPopUP(sendData: String) {
    }
}
