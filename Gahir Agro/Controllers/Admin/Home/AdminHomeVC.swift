//
//  AdminHomeVC.swift
//  Gahir Agro
//
//  Created by Apple on 17/03/21.
//

import UIKit
import LGSideMenuController

class AdminHomeVC: UIViewController {
    
    var page = 1
    var lastPage = Bool()
    var messgae = String()
    var enquiryID = [String]()
    var quantityArray = [String]()
    var accName = [String]()
    var latArray = [String]()
    var longArray = [String]()
    var dealerCode = [String]()
    var dealerName = [String]()
    var adminEnquriesArray = [OrderHistoryData]()
    @IBOutlet weak var enquriesTBView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllEnquries()
        // Do any additional setup after loading the view.
    }
    @IBAction func backButtonAction(_ sender: Any) {
        sideMenuController?.showLeftViewAnimated()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        adminEnquriesArray.removeAll()
        page = 1
        getAllEnquries()
    }
    
    func getAllEnquries() {
        PKWrapperClass.svprogressHudShow(title: Constant.shared.appTitle, view: self)
        let url = Constant.shared.baseUrl + Constant.shared.AllDealerEnquries
        var deviceID = UserDefaults.standard.value(forKey: "deviceToken") as? String
        let accessToken = UserDefaults.standard.value(forKey: "accessToken")
        print(deviceID ?? "")
        if deviceID == nil  {
            deviceID = "777"
        }
        let params = ["page_no": page,"access_token": accessToken]  as? [String : AnyObject] ?? [:]
        print(params)
        PKWrapperClass.requestPOSTWithFormData(url, params: params, imageData: []) { (response) in
            print(response.data)
            PKWrapperClass.svprogressHudDismiss(view: self)
            let status = response.data["status"] as? String ?? ""
            self.messgae = response.data["message"] as? String ?? ""
            self.lastPage = response.data[""] as? Bool ?? false
            if status == "1"{
                var newArr = [OrderHistoryData]()
                let allData = response.data["enquiry_list"] as? [String:Any] ?? [:]
                for obj in allData["all_enquiries"] as? [[String:Any]] ?? [[:]]{
                    print(obj)
                    let accessoriesData = obj["accessories"] as? [String:Any] ?? [:]
                    self.dealerCode.append(obj["enquiry_id"] as? String ?? "")
                    let dateValue = obj["creation_date"] as? String ?? ""
                    let dateVal = NumberFormatter().number(from: dateValue)?.doubleValue ?? 0.0
                    self.accName.append(accessoriesData["acc_name"] as? String ?? "")
                    let dealerData = obj["dealer_detail"] as? [String:Any] ?? [:]
                    self.getAddressFromLatLon(pdblLatitude: dealerData["user_lat"] as? String ?? "", withLongitude: dealerData["user_long"] as? String ?? "")
                    self.dealerName.append("\(dealerData["first_name"] as? String ?? "") " + "\(dealerData["last_name"] as? String ?? "")")
                    self.quantityArray.append(obj["qty"] as? String ?? "")
                    self.enquiryID.append(obj["enquiry_id"] as? String ?? "")
                    let productDetails = obj["product_detail"] as? [String:Any] ?? [:]
                    print(productDetails)
                    newArr.append(OrderHistoryData(name: productDetails["prod_name"] as? String ?? "", id: productDetails["id"] as? String ?? "", quantity: "\(productDetails["qty"] as? String ?? "")", deliveryDate: self.convertTimeStampToDate(dateVal: dateVal), price: "$\(productDetails["prod_price"] as? String ?? "")" as? String ?? "", image: productDetails["prod_image"] as? String ?? "", accName: self.accName, modelName: productDetails["prod_name"] as? String ?? "", enqID: self.enquiryID))
                }
                for i in 0..<newArr.count{
                    self.adminEnquriesArray.append(newArr[i])
                }
                self.enquriesTBView.reloadData()
            }else if status == "0"{
                PKWrapperClass.svprogressHudDismiss(view: self)
                //                alert(Constant.shared.appTitle, message: self.messgae, view: self)
            }else{
                UserDefaults.standard.removeObject(forKey: "tokenFString")
                let appDel = UIApplication.shared.delegate as! AppDelegate
                appDel.Logout1()
            }
        } failure: { (error) in
            print(error)
            PKWrapperClass.svprogressHudDismiss(view: self)
            showAlertMessage(title: Constant.shared.appTitle, message: error as? String ?? "", okButton: "Ok", controller: self, okHandler: nil)
        }
    }
}

class AdminEnquriesTBViewCell: UITableViewCell {
    
    @IBOutlet weak var idLbl: UILabel!
    @IBOutlet weak var timelbl: UILabel!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var pricveLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var showImage: UIImageView!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension AdminHomeVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adminEnquriesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdminEnquriesTBViewCell", for: indexPath) as! AdminEnquriesTBViewCell
        cell.idLbl.text = dealerCode[indexPath.row]
        cell.quantityLbl.text = dealerName[indexPath.row]
        cell.pricveLbl.text = adminEnquriesArray[indexPath.row].price
        cell.timelbl.text = adminEnquriesArray[indexPath.row].deliveryDate
        cell.nameLbl.text = adminEnquriesArray[indexPath.row].name
        cell.showImage.sd_setImage(with: URL(string:adminEnquriesArray[indexPath.row].image), placeholderImage: UIImage(named: "im"))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if lastPage == false{
            let bottamEdge = Float(self.enquriesTBView.contentOffset.y + self.enquriesTBView.frame.size.height)
            if bottamEdge >= Float(self.enquriesTBView.contentSize.height) && adminEnquriesArray.count > 0 {
                page = page + 1
                getAllEnquries()
            }
        }else{
            let bottamEdge = Float(self.enquriesTBView.contentOffset.y + self.enquriesTBView.frame.size.height)
            if bottamEdge >= Float(self.enquriesTBView.contentSize.height) && adminEnquriesArray.count > 0 {
            }
        }
    }
}


struct GetAddress {
    
    var city : String
    var address : String
    
    init(city : String , address : String) {
        self.city = city
        self.address = address
    }
}
