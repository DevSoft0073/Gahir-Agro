//
//  SignInWithVC.swift
//  Gahir Agro
//
//  Created by Apple on 23/02/21.
//

import UIKit

class SignInWithVC: UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func logInWithPhoneButtonAction(_ sender: Any) {
        let vc = AddPhoneNumberVC.instantiate(fromAppStoryboard: .Auth)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func logInWithMailButtonAction(_ sender: Any) {
       
    }
    
    @IBAction func signInButtonAction(_ sender: Any) {
        let vc = SignInVC.instantiate(fromAppStoryboard: .Auth)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
