//
//  EnquriesVC.swift
//  Gahir Agro
//
//  Created by Apple on 16/03/21.
//

import UIKit
import LGSideMenuController
import SDWebImage

class EnquriesVC: UIViewController {
    
    var page = 1
    var lastPage = Bool()
    var messgae = String()
    var enquiryID = [String]()
    var quantityArray = [String]()
    var accName = String()
    var dispatchDateArray = [String]()
    var amountArray = [String]()
    var totalArray = [String]()
    var bookingIDArray = [String]()
    var orderIDArray = [String]()
    var enquriesDataFroDealerArray = [EnquriesDataFroDealer]()
    @IBOutlet weak var enquiryTBView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()        
        enquiryTBView.separatorStyle = .none
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func openMenuButton(_ sender: Any) {
        sideMenuController?.showLeftViewAnimated()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dispatchDateArray.removeAll()
        enquriesDataFroDealerArray.removeAll()
        page = 1
        getAllEnquries()
    }
    
    
    func getAllEnquries() {
        PKWrapperClass.svprogressHudShow(title: Constant.shared.appTitle, view: self)
        let url = Constant.shared.baseUrl + Constant.shared.AllOrders
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
            if status == "1"{
                self.amountArray.removeAll()
                var newArr = [EnquriesDataFroDealer]()
                let allData = response.data["order_list"] as? [String:Any] ?? [:]
                for obj in allData["all_orders"] as? [[String:Any]] ?? [[:]]{
                    print(obj)
                    self.orderIDArray.append(obj["id"] as? String ?? "")
                    self.bookingIDArray.append(obj["booking_id"] as? String ?? "")
                    let allDetails = obj["enquiry_detail"] as? [String:Any] ?? [:]
                    self.dispatchDateArray.append(allDetails["dispatch_day"] as? String ?? "")
                    self.totalArray.append(allDetails["total"] as! String) as? Any ?? ""
                    let dateValue = allDetails["creation_date"] as? String ?? ""
                    let dateVal = NumberFormatter().number(from: dateValue)?.doubleValue ?? 0.0
                    let productDetails = allDetails["product_detail"] as? [String:Any] ?? [:]
                    let accessoriesData = productDetails["accessories"] as? [[String:Any]] ?? [[:]]
                    for obj in accessoriesData{
                        self.accName = obj["acc_name"] as? String ?? ""
                    }
                    self.quantityArray.append(allDetails["qty"] as? String ?? "")
                    self.enquiryID.append(obj["enquiry_id"] as? String ?? "")
                    newArr.append(EnquriesDataFroDealer(name: productDetails["prod_name"] as? String ?? "", id: productDetails["id"] as? String ?? "", quantity: "\(productDetails["qty"] as? String ?? "")", deliveryDate: self.convertTimeStampToDate(dateVal: dateVal), price: "\(productDetails["prod_price"] as? String ?? "")" as? String ?? "", image: productDetails["prod_image"] as? String ?? "", bookingID: self.bookingIDArray, orderID: self.orderIDArray))
                    self.amountArray.append("$\(productDetails["prod_price"] as? String ?? "")")
                    
                }
                for i in 0..<newArr.count{
                    self.enquriesDataFroDealerArray.append(newArr[i])
                }
                self.enquiryTBView.reloadData()
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

class EnquiryTBViewCell: UITableViewCell {
    
    @IBOutlet weak var idLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var showImage: UIImageView!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension EnquriesVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return enquriesDataFroDealerArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EnquiryTBViewCell", for: indexPath) as! EnquiryTBViewCell
        cell.idLbl.text = enquriesDataFroDealerArray[indexPath.row].orderID[indexPath.row]
        cell.dateLbl.text = dispatchDateArray[indexPath.row]
        cell.quantityLbl.text = quantityArray[indexPath.row]
        cell.nameLbl.text = enquriesDataFroDealerArray[indexPath.row].name
        cell.priceLbl.text = "₹\(totalArray[indexPath.row])"
        cell.showImage.sd_setImage(with: URL(string:enquriesDataFroDealerArray[indexPath.row].image), placeholderImage: UIImage(named: "placeholder-img-logo (1)"), options: SDWebImageOptions.continueInBackground, completed: nil)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = SuccesfullyBookedVC.instantiate(fromAppStoryboard: .Main)
        vc.productImage = enquriesDataFroDealerArray[indexPath.row].image
        vc.details = enquriesDataFroDealerArray[indexPath.row].name
        vc.bookingId = self.bookingIDArray[indexPath.row]
        vc.orderID = self.orderIDArray[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if lastPage == false{
            let bottamEdge = Float(self.enquiryTBView.contentOffset.y + self.enquiryTBView.frame.size.height)
            if bottamEdge >= Float(self.enquiryTBView.contentSize.height) && enquriesDataFroDealerArray.count > 0 {
                page = page + 1
                getAllEnquries()
            }
        }else{
            let bottamEdge = Float(self.enquiryTBView.contentOffset.y + self.enquiryTBView.frame.size.height)
            if bottamEdge >= Float(self.enquiryTBView.contentSize.height) && enquriesDataFroDealerArray.count > 0 {
            }
        }
    }
}



struct EnquriesDataFroDealer {
    var name : String
    var id : String
    var quantity : String
    var deliveryDate : String
    var price : String
    var image : String
    var bookingID : [String]
    var orderID : [String]
    
    init(name : String , id : String , quantity : String , deliveryDate : String , price : String , image : String,bookingID : [String],orderID : [String]) {
        self.name = name
        self.id = id
        self.quantity = quantity
        self.deliveryDate = deliveryDate
        self.price = price
        self.image = image
        self.bookingID = bookingID
        self.orderID = orderID
    }
}
