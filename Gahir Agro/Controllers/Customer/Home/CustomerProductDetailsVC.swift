//
//  CustomerProductDetailsVC.swift
//  Gahir Agro
//
//  Created by Apple on 25/02/21.
//

import UIKit

class CustomerProductDetailsVC: UIViewController {
    
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var quantitylbl: UILabel!
    @IBOutlet weak var modelDetails: UILabel!
    @IBOutlet weak var modelName: UILabel!
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var homeDataTBView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func backButton(_ sender: Any) {
    }
    
    @IBAction func minusButton(_ sender: Any) {
    }
    @IBAction func addButton(_ sender: Any) {
    }
}

class HomeDataTBViewCell: UITableViewCell {
    
    @IBOutlet weak var dataLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
