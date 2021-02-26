//
//  OTPVerificationVC.swift
//  Gahir Agro
//
//  Created by Apple on 23/02/21.
//

import UIKit

class OTPVerificationVC: UIViewController  ,UITextFieldDelegate{
    
    @IBOutlet weak var textFour: UITextField!
    @IBOutlet weak var textTheww: UITextField!
    @IBOutlet weak var textTwo: UITextField!
    @IBOutlet weak var textOne: UITextField!
    var otpText = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if #available(iOS 12.0, *) {
            textOne.textContentType = .oneTimeCode
            textTwo.textContentType = .oneTimeCode
            textTheww.textContentType = .oneTimeCode
            textFour.textContentType = .oneTimeCode
        }
        
        textOne.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        textTwo.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        textTheww.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        textFour.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
//        textOne.becomeFirstResponder()
        
        self.view.resignFirstResponder()
        // Do any additional setup after loading the view.
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

    //When changed value in textField
    @objc func textFieldDidChange(textField: UITextField){
        let text = textField.text
        if  text?.count == 1 {
            switch textField{
                
            case textOne:
                textTwo.becomeFirstResponder()
                
            case textTwo:
                textTheww.becomeFirstResponder()
                
            case textTheww:
                textFour.becomeFirstResponder()
                
            case textFour:
                textFour.becomeFirstResponder()
                self.dismissKeyboard()
            default:
                break
            }
        }
        if  text?.count == 0 {
            switch textField{
            case textOne:
                textOne.becomeFirstResponder()
            case textTwo:
                textOne.becomeFirstResponder()
            case textTheww:
                textTwo.becomeFirstResponder()
            case textFour:
                textTheww.becomeFirstResponder()
            default:
                break
            }
        }
        else{
            
        }
    }
    
    func dismissKeyboard(){
        
        self.otpText = "\(self.textOne.text ?? "")\(self.textTwo.text ?? "")\(self.textTheww.text ?? "")\(self.textFour.text ?? "")"
        
        print(self.otpText)
        self.view.endEditing(true)
        
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func verifyButton(_ sender: Any) {
        let vc = SignUpVC.instantiate(fromAppStoryboard: .Auth)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
