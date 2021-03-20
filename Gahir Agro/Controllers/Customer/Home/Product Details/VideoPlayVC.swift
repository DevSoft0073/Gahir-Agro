//
//  VideoPlayVC.swift
//  Gahir Agro
//
//  Created by Apple on 20/03/21.
//

import UIKit

class VideoPlayVC: UIViewController {

    
    var pdfAndVideoDataArray = [PdfANdVIdeoData]()
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var listingTBView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}

struct PdfANdVIdeoData {
    
    var image : String
    var name : String
    var details : String
    var url : String
    
     init(image: String, name: String, details: String, url: String) {
        self.image = image
        self.name = name
        self.details = details
        self.url = url
    }
}

class ListingTBViewCell: UITableViewCell {
    
    @IBOutlet weak var timeAndDetailLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var showImage: UIImageView!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
