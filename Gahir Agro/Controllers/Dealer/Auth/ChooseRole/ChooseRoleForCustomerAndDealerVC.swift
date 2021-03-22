//
//  ChooseRoleForCustomerAndDealerVC.swift
//  Gahir Agro
//
//  Created by Apple on 22/03/21.
//

import UIKit

class ChooseRoleForCustomerAndDealerVC: UIViewController {

    @IBOutlet weak var customerView: UIView!
    @IBOutlet weak var dealerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func dealerButtonAction(_ sender: Any) {
        dealerView.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        customerView.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        let vc = AddPhoneNumberVC.instantiate(fromAppStoryboard: .Auth)
        vc.selectedValue = "Dealer SignUp"
        vc.delaerOrCustomerCode = "Dealer Code"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func customerButtonAction(_ sender: Any) {
        dealerView.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        customerView.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        let vc = AddPhoneNumberVC.instantiate(fromAppStoryboard: .Auth)
        vc.selectedValue = "Customer SignUp"
        vc.delaerOrCustomerCode = "Serial Number"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
