//
//  ProductDetailsVC.swift
//  Gahir Agro
//
//  Created by Apple on 23/02/21.
//

import UIKit

class ProductDetailsVC: UIViewController {

    @IBOutlet weak var grainTankLbl: UILabel!
    @IBOutlet weak var thresherLbl: UILabel!
    @IBOutlet weak var cuttingCapacityLbl: UILabel!
    @IBOutlet weak var drumDiaLbl: UILabel!
    @IBOutlet weak var numberOfStrawlbl: UILabel!
    @IBOutlet weak var hpRequiredLbl: UILabel!
    @IBOutlet weak var heightOfCutMin: UILabel!
    @IBOutlet weak var heightOfCutMaxLbl: UILabel!
    @IBOutlet weak var widthOfCutLbl: UILabel!
    @IBOutlet weak var chassisNoLbl: UILabel!
    @IBOutlet weak var detailsLbl: UILabel!
    @IBOutlet weak var modelLbl: UILabel!
    @IBOutlet weak var namelbl: UILabel!
    @IBOutlet weak var showImage: UIImageView!
    var detailsDataArray = [DetailsData]()
    var messgae = String()
    var id = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        productDetails()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func enquiryButtonVc(_ sender: Any) {
        let vc = EnquiryVC.instantiate(fromAppStoryboard: .Main)
        vc.id = self.id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func productDetails() {
        PKWrapperClass.svprogressHudShow(title: Constant.shared.appTitle, view: self)
        let url = Constant.shared.baseUrl + Constant.shared.ProductDetails
        var deviceID = UserDefaults.standard.value(forKey: "deviceToken") as? String
        let accessToken = UserDefaults.standard.value(forKey: "accessToken")
        print(deviceID ?? "")
        if deviceID == nil  {
            deviceID = "777"
        }
        let params = ["id": id,"access_token": accessToken]  as? [String : AnyObject] ?? [:]
        print(params)
        PKWrapperClass.requestPOSTWithFormData(url, params: params, imageData: [[:]]) { (response) in
            print(response.data)
            PKWrapperClass.svprogressHudDismiss(view: self)
            let status = response.data["status"] as? String ?? ""
            self.messgae = response.data["message"] as? String ?? ""
            if status == "1"{
                let allData = response.data["product_detail"] as? [String:Any] ?? [:]
                print(allData)
//                self.chassisNoLbl.text = allData["Chassis"] as? String
//                self.widthOfCutLbl.text = allData["Cutting Width"] as? String
//                self.heightOfCutMaxLbl.text = allData["Chassis"] as? String
//                self.chassisNoLbl.text = allData["Chassis"] as? String
//                self.chassisNoLbl.text = allData["Chassis"] as? String
//                self.chassisNoLbl.text = allData["Chassis"] as? String
//                self.chassisNoLbl.text = allData["Chassis"] as? String
//                self.chassisNoLbl.text = allData["Chassis"] as? String
//                self.chassisNoLbl.text = allData["Chassis"] as? String
            }else{
                PKWrapperClass.svprogressHudDismiss(view: self)
                alert(Constant.shared.appTitle, message: self.messgae, view: self)
            }
        } failure: { (error) in
            print(error)
            showAlertMessage(title: Constant.shared.appTitle, message: error as? String ?? "", okButton: "Ok", controller: self, okHandler: nil)
        }
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
