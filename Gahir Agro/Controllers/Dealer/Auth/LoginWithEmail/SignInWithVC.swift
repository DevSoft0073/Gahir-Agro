//
//  SignInWithVC.swift
//  Gahir Agro
//
//  Created by Apple on 23/02/21.
//

import UIKit

class SignInWithVC: UIViewController{

    @IBOutlet weak var backOmg: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    var role = PKWrapperClass.getRole()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backOmg.isHidden = true
        backBtn.isHidden = true
        
        print(role)
        
        let comesFrom = UserDefaults.standard.value(forKey: "comesFromLogout") as? Bool ?? false
        
        if comesFrom == true {
            backOmg.isHidden = true
            backBtn.isHidden = true
        }else{
            backOmg.isHidden = false
            backBtn.isHidden = false
        }

        // Do any additional setup after loading the view.
    }
    
//    MARK:- Button Actions
    
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
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
