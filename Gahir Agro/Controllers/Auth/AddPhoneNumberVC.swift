//
//  AddPhoneNumberVC.swift
//  Gahir Agro
//
//  Created by Apple on 23/02/21.
//

import UIKit

class AddPhoneNumberVC: UIViewController,UITextFieldDelegate{

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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dealerTxtFld.text = UserDefaults.standard.value(forKey: "data") as? String ?? ""
    }
    
    @IBAction func generateOtpButton(_ sender: Any) {
        let vc = OTPVerificationVC.instantiate(fromAppStoryboard: .Auth)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func openPicker(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopUpVC") as! PopUpVC
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
}
