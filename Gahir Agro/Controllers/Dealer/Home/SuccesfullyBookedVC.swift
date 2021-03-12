//
//  SuccesfullyBookedVC.swift
//  Gahir Agro
//
//  Created by Apple on 25/02/21.
//

import UIKit

class SuccesfullyBookedVC: UIViewController {

    @IBOutlet weak var detailsLbl: UILabel!
    @IBOutlet weak var nameLBlb: UILabel!
    @IBOutlet weak var showImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButton(_ sender: Any) {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController:UIViewController = story.instantiateViewController(withIdentifier: "SideMenuControllerID")
        self.navigationController?.pushViewController(rootViewController, animated: true)
    }
}
