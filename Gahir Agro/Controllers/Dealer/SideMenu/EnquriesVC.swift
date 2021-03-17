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
    var lastPage = 1
    var messgae = String()
    var enquiryID = [String]()
    var quantityArray = [String]()
    var accName = String()
    var amountArray = [String]()

    var enquriesDataFroDealerArray = [EnquriesDataFroDealer]()
    @IBOutlet weak var enquiryTBView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAllEnquries()
        enquiryTBView.separatorStyle = .none

        // Do any additional setup after loading the view.
    }
    
    @IBAction func openMenuButton(_ sender: Any) {
        sideMenuController?.showLeftViewAnimated()
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
                self.enquriesDataFroDealerArray.removeAll()
                self.amountArray.removeAll()
                var newArr = [EnquriesDataFroDealer]()
                let allData = response.data["enquiry_list"] as? [String:Any] ?? [:]
                for obj in allData["all_enquiries"] as? [[String:Any]] ?? [[:]]{
                    print(obj)
                    var accessoriesData = obj["accessories"] as? [String:Any] ?? [:]
                    self.accName = accessoriesData["acc_name"] as? String ?? ""
                    self.quantityArray.append(obj["qty"] as? String ?? "")
                    self.enquiryID.append(obj["enquiry_id"] as? String ?? "")
                    let productDetails = obj["product_detail"] as? [String:Any] ?? [:]
                    print(productDetails)
                    newArr.append(EnquriesDataFroDealer(name: productDetails["prod_name"] as? String ?? "", id: productDetails["id"] as? String ?? "", quantity: "\(productDetails["qty"] as? String ?? "")", deliveryDate: productDetails["24 Feb 2021"] as? String ?? "24 Feb 2021", price: "\(productDetails["prod_price"] as? String ?? "")" as? String ?? "", image: productDetails["prod_image"] as? String ?? ""))
                    self.amountArray.append("$\(productDetails["prod_price"] as? String ?? "")")

                }
                for i in 0..<newArr.count{
                    self.enquriesDataFroDealerArray.append(newArr[i])
                }
                self.enquiryTBView.reloadData()
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
        cell.idLbl.text = enquriesDataFroDealerArray[indexPath.row].id
        cell.dateLbl.text = enquriesDataFroDealerArray[indexPath.row].deliveryDate
        cell.quantityLbl.text = enquriesDataFroDealerArray[indexPath.row].quantity
        cell.nameLbl.text = enquriesDataFroDealerArray[indexPath.row].name
        cell.priceLbl.text = amountArray[indexPath.row]
        cell.showImage.sd_setImage(with: URL(string:enquriesDataFroDealerArray[indexPath.row].image), placeholderImage: UIImage(named: "placeholder-img-logo (1)"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = SubmitDetailsVC.instantiate(fromAppStoryboard: .Main)
        vc.enquiryID = enquiryID[indexPath.row]
        vc.name = enquriesDataFroDealerArray[indexPath.row].name
        vc.quantity = quantityArray[indexPath.row]
        vc.amount = enquriesDataFroDealerArray[indexPath.row].price
        vc.accessoriesName = self.accName
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if page <= lastPage{
            let bottamEdge = Float(self.enquiryTBView.contentOffset.y + self.enquiryTBView.frame.size.height)
            if bottamEdge >= Float(self.enquiryTBView.contentSize.height) && enquriesDataFroDealerArray.count > 0 {
                page = page + 1
                getAllEnquries()
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
    
    init(name : String , id : String , quantity : String , deliveryDate : String , price : String , image : String) {
        self.name = name
        self.id = id
        self.quantity = quantity
        self.deliveryDate = deliveryDate
        self.price = price
        self.image = image
    }
}
