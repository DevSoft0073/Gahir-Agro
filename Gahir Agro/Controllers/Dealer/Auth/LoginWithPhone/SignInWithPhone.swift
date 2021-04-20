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
            phoneLogin()
        }
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //    MARK:- Service Call Function
    
    func phoneLogin() {
        PKWrapperClass.svprogressHudShow(title: Constant.shared.appTitle, view: self)
        let url = Constant.shared.baseUrl + Constant.shared.PhoneLogin
        var deviceID = UserDefaults.standard.value(forKey: "deviceToken") as? String
        print(deviceID ?? "")
        if deviceID == nil  {
            deviceID = "777"
        }
        let number = "\(UserDefaults.standard.value(forKey: "countryCode") ?? "+91")" + "\(numberTxtFld.text ?? "")"
        let params = ["phone":number,"device_token": deviceID ?? "","device_type":"iOS"] as? [String : AnyObject] ?? [:]
        print(params)
        PKWrapperClass.requestPOSTWithFormData(url, params: params, imageData: []) { (response) in
            print(response.data)
            PKWrapperClass.svprogressHudDismiss(view: self)
            self.numberTxtFld.resignFirstResponder()
            let status = response.data["status"] as? String ?? ""
            self.message = response.data["message"] as? String ?? ""
            UserDefaults.standard.setValue(response.data["access_token"] as? String ?? "", forKey: "accessToken")
            if status == "1"{
                UserDefaults.standard.set(true, forKey: "tokenFString")
                let allData = response.data as? [String:Any] ?? [:]
                let data = allData["user_detail"] as? [String:Any] ?? [:]
                print(data)
                let vc = OTPVerificationVC.instantiate(fromAppStoryboard: .Auth)
                let number = "\(UserDefaults.standard.value(forKey: "countryCode") ?? "+91")" + "\(self.numberTxtFld.text ?? "")"
                vc.phoneNumber = number
                UserDefaults.standard.set(true, forKey: "comesFromPhoneLogin")
                self.navigationController?.pushViewController(vc, animated: true)
//                UserDefaults.standard.set(data["dealer_code"] as? String ?? "", forKey: "code")
//                UserDefaults.standard.set(1, forKey: "tokenFString")
//                UserDefaults.standard.set(data["id"], forKey: "id")
//                UserDefaults.standard.setValue(data["role"], forKey: "checkRole")
//                UserDefaults.standard.setValue(data["serial_no"], forKey: "serialNumber")
//
//                if data["role"] as? String ?? "" == "admin"{
//                    DispatchQueue.main.async {
//                        let story = UIStoryboard(name: "AdminMain", bundle: nil)
//                        let rootViewController:UIViewController = story.instantiateViewController(withIdentifier: "AdminSideMenuControllerID")
//                        self.navigationController?.pushViewController(rootViewController, animated: true)
//                    }
//                }else if data["role"] as? String ?? "" == "Sales"{
//
//                    DispatchQueue.main.async {
//                        let story = UIStoryboard(name: "AdminMain", bundle: nil)
//                        let rootViewController:UIViewController = story.instantiateViewController(withIdentifier: "AdminSideMenuControllerID")
//                        self.navigationController?.pushViewController(rootViewController, animated: true)
//                    }
//
//                }else if data["role"] as? String ?? "" == "Customer"{
//                    DispatchQueue.main.async {
//                        let story = UIStoryboard(name: "Main", bundle: nil)
//                        let rootViewController:UIViewController = story.instantiateViewController(withIdentifier: "SideMenuControllerID")
//                        self.navigationController?.pushViewController(rootViewController, animated: true)
//                    }
//
//                }else if data["role"] as? String ?? "" == "Dealer"{
//                    DispatchQueue.main.async {
//                        let story = UIStoryboard(name: "Main", bundle: nil)
//                        let rootViewController:UIViewController = story.instantiateViewController(withIdentifier: "SideMenuControllerID")
//                        self.navigationController?.pushViewController(rootViewController, animated: true)
//                    }
//                }
            }else {
                alert(Constant.shared.appTitle, message: self.message, view: self)
            }
        } failure: { (error) in
            print(error)
            PKWrapperClass.svprogressHudDismiss(view: self)
            showAlertMessage(title: Constant.shared.appTitle, message: error as? String ?? "", okButton: "Ok", controller: self, okHandler: nil)
        }
    }

    
}
