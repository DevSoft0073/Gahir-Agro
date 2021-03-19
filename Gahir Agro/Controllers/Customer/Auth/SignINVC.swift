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

    var messgae = String()
    @IBOutlet weak var countryCode: UIButton!
    @IBOutlet weak var phoneNumberTxtFld: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.countryCode.contentHorizontalAlignment = .center
        guard let country = CountryManager.shared.currentCountry else {
            return
        }

        countryCode.setTitle(country.countryCode, for: .highlighted)
        countryCode.clipsToBounds = true
        

    }
    
    func logIn() {
        PKWrapperClass.svprogressHudShow(title: Constant.shared.appTitle, view: self)
        let url = Constant.shared.baseUrl + Constant.shared.CustomerLogin
        var deviceID = UserDefaults.standard.value(forKey: "deviceToken") as? String
        print(deviceID ?? "")
        if deviceID == nil  {
            deviceID = "777"
        }
        let params = ["phone":"+91\(phoneNumberTxtFld.text ?? "")", "device_token" : deviceID! ,"device_type" : "iOS"] as? [String : AnyObject] ?? [:]
        print(params)
        PKWrapperClass.requestPOSTWithFormData(url, params: params, imageData: []) { (response) in
            print(response.data)
            PKWrapperClass.svprogressHudDismiss(view: self)
            let signUpStatus = response.data["app_signup"] as? String ?? ""
            let status = response.data["status"] as? String ?? ""
            self.messgae = response.data["message"] as? String ?? ""
            UserDefaults.standard.setValue(response.data["access_token"] as? String ?? "", forKey: "accessToken")
            if status == "1"{
                if signUpStatus == "0"{
                    let vc = SignUpVC.instantiate(fromAppStoryboard: .Auth)
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    let allData = response.data as? [String:Any] ?? [:]
                    let data = allData["user_detail"] as? [String:Any] ?? [:]
                    UserDefaults.standard.set(1, forKey: "tokenFString")
                    UserDefaults.standard.set(data["id"], forKey: "id")
                    UserDefaults.standard.setValue(data["role"], forKey: "checkRole")
                    DispatchQueue.main.async {
                        let story = UIStoryboard(name: "Customer", bundle: nil)
                        let rootViewController:UIViewController = story.instantiateViewController(withIdentifier: "SideMenuControllerID's")
                        self.navigationController?.pushViewController(rootViewController, animated: true)
                    }
                }
            }else{
                PKWrapperClass.svprogressHudDismiss(view: self)
                alert(Constant.shared.appTitle, message: self.messgae, view: self)
            }
        } failure: { (error) in
            print(error)
            showAlertMessage(title: Constant.shared.appTitle, message: error as? String ?? "", okButton: "Ok", controller: self, okHandler: nil)
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
        if phoneNumberTxtFld.text?.isEmpty == true {
            ValidateData(strMessage: "Please enter phone number")
        }else{
            logIn()
        }
       
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
