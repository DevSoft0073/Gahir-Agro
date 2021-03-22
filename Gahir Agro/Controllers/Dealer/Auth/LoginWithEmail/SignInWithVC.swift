//
//  SignInWithVC.swift
//  Gahir Agro
//
//  Created by Apple on 23/02/21.
//

import UIKit

class SignInWithVC: UIViewController{

    var role = PKWrapperClass.getRole()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(role)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func logInWithPhoneButtonAction(_ sender: Any) {
        let vc = SignInWithPhone.instantiate(fromAppStoryboard: .Auth)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func logInWithMailButtonAction(_ sender: Any) {
        let vc = SignInVC.instantiate(fromAppStoryboard: .Auth)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func signInButtonAction(_ sender: Any) {
        let vc = ChooseRoleForCustomerAndDealerVC.instantiate(fromAppStoryboard: .Auth)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
