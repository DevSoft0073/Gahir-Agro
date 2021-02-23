//
//  ProductDetailsVC.swift
//  Gahir Agro
//
//  Created by Apple on 23/02/21.
//

import UIKit

class ProductDetailsVC: UIViewController {

    
    var detailsDataArray = [DetailsData]()
    @IBOutlet weak var detailsTBView: UITableView!
    @IBOutlet weak var detailsLbl: UILabel!
    @IBOutlet weak var modelLbl: UILabel!
    @IBOutlet weak var namelbl: UILabel!
    @IBOutlet weak var showImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func increaseQuantityButton(_ sender: Any) {
    }
    
    @IBAction func decreaseQuantityButton(_ sender: Any) {
    }
    

    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

class DetailsTBViewCell: UITableViewCell {
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension ProductDetailsVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailsDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsTBViewCell", for: indexPath) as! DetailsTBViewCell
        return cell
    }
    
    
}

struct DetailsData {
    var fieldData : String
    
    init(fieldData : String) {
        self.fieldData = fieldData
    }
}
