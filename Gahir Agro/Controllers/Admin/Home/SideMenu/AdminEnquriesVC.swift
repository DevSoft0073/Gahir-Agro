//
//  AdminEnquriesVC.swift
//  Gahir Agro
//
//  Created by Apple on 17/03/21.
//

import UIKit

class AdminEnquriesVC: UIViewController {
    
    var page = 1
    var orderID = String()
    var lastPage = Bool()
    var messgae = String()
    var enquiryID = [String]()
    var quantityArray = [String]()
    var dealerCode = [String]()
    var dealerName = [String]()
    var accName = [String]()
    var bookingIDArray = [String]()
    var orderIDArray = [String]()
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
    
    override func viewWillAppear(_ animated: Bool) {
        adminOrderArray.removeAll()
        page = 1
        getAllOrder()
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
        PKWrapperClass.requestPOSTWithFormData(url, params: params, imageData: []) { (response) in
            print(response.data)
            PKWrapperClass.svprogressHudDismiss(view: self)
            let status = response.data["status"] as? String ?? ""
            self.messgae = response.data["message"] as? String ?? ""
            self.lastPage = response.data[""] as? Bool ?? false
            if status == "1"{
                var newArr = [OrderHistoryData]()
                let allData = response.data["order_list"] as? [String:Any] ?? [:]
                for obj in allData["all_orders"] as? [[String:Any]] ?? [[:]]{
                    let accessoriesData = obj["accessories"] as? [String:Any] ?? [:]
                    let dateValue = obj["creation_date"] as? String ?? ""
                    let dateVal = NumberFormatter().number(from: dateValue)?.doubleValue ?? 0.0
                    self.accName.append(accessoriesData["acc_name"] as? String ?? "")
                    self.quantityArray.append(obj["qty"] as? String ?? "")
                    self.bookingIDArray.append(obj["booking_id"] as? String ?? "")
                    self.enquiryID.append(obj["enquiry_id"] as? String ?? "")
                    self.dealerCode.append(obj["dealer_code"] as? String ?? "")
                    let dealerData = obj["dealer_detail"] as? [String:Any] ?? [:]
                    self.dealerName.append("\(dealerData["first_name"] as? String ?? "") " + "\(dealerData["last_name"] as? String ?? "")")
                    let allEnquiryData = obj["enquiry_detail"] as? [String:Any] ?? [:]
                    let newObj = allEnquiryData["product_detail"]  as? [String:Any] ?? [:]
                    self.orderIDArray.append(newObj["id"] as? String ?? "")
                    print(newObj)
                    newArr.append(OrderHistoryData(name: allEnquiryData["prod_name"] as? String ?? "", id: allEnquiryData["id"] as? String ?? "", quantity: "\(allEnquiryData["qty"] as? String ?? "")", deliveryDate: self.convertTimeStampToDate(dateVal: dateVal), price: "$\(allEnquiryData["total"] as? String ?? "")" as? String ?? "", image: newObj["prod_image"] as? String ?? "", accName: self.accName, modelName: allEnquiryData["prod_name"] as? String ?? "", enqID: self.enquiryID))
                }
                for i in 0..<newArr.count{
                    self.adminOrderArray.append(newArr[i])
                }
                self.orderTBView.reloadData()
            }else if status == "0"{
                PKWrapperClass.svprogressHudDismiss(view: self)
                alert(Constant.shared.appTitle, message: self.messgae, view: self)
            } else if status == "100"{
                showAlertMessage(title: Constant.shared.appTitle, message: self.messgae, okButton: "Ok", controller: self) {
                    UserDefaults.standard.removeObject(forKey: "tokenFString")
                    let appDel = UIApplication.shared.delegate as! AppDelegate
                    appDel.Logout1()
                }
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
        cell.productId.text = adminOrderArray[indexPath.row].deliveryDate
        cell.quantitylbl.text = orderIDArray[indexPath.row]
        cell.priceLbl.text = adminOrderArray[indexPath.row].price
        cell.dateLbl.text = adminOrderArray[indexPath.row].quantity
        cell.nameLbl.text = adminOrderArray[indexPath.row].name
        cell.showImage.sd_setImage(with: URL(string:adminOrderArray[indexPath.row].image), placeholderImage: UIImage(named: "im"))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = AdminOrderDetailsVC.instantiate(fromAppStoryboard: .AdminMain)
        vc.orderID = self.orderIDArray[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if lastPage == false{
            let bottamEdge = Float(self.orderTBView.contentOffset.y + self.orderTBView.frame.size.height)
            if bottamEdge >= Float(self.orderTBView.contentSize.height) && adminOrderArray.count > 0 {
                page = page + 1
                getAllOrder()
            }
        }else{
            let bottamEdge = Float(self.orderTBView.contentOffset.y + self.orderTBView.frame.size.height)
            if bottamEdge >= Float(self.orderTBView.contentSize.height) && adminOrderArray.count > 0 {
            }
        }
    }
}
