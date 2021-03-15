//
//  CustomerProfileVC.swift
//  Gahir Agro
//
//  Created by Apple on 15/03/21.
//

import UIKit
import LGSideMenuController

class CustomerProfileVC: UIViewController {

    @IBOutlet weak var addressLbl: UITextField!
    @IBOutlet weak var passwordLbl: UITextField!
    @IBOutlet weak var emailLbl: UITextField!
    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func menuButtonAction(_ sender: Any) {
    }
    
    @IBAction func editButtonAction(_ sender: Any) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
