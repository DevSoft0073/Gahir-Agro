//
//  SubmitDetailsVC.swift
//  Gahir Agro
//
//  Created by Apple on 09/03/21.
//

import UIKit

class SubmitDetailsVC: UIViewController  , UITextFieldDelegate{

    var enquiryID = String()
    var messgae = String()
    var name = String()
    var modelName = String()
    var amount = String()
    var quantity = String()
    var accessoriesName = String()
    
    @IBOutlet weak var amountTxtFld: UITextField!
    @IBOutlet weak var quantityTxtFld: UITextField!
    @IBOutlet weak var accesoriesTxtFld: UITextField!
    @IBOutlet weak var nameTxtFld: UITextField!
    @IBOutlet weak var dealerCodeTxtFld: UITextField!
    @IBOutlet weak var utrNumberTxtFld: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        amount = amount.replacingOccurrences(of: ",", with: "")
        nameTxtFld.text = name
        quantityTxtFld.text = quantity
        dealerCodeTxtFld.text = UserDefaults.standard.value(forKey: "code") as? String ?? ""
        accesoriesTxtFld.text = accessoriesName
        amountTxtFld.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        enquiryDetails()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == amountTxtFld{
            // Uses the number format corresponding to your Locale
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.locale = Locale.current
            formatter.maximumFractionDigits = 0
            if let groupingSeparator = formatter.groupingSeparator {
                
                if string == groupingSeparator {
                    return true
                }
                
                
                if let textWithoutGroupingSeparator = amountTxtFld.text?.replacingOccurrences(of: groupingSeparator, with: "") {
                    var totalTextWithoutGroupingSeparators = textWithoutGroupingSeparator + string
                    if string.isEmpty { // pressed Backspace key
                        totalTextWithoutGroupingSeparators.removeLast()
                    }
                    if let numberWithoutGroupingSeparator = formatter.number(from: totalTextWithoutGroupingSeparators),
                       let formattedText = formatter.string(from: numberWithoutGroupingSeparator) {
                        
                        amountTxtFld.text = formattedText
                        return false
                    }
                }
            }
        }
        return true
    }
    
    
    //    MARK:- Service Call
        
        
        func enquiryDetails() {
            PKWrapperClass.svprogressHudShow(title: Constant.shared.appTitle, view: self)
            let url = Constant.shared.baseUrl + Constant.shared.EnquiryDetails
            var deviceID = UserDefaults.standard.value(forKey: "deviceToken") as? String
            let accessToken = UserDefaults.standard.value(forKey: "accessToken")
            print(deviceID ?? "")
            if deviceID == nil  {
                deviceID = "777"
            }
            let params = ["access_token": accessToken , "id" : self.enquiryID]  as? [String : AnyObject] ?? [:]
            print(params)
            PKWrapperClass.requestPOSTWithFormData(url, params: params, imageData: []) { (response) in
                print(response.data)
                PKWrapperClass.svprogressHudDismiss(view: self)
                let status = response.data["status"] as? String ?? ""
                self.messgae = response.data["message"] as? String ?? ""
                if status == "1"{
                    let allDetails = response.data["enquiry_detail"] as? [String:Any] ?? [:]
                    self.nameTxtFld.text = allDetails["prod_name"] as? String ?? ""
                    self.dealerCodeTxtFld.text = allDetails["dealer_code"] as? String ?? ""
                    self.quantityTxtFld.text = allDetails["qty"] as? String ?? ""
                    self.accesoriesTxtFld.text = allDetails["acc_name"] as? String ?? ""
                }else{
                    PKWrapperClass.svprogressHudDismiss(view: self)
                    alert(Constant.shared.appTitle, message: self.messgae, view: self)
                }
            } failure: { (error) in
                print(error)
                PKWrapperClass.svprogressHudDismiss(view: self)
                showAlertMessage(title: Constant.shared.appTitle, message: error as? String ?? "", okButton: "Ok", controller: self, okHandler: nil)
            }
        }

    
//    MARK:- Button Action
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitButtonAction(_ sender: Any) {
        if amountTxtFld.text?.isEmpty == true{
            ValidateData(strMessage: "Please deposit amount")
        }
        else if utrNumberTxtFld.text?.isEmpty == true{
            ValidateData(strMessage: "UTR field should not be empty")
        }else{
            addOrder()
        }
    }
    
//    MARK:- Service call
    
    func addOrder()  {
        PKWrapperClass.svprogressHudShow(title: Constant.shared.appTitle, view: self)
        let url = Constant.shared.baseUrl + Constant.shared.BookOrder
        var deviceID = UserDefaults.standard.value(forKey: "deviceToken") as? String
        let accessToken = UserDefaults.standard.value(forKey: "accessToken")
        print(deviceID ?? "")
        if deviceID == nil  {
            deviceID = "777"
        }
        
        let params = ["access_token" : accessToken , "enquiry_id" : self.enquiryID , "utr_no" : utrNumberTxtFld.text ?? String(),"amount" : amountTxtFld.text ?? String() ]  as? [String : AnyObject] ?? [:]
        print(params)
        PKWrapperClass.requestPOSTWithFormData(url, params: params, imageData: []) { (response) in
            print(response.data)
            PKWrapperClass.svprogressHudDismiss(view: self)
            let status = response.data["status"] as? String ?? ""
            self.messgae = response.data["message"] as? String ?? ""
            if status == "1"{
                self.utrNumberTxtFld.resignFirstResponder()
                showAlertMessage(title: Constant.shared.appTitle, message: self.messgae, okButton: "Ok", controller: self) {
                    let comesFrom = UserDefaults.standard.value(forKey: "comesFromPush") as? Bool
                    if comesFrom == true{
                        AppDelegate().redirectToHomeVC()
                        UserDefaults.standard.setValue(false, forKey: "comesFromPush")
                    }else{
                        let vc = EnquriesVC.instantiate(fromAppStoryboard: .Main)
                        NotificationCenter.default.post(name: .sendUserData, object: nil)
                        UserDefaults.standard.setValue(true, forKey: "comesFromOrder")
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            } else if status == "0"{
                self.utrNumberTxtFld.resignFirstResponder()
                PKWrapperClass.svprogressHudDismiss(view: self)
                alert(Constant.shared.appTitle, message: self.messgae, view: self)
                self.navigationController?.popViewController(animated: true)
            } else if status == "100"{
                self.utrNumberTxtFld.resignFirstResponder()
                showAlertMessage(title: Constant.shared.appTitle, message: self.messgae, okButton: "Ok", controller: self) {
                    UserDefaults.standard.removeObject(forKey: "tokenFString")
                    let appDel = UIApplication.shared.delegate as! AppDelegate
                    appDel.Logout1()
                }
            }
        } failure: { (error) in
            print(error)
            PKWrapperClass.svprogressHudDismiss(view: self)
            showAlertMessage(title: Constant.shared.appTitle, message: error as? String ?? "", okButton: "Ok", controller: self, okHandler: nil)
        }
    }
}

extension Notification.Name {
    public static let showHomeSelectedAdminSideMenu = Notification.Name(rawValue: "showHomeSelected")
}

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyGroupingSeparator = ","
        formatter.locale = Locale(identifier: "en_US") //for USA's currency patter
        return formatter
    }()
}

extension Numeric {
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}
