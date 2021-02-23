//
//  OTPVerificationVC.swift
//  Gahir Agro
//
//  Created by Apple on 23/02/21.
//

import UIKit

class OTPVerificationVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func verifyButton(_ sender: Any) {
        let vc = SignUpVC.instantiate(fromAppStoryboard: .Auth)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
