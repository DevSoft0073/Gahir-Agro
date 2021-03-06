//
//  MyOrderVC.swift
//  Gahir Agro
//
//  Created by Apple on 24/02/21.
//

import UIKit
import LGSideMenuController

class MyOrderVC: UIViewController {

    
    var page = 1
    var lastPage = 1
    var messgae = String()
    @IBOutlet weak var myOrderTBView: UITableView!
    var orderHistoryArray = [OrderHistoryData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllEnquries()
        myOrderTBView.separatorStyle = .none
        // Do any additional setup after loading the view.
        orderHistoryArray.append(OrderHistoryData(name: "Product-1", id: "ID - 1233445", quantity: "3", deliveryDate: "24 Feb 2021", price: "$440.00", image: "im"))
        orderHistoryArray.append(OrderHistoryData(name: "Product-1", id: "ID - 1233445", quantity: "3", deliveryDate: "24 Feb 2021", price: "$440.00", image: "im"))
        orderHistoryArray.append(OrderHistoryData(name: "Product-1", id: "ID - 1233445", quantity: "3", deliveryDate: "24 Feb 2021", price: "$440.00", image: "im"))
        orderHistoryArray.append(OrderHistoryData(name: "Product-1", id: "ID - 1233445", quantity: "3", deliveryDate: "24 Feb 2021", price: "$440.00", image: "im"))
        orderHistoryArray.append(OrderHistoryData(name: "Product-1", id: "ID - 1233445", quantity: "3", deliveryDate: "24 Feb 2021", price: "$440.00", image: "im"))

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
        PKWrapperClass.requestPOSTWithFormData(url, params: params, imageData: [[:]]) { (response) in
            print(response.data)
            PKWrapperClass.svprogressHudDismiss(view: self)
            let status = response.data["status"] as? String ?? ""
            self.messgae = response.data["message"] as? String ?? ""
            if status == "1"{
                var newArr = [OrderHistoryData]()
                let allData = response.data["product_list"] as? [String:Any] ?? [:]
                for obj in allData["all_products"] as? [[String:Any]] ?? [[:]] {
                    print(obj)
                }
                for i in 0..<newArr.count{
                    self.orderHistoryArray.append(newArr[i])
                }
                self.myOrderTBView.reloadData()
            }else if status == "0"{
                PKWrapperClass.svprogressHudDismiss(view: self)
                alert(Constant.shared.appTitle, message: self.messgae, view: self)
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

    
    @IBAction func openMenu(_ sender: Any) {
        sideMenuController?.showLeftViewAnimated()

    }
}

class MyOrderTBViewCell: UITableViewCell {
    
    
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var reorderbutton: UIButton!
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
        cell.priceLbl.text = orderHistoryArray[indexPath.section].price
        cell.timeLbl.text = orderHistoryArray[indexPath.section].deliveryDate
        cell.quantityLbl.text = orderHistoryArray[indexPath.section].quantity
//        cell.priceLbl.text = orderHistoryArray[indexPath.section].price
        cell.showImage.image = UIImage(named: orderHistoryArray[indexPath.section].image)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if page <= lastPage{
            let bottamEdge = Float(self.myOrderTBView.contentOffset.y + self.myOrderTBView.frame.size.height)
            if bottamEdge >= Float(self.myOrderTBView.contentSize.height) && orderHistoryArray.count > 0 {
                page = page + 1
                getAllEnquries()
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
    
    init(name : String , id : String , quantity : String , deliveryDate : String , price : String , image : String) {
        self.name = name
        self.id = id
        self.quantity = quantity
        self.deliveryDate = deliveryDate
        self.price = price
        self.image = image
    }
}
