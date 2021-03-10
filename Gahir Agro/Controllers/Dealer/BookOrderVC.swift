//
//  BookOrderVC.swift
//  Gahir Agro
//
//  Created by Apple on 25/02/21.
//

import UIKit

class BookOrderVC: UIViewController {

    
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var showImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func backButton(_ sender: Any) {
        DispatchQueue.main.async {
            let story = UIStoryboard(name: "Main", bundle: nil)
            let rootViewController:UIViewController = story.instantiateViewController(withIdentifier: "SideMenuControllerID")
            self.navigationController?.pushViewController(rootViewController, animated: true)
        }
    }
    
  
    @IBAction func bookOrderButton(_ sender: Any) {
        let vc = SubmitDetailsVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
