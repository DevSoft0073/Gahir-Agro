//
//  SignInWithScreenVC.swift
//  Gahir Agro
//
//  Created by Apple on 12/03/21.
//

import UIKit

class SignInWithScreenVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func loginWithPhone(_ sender: Any) {
        let vc = SignINVC.instantiate(fromAppStoryboard: .AuthForCustomer)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func signUpButtonAction(_ sender: Any) {
        let vc = SignUPVC.instantiate(fromAppStoryboard: .AuthForCustomer)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func backbuttonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
