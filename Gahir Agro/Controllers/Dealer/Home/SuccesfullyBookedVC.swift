//
//  SuccesfullyBookedVC.swift
//  Gahir Agro
//
//  Created by Apple on 25/02/21.
//

import UIKit
import SDWebImage

class SuccesfullyBookedVC: UIViewController {
    
    var productImage = String()
    var bookingId = String()
    var details = String()
    @IBOutlet weak var bookingIDLbl: UILabel!
    @IBOutlet weak var detailsLbl: UILabel!
    @IBOutlet weak var nameLBlb: UILabel!
    @IBOutlet weak var showImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        detailsLbl.text = details
        bookingIDLbl.text = bookingId
        showImage.sd_setImage(with: URL(string:productImage), placeholderImage: UIImage(named: "placeholder-img-logo (1)"), options: SDWebImageOptions.continueInBackground, completed: nil)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
