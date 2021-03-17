//
//  ProductDetailsVC.swift
//  Gahir Agro
//
//  Created by Apple on 23/02/21.
//

import UIKit

class ProductDetailsVC: UIViewController {

    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var productDetailsTBView: UITableView!
    @IBOutlet weak var modelLbl: UILabel!
    @IBOutlet weak var namelbl: UILabel!
    @IBOutlet weak var showImage: UIImageView!
    var detailsDataArray = [DetailsData]()
    var messgae = String()
    var id = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.productDetails()
        print(id)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
            PKWrapperClass.svprogressHudDismiss(view: self)
            let status = response.data["status"] as? String ?? ""
            self.messgae = response.data["message"] as? String ?? ""
            self.detailsDataArray.removeAll()
            if status == "1"{
                let allData = response.data["product_detail"] as? [String:Any] ?? [:]
                print(allData)
                self.modelLbl.text = allData["prod_name"] as? String ?? ""
                self.namelbl.text = "Model"
                self.showImage.sd_setImage(with: URL(string:allData["prod_image"] as? String ?? ""), placeholderImage: UIImage(named: "placeholder-img-logo (1)"))
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
                        self.detailsDataArray.append(DetailsData(fieldData: splittedProducts[0], fieldName: String(splittedProducts[1])))
                        print(self.detailsDataArray)
                    }
                    print("showing data\(splittedProducts)")
                }
                self.productDetailsTBView.reloadData()
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

class ProductDetailsTBViewCell: UITableViewCell {
    
    @IBOutlet weak var dataLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}




extension ProductDetailsVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailsDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailsTBViewCell", for: indexPath) as! ProductDetailsTBViewCell
        cell.nameLbl.text = "\(detailsDataArray[indexPath.row].fieldData):"
        cell.dataLbl.text = "\(detailsDataArray[indexPath.row].fieldName)"
        DispatchQueue.main.async {
            self.heightConstraint.constant = self.productDetailsTBView.contentSize.height
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        55
    }
    
}

struct DetailsData {
    var fieldName : String
    var fieldData : Any
    
    init(fieldData : Any,fieldName : String) {
        self.fieldData = fieldData
        self.fieldName = fieldName
    }
}
