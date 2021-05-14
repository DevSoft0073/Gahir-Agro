//
//  MyOrderVC.swift
//  Gahir Agro
//
//  Created by Apple on 24/02/21.
//

import UIKit
import LGSideMenuController
import SDWebImage

class MyOrderVC: UIViewController {
    
    
    var page = 1
    var lastPage = Bool()
    var messgae = String()
    var enquiryID = [String]()
    var quantityArray = [String]()
    var accName = [String]()
    var amountArray = [String]()
    var dateArray = [Any]()
    var totalArray = [String]()
    var orderStatus = [String]()
    var enqArray = [String]()
    @IBOutlet weak var myOrderTBView: UITableView!
    var orderHistoryArray = [OrderHistoryData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myOrderTBView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        orderHistoryArray.removeAll()
        page = 1
        getAllEnquries()
    }
    
    func getAllEnquries() {
        PKWrapperClass.svprogressHudShow(title: Constant.shared.appTitle, view: self)
        let url = Constant.shared.baseUrl + Constant.shared.EnquiryListing
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
            self.lastPage = response.data["last_page"] as? Bool ?? false
            if status == "1"{
                self.amountArray.removeAll()
                var newArr = [OrderHistoryData]()
                let allData = response.data["enquiry_list"] as? [String:Any] ?? [:]
                for obj in allData["all_enquiries"] as? [[String:Any]] ?? [[:]]{
                    let dateValue = obj["creation_date"] as? String ?? ""
                    let dateVal = NumberFormatter().number(from: dateValue)?.doubleValue ?? 0.0
                    self.convertTimeStampToDate(dateVal: dateVal)
                    self.enqArray.append(obj["enquiry_id"] as? String ?? "")
                    let accessoriesData = obj["accessories"] as? [String:Any] ?? [:]
                    self.accName.append(accessoriesData["acc_name"] as? String ?? "")
                    self.quantityArray.append(obj["qty"] as? String ?? "")
                    self.enquiryID.append(obj["enquiry_id"] as? String ?? "")
                    self.totalArray.append(obj["total"] as! String) as? Any ?? ""
                    self.orderStatus.append(obj["status"] as! String as? String ?? "")
                    let productDetails = obj["product_detail"] as? [String:Any] ?? [:]
                    print(productDetails)
                    newArr.append(OrderHistoryData(name: productDetails["prod_name"] as? String ?? "", id: productDetails["id"] as? String ?? "", quantity: "\(productDetails["qty"] as? String ?? "")", deliveryDate: self.convertTimeStampToDate(dateVal: dateVal), price: "\(productDetails["prod_price"] as? String ?? "")" as? String ?? "", image: productDetails["prod_image"] as? String ?? "", accName: self.accName, modelName: productDetails["prod_model"] as? String ?? "", enqID: self.enqArray))
                    self.amountArray.append("$\(productDetails["prod_price"] as? String ?? "")")
                }
                for i in 0..<newArr.count{
                    self.orderHistoryArray.append(newArr[i])
                }
                self.myOrderTBView.reloadData()
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
    
    @IBAction func openMenu(_ sender: Any) {
        sideMenuController?.showLeftViewAnimated()
        
    }
}

class MyOrderTBViewCell: UITableViewCell {
    
    @IBOutlet weak var productID: UILabel!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var idLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var showImage: UIImageView!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension MyOrderVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderHistoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrderTBViewCell", for: indexPath) as! MyOrderTBViewCell
        cell.idLbl.text = orderHistoryArray[indexPath.row].enqID[indexPath.row]
        cell.timeLbl.text = orderHistoryArray[indexPath.row].deliveryDate
        cell.quantityLbl.text = quantityArray[indexPath.row]
        cell.nameLbl.text = orderHistoryArray[indexPath.row].name
        cell.priceLbl.text = "₹\(totalArray[indexPath.row])"
        cell.showImage.sd_setImage(with: URL(string:orderHistoryArray[indexPath.row].image), placeholderImage: UIImage(named: "placeholder-img-logo (1)"))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = BookOrderVC.instantiate(fromAppStoryboard: .Main)
        vc.enquiryID = orderHistoryArray[indexPath.row].enqID[indexPath.row]
        vc.name = orderHistoryArray[indexPath.row].name
        vc.quantity = quantityArray[indexPath.row]
        vc.amount = orderHistoryArray[indexPath.row].price
        vc.image = orderHistoryArray[indexPath.row].image
        vc.accessoriesName = orderHistoryArray[indexPath.row].accName[indexPath.row]
        //vc.status = orderStatus[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if lastPage == false{
            let bottamEdge = Float(self.myOrderTBView.contentOffset.y + self.myOrderTBView.frame.size.height)
            if bottamEdge >= Float(self.myOrderTBView.contentSize.height) && orderHistoryArray.count > 0 {
                page = page + 1
                getAllEnquries()
            }
        }else{
            let bottamEdge = Float(self.myOrderTBView.contentOffset.y + self.myOrderTBView.frame.size.height)
            if bottamEdge >= Float(self.myOrderTBView.contentSize.height) && orderHistoryArray.count > 0 {
            }
        }
    }
}

struct OrderHistoryData {
    var name : String
    var id : String
    var quantity : String
    var deliveryDate : String
    var price : String
    var image : String
    var modelName : String
    var accName : [String]
    var enqID : [String]
    
    init(name : String , id : String , quantity : String , deliveryDate : String , price : String , image : String,accName : [String],modelName : String,enqID : [String]) {
        self.name = name
        self.id = id
        self.quantity = quantity
        self.deliveryDate = deliveryDate
        self.price = price
        self.image = image
        self.accName = accName
        self.modelName = modelName
        self.enqID = enqID
    }
}

extension String {
    var numberValue:NSNumber? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        return formatter.number(from: self)
    }
}
