//
//  AllVideosAndPDFListingVC.swift
//  Gahir Agro
//
//  Created by Apple on 24/03/21.
//

import UIKit

class AllVideosAndPDFListingVC: UIViewController {

    @IBOutlet weak var listingTBView: UITableView!
    var allDataArray = [Media]()
    override func viewDidLoad() {
        super.viewDidLoad()
        print(allDataArray)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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

extension AllVideosAndPDFListingVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListingTBViewCell", for: indexPath) as! ListingTBViewCell
        if allDataArray[indexPath.row].type == .pdf{
            cell.showImage.image = UIImage(named: "video")
        }else{
            cell.showImage.image = UIImage(named: "video1")
        }
        cell.nameLbl.text = allDataArray[indexPath.row].url
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if allDataArray[indexPath.row].type == .pdf{
            let vc = PdfViewerVC.instantiate(fromAppStoryboard: .Main)
            vc.pdfUrl = allDataArray[indexPath.row].url ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = PlayVideoVC.instantiate(fromAppStoryboard: .Main)
            vc.videoUrl = allDataArray[indexPath.row].url ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
