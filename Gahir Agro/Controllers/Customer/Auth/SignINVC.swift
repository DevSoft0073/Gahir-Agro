//
//  SignINVC.swift
//  Gahir Agro
//
//  Created by Apple on 12/03/21.
//

import UIKit

class SignINVC: UIViewController {

    @IBOutlet weak var phoneNumberTxtFld: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func generateOtpButtonAction(_ sender: Any) {
        let vc = OTPVerificationForCustomerVC.instantiate(fromAppStoryboard: .AuthForCustomer)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
    }

}
