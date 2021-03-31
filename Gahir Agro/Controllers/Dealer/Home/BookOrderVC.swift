//
//  BookOrderVC.swift
//  Gahir Agro
//
//  Created by Apple on 25/02/21.
//

import UIKit
import SDWebImage

class BookOrderVC: UIViewController {

    var enquiryID = String()
    var messgae = String()
    var name = String()
    var modelName = String()
    var amount = String()
    var quantity = String()
    var accessoriesName = String()
    var status = String()
    var image = String()
    
    @IBOutlet weak var showStatus: UILabel!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var showImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        quantityLbl.text = quantity
        showImage.sd_setImage(with: URL(string:image), placeholderImage: UIImage(named: "placeholder-img-logo (1)"), options: SDWebImageOptions.continueInBackground, completed: nil)
        titleLbl.text = name
        print(name)
    }
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
  
    @IBAction func bookOrderButton(_ sender: Any) {
        let vc = SubmitDetailsVC.instantiate(fromAppStoryboard: .Main)
        vc.enquiryID = enquiryID
        vc.name = name
        vc.quantity = quantity
        vc.amount = amount
        vc.accessoriesName = accessoriesName
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
