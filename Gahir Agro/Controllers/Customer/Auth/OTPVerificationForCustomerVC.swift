//
//  OTPVerificationForCustomerVC.swift
//  Gahir Agro
//
//  Created by Apple on 12/03/21.
//

import UIKit

class OTPVerificationForCustomerVC: UIViewController,UITextFieldDelegate{

    @IBOutlet weak var sixthTF: UITextField!
    @IBOutlet weak var fifthTF: UITextField!
    @IBOutlet weak var fourthTF: UITextField!
    @IBOutlet weak var thirdTF: UITextField!
    @IBOutlet weak var secondTF: UITextField!
    @IBOutlet weak var firstTF: UITextField!
    
    var phoneNumber = String()
    var otpText = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if #available(iOS 12.0, *) {
            firstTF.textContentType = .oneTimeCode
            secondTF.textContentType = .oneTimeCode
            thirdTF.textContentType = .oneTimeCode
            fourthTF.textContentType = .oneTimeCode
            fifthTF.textContentType = .oneTimeCode
            sixthTF.textContentType = .oneTimeCode
        }
        
        firstTF.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        secondTF.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        thirdTF.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        fourthTF.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        fifthTF.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        sixthTF.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)

        // Do any additional setup after loading the view.
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    @objc func textFieldDidChange(textField: UITextField){
        let text = textField.text
        if  text?.count == 1 {
            switch textField{
            
            case firstTF:
                secondTF.becomeFirstResponder()
                
            case secondTF:
                thirdTF.becomeFirstResponder()
                
            case thirdTF:
                fourthTF.becomeFirstResponder()
                
            case fourthTF:
                fifthTF.becomeFirstResponder()
                
            case fifthTF:
                sixthTF.becomeFirstResponder()
                
            case sixthTF:
                sixthTF.becomeFirstResponder()
                self.dismissKeyboard()
            default:
                break
            }
        }
        if  text?.count == 0 {
            switch textField{
            case firstTF:
                firstTF.becomeFirstResponder()
            case secondTF:
                firstTF.becomeFirstResponder()
            case thirdTF:
                secondTF.becomeFirstResponder()
            case fourthTF:
                thirdTF.becomeFirstResponder()
            case fifthTF:
                fourthTF.becomeFirstResponder()
            case sixthTF:
                fifthTF.becomeFirstResponder()
            default:
                break
            }
        }
        else{
            
        }
    }
    
    func dismissKeyboard(){
        
        self.otpText = "\(self.firstTF.text ?? "")\(self.secondTF.text ?? "")\(self.thirdTF.text ?? "")\(self.fourthTF.text ?? "")\(self.fifthTF.text ?? "")\(self.sixthTF.text ?? "")"
        
        print(self.otpText)
        self.view.endEditing(true)
        
    }
    
    
    @IBAction func resendOtpButtonAction(_ sender: Any) {
    }
    
    
    @IBAction func varifyButtonAction(_ sender: Any) {
        let story = UIStoryboard(name: "Customer", bundle: nil)
        let rootViewController:UIViewController = story.instantiateViewController(withIdentifier: "SideMenuControllerID's")
        self.navigationController?.pushViewController(rootViewController, animated: true)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
