//
//  CustomerProductDetailsVC.swift
//  Gahir Agro
//
//  Created by Apple on 25/02/21.
//

import UIKit
import SDWebImage

class CustomerProductDetailsVC: UIViewController {
    
    
    var id = String()
    var messgae = String()
    var detailsDataArray = [DetailsData]()
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var quantitylbl: UILabel!
    @IBOutlet weak var modelDetails: UILabel!
    @IBOutlet weak var modelName: UILabel!
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var homeDataTBView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.productDetails()
        print(id)
        self.homeDataTBView.separatorStyle = .none
        // Do any additional setup after loading the view.
    }
    @IBAction func backButton(_ sender: Any) {
    }
    
    @IBAction func minusButton(_ sender: Any) {
    }
    @IBAction func addButton(_ sender: Any) {
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
        PKWrapperClass.requestPOSTWithFormData(url, params: params, imageData: []) { (response) in
            PKWrapperClass.svprogressHudDismiss(view: self)
            let status = response.data["status"] as? String ?? ""
            self.messgae = response.data["message"] as? String ?? ""
            self.detailsDataArray.removeAll()
            if status == "1"{
                let allData = response.data["product_detail"] as? [String:Any] ?? [:]
                print(allData)
                self.modelDetails.text = allData["prod_name"] as? String ?? ""
                self.modelName.text = "Model"
                self.showImage.sd_setImage(with: URL(string:allData["prod_image"] as? String ?? ""), placeholderImage: UIImage(named: "placeholder-img-logo (1)"), options: SDWebImageOptions.continueInBackground, completed: nil)
                let url = URL(string:allData["prod_image"] as? String ?? "")
                if url != nil{
                    if let data = try? Data(contentsOf: url!)
                    {
                        if let image: UIImage = (UIImage(data: data)){
                            self.showImage.image = image
                            self.showImage.contentMode = .scaleToFill
                            IJProgressView.shared.hideProgressView()
                        }
                    }
                }
                else{
                    self.showImage.image = UIImage(named: "placeholder-img-logo (1)")
                }
                let productDetails = allData["prod_desc"] as? [String] ?? [""]
                for product in productDetails{
                    let splittedProducts = product.split(separator: ":")
                    if splittedProducts.indices.contains(0) && splittedProducts.indices.contains(1){
//                        self.detailsDataArray.append(DetailsData(fieldData: splittedProducts[0], fieldName: String(splittedProducts[1])))
//                        print(self.detailsDataArray)
                    }
                    print("showing data\(splittedProducts)")
                }
                self.homeDataTBView.reloadData()
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

class HomeDataTBViewCell: UITableViewCell {
    
    @IBOutlet weak var dataLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}


extension CustomerProductDetailsVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailsDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeDataTBViewCell", for: indexPath) as! HomeDataTBViewCell
        cell.nameLbl.text = "\(detailsDataArray[indexPath.row].fieldData):"
        cell.dataLbl.text = "\(detailsDataArray[indexPath.row].fieldName)"
        DispatchQueue.main.async {
            self.heightConstraint.constant = self.homeDataTBView.contentSize.height
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        55
    }
    
}
