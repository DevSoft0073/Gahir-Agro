//
//  ProfileVC.swift
//  Gahir Agro
//
//  Created by Apple on 24/02/21.
//

import UIKit
import LGSideMenuController

class ProfileVC: UIViewController, CAAnimationDelegate {

    @IBOutlet weak var bioTxtView: UITextView!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var addressTxtFld: UITextField!
    @IBOutlet weak var emailtxtFld: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailtxtFld.isUserInteractionEnabled = false
        passwordTxtFld.isUserInteractionEnabled = false
        addressTxtFld.isUserInteractionEnabled = false

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = profileImage.frame.height/2
    }
    
    
    
    @IBAction func gotoEditProfile(_ sender: Any) {
        let vc = EditProfileVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func menuButton(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "SideMenuControllerID") as UIViewController
        let transition = CATransition.init()
        transition.duration = 0.45
        transition.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.default)
        transition.type = CATransitionType.push //Transition you want like Push, Reveal
        transition.subtype = CATransitionSubtype.fromLeft // Direction like Left to Right, Right to Left
        
        transition.delegate = self
        view.window!.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
}
