//
//  AdminEnquriesVC.swift
//  Gahir Agro
//
//  Created by Apple on 17/03/21.
//

import UIKit

class AdminEnquriesVC: UIViewController {

    var page = 1
    var lastPage = 1
    var messgae = String()
    var enquiryID = [String]()
    var quantityArray = [String]()
    var accName = String()
    var dealerCode = String()
    var dealerName = String()
    var adminOrderArray = [OrderHistoryData]()
    @IBOutlet weak var orderTBView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllOrder()
        // Do any additional setup after loading the view.
    }
    @IBAction func openMenuButton(_ sender: Any) {
        sideMenuController?.showLeftViewAnimated()
    }
    
    func getAllOrder() {
        PKWrapperClass.svprogressHudShow(title: Constant.shared.appTitle, view: self)
        let url = Constant.shared.baseUrl + Constant.shared.AllDealerOrder
        var deviceID = UserDefaults.standard.value(forKey: "deviceToken") as? String
        let accessToken = UserDefaults.standard.value(forKey: "accessToken")
        print(deviceID ?? "")
        if deviceID == nil  {
            deviceID = "777"
        }
        let params = ["page_no": page,"access_token": accessToken]  as? [String : AnyObject] ?? [:]
        print(params)
        PKWrapperClass.requestPOSTWithFormData(url, params: params, imageData: [[:]]) { (response) in
            print(response.data)
            PKWrapperClass.svprogressHudDismiss(view: self)
            let status = response.data["status"] as? String ?? ""
            self.messgae = response.data["message"] as? String ?? ""
            if status == "1"{
                self.adminOrderArray.removeAll()
                var newArr = [OrderHistoryData]()
                let allData = response.data["order_list"] as? [String:Any] ?? [:]
                for obj in allData["all_orders"] as? [[String:Any]] ?? [[:]]{
                    var accessoriesData = obj["accessories"] as? [String:Any] ?? [:]
                    self.accName = accessoriesData["acc_name"] as? String ?? ""
                    self.quantityArray.append(obj["qty"] as? String ?? "")
                    self.enquiryID.append(obj["enquiry_id"] as? String ?? "")
                    self.dealerCode = obj["dealer_code"] as? String ?? ""
                    let dealerData = obj["dealer_detail"] as? [String:Any] ?? [:]
                    self.dealerName = "\(dealerData["first_name"] as? String ?? "") " + "\(dealerData["last_name"] as? String ?? "")"
                    let allEnquiryData = obj["enquiry_detail"] as? [String:Any] ?? [:]
                    for newObj in allEnquiryData["product_detail"] as? [[String:Any]] ?? [[:]] {
                        print(newObj)
                        newArr.append(OrderHistoryData(name: allEnquiryData["prod_name"] as? String ?? "", id: allEnquiryData["id"] as? String ?? "", quantity: "\(allEnquiryData["qty"] as? String ?? "")", deliveryDate: allEnquiryData["24 Feb 2021"] as? String ?? "24 Feb 2021", price: "$\(allEnquiryData["prod_price"] as? String ?? "").00" as? String ?? "", image: allEnquiryData["prod_image"] as? String ?? ""))
                    }
                }
                for i in 0..<newArr.count{
                    self.adminOrderArray.append(newArr[i])
                }
                self.orderTBView.reloadData()
            }else if status == "0"{
                PKWrapperClass.svprogressHudDismiss(view: self)
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

class AdminOrderTBViewCell: UITableViewCell {
    
    @IBOutlet weak var productId: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var quantitylbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var showImage: UIImageView!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}


extension AdminEnquriesVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adminOrderArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdminOrderTBViewCell", for: indexPath) as! AdminOrderTBViewCell
        cell.productId.text = dealerCode
        cell.quantitylbl.text = dealerName
        cell.priceLbl.text = adminOrderArray[indexPath.row].price
        cell.dateLbl.text = adminOrderArray[indexPath.row].deliveryDate
        cell.nameLbl.text = adminOrderArray[indexPath.row].name
        cell.showImage.sd_setImage(with: URL(string:adminOrderArray[indexPath.row].image), placeholderImage: UIImage(named: "im"))

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = SubmitDetailsVC.instantiate(fromAppStoryboard: .Main)
//        vc.enquiryID = enquiryID[indexPath.row]
//        vc.name = adminEnquriesArray[indexPath.row].name
//        vc.quantity = quantityArray[indexPath.row]
//        vc.amount = adminEnquriesArray[indexPath.row].price
//        vc.accessoriesName = self.accName
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if page <= lastPage{
            let bottamEdge = Float(self.orderTBView.contentOffset.y + self.orderTBView.frame.size.height)
            if bottamEdge >= Float(self.orderTBView.contentSize.height) && adminOrderArray.count > 0 {
                page = page + 1
                getAllOrder()
            }
        }
    }
    
}
