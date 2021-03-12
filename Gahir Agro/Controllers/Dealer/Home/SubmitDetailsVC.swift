//
//  SubmitDetailsVC.swift
//  Gahir Agro
//
//  Created by Apple on 09/03/21.
//

import UIKit

class SubmitDetailsVC: UIViewController {

    var enquiryID = String()
    var messgae = String()
    var name = String()
    var modelName = String()
    var amount = String()
    var quantity = String()
    
    
    @IBOutlet weak var amountTxtFld: UITextField!
    @IBOutlet weak var quantityTxtFld: UITextField!
    @IBOutlet weak var accesoriesTxtFld: UITextField!
    @IBOutlet weak var modelNameTxtFld: UITextField!
    @IBOutlet weak var nameTxtFld: UITextField!
    @IBOutlet weak var dealerCodeTxtFld: UITextField!
    @IBOutlet weak var utrNumberTxtFld: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTxtFld.text = name
        amountTxtFld.text = amount
        quantityTxtFld.text = quantity
        dealerCodeTxtFld.text = "ASHJK8767"
        modelNameTxtFld.text = "Model"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func addOrder()  {
        PKWrapperClass.svprogressHudShow(title: Constant.shared.appTitle, view: self)
        let url = Constant.shared.baseUrl + Constant.shared.BookOrder
        var deviceID = UserDefaults.standard.value(forKey: "deviceToken") as? String
        let accessToken = UserDefaults.standard.value(forKey: "accessToken")
        print(deviceID ?? "")
        if deviceID == nil  {
            deviceID = "777"
        }
        let params = ["access_token" : accessToken , "enquiry_id" : self.enquiryID , "utr_no" : utrNumberTxtFld.text ?? ""]  as? [String : AnyObject] ?? [:]
        print(params)
        PKWrapperClass.requestPOSTWithFormData(url, params: params, imageData: [[:]]) { (response) in
            print(response.data)
            PKWrapperClass.svprogressHudDismiss(view: self)
            let status = response.data["status"] as? String ?? ""
            self.messgae = response.data["message"] as? String ?? ""
            if status == "1"{
                showAlertMessage(title: Constant.shared.appTitle, message: self.messgae, okButton: "Ok", controller: self) {
                    let vc = SuccesfullyBookedVC.instantiate(fromAppStoryboard: .Main)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }else{
                PKWrapperClass.svprogressHudDismiss(view: self)
                alert(Constant.shared.appTitle, message: self.messgae, view: self)
                self.navigationController?.popViewController(animated: true)
            }
        } failure: { (error) in
            print(error)
            showAlertMessage(title: Constant.shared.appTitle, message: error as? String ?? "", okButton: "Ok", controller: self, okHandler: nil)
        }
    }
    
    
    
    @IBAction func submitButtonAction(_ sender: Any) {
        if utrNumberTxtFld.text?.isEmpty == true{
            ValidateData(strMessage: "UTR field should not be empty")
        }else{
            addOrder()
        }
    }
}
