//
//  SignInWithVC.swift
//  Gahir Agro
//
//  Created by Apple on 23/02/21.
//

import UIKit

class SignInWithVC: UIViewController{

    @IBOutlet weak var backImg: UIImageView!
    @IBOutlet weak var backBtn: UIButton!
    var role = PKWrapperClass.getRole()
    override func viewDidLoad() {
        super.viewDidLoad()
        print(role)
        
        
        if UserDefaults.standard.value(forKey: "fromguestLogin") as? Bool ?? false == true {
            backImg.isHidden = false
            backBtn.isHidden = false
        }else{
            backImg.isHidden = true
            backBtn.isHidden = true
        }
        
        // Do any additional setup after loading the view.
    }
    
//    MARK:- Button Actions
    
    
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
        
        
        AppDelegate().redirectToHomeVC()
        
        
    }
}
