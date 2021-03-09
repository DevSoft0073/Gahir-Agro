//
//  SubmitDetailsVC.swift
//  Gahir Agro
//
//  Created by Apple on 09/03/21.
//

import UIKit

class SubmitDetailsVC: UIViewController {

    @IBOutlet weak var utrNumberTxtFld: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func submitButtonAction(_ sender: Any) {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController:UIViewController = story.instantiateViewController(withIdentifier: "SideMenuControllerID")
        self.navigationController?.pushViewController(rootViewController, animated: true)
    }
}
