//
//  HomeVC.swift
//  Gahir Agro
//
//  Created by Apple on 23/02/21.
//

import UIKit
import LGSideMenuController
import SDWebImage

class HomeVC: UIViewController,UITextFieldDelegate {
    
    var filterProDArray = [FilterProductData]()
    var page = 1
    var lastPage = String()
    var productType = String()
    var messgae = String()
    var timer: Timer?
    var currentIndex = String()
    var buttonTitle = String()
    var id = String()
    @IBOutlet weak var allItemsTBView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        allItemsTBView.separatorStyle = .none
        buttonTitle = UserDefaults.standard.value(forKey: "checkRole") as? String ?? ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        filterProDArray.removeAll()
        filterdData()
        page = 1
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(updateLocationApi), userInfo: nil, repeats: true)
    }
    
    @objc func updateLocationApi(){
        updateUserLocationApi()
    }
    
//    MARK:- Service Call Methods
    
    func updateUserLocationApi(){
        let url = Constant.shared.baseUrl + Constant.shared.UpdateLocation
        var deviceID = UserDefaults.standard.value(forKey: "deviceToken") as? String
        let accessToken = UserDefaults.standard.value(forKey: "accessToken")
        print(deviceID ?? "")
        if deviceID == nil  {
            deviceID = "777"
        }
        let params = ["access_token": accessToken , "lat" : Singleton.sharedInstance.lat , "long" : Singleton.sharedInstance.long]  as? [String : AnyObject] ?? [:]
        print(params)
        PKWrapperClass.requestPOSTWithFormData(url, params: params, imageData: []) { (response) in
            let status = response.data["status"] as? String ?? ""
            self.messgae = response.data["message"] as? String ?? ""
            if status == "1"{
            }else{
            }
        } failure: { (error) in
            print(error)
        }
    }
    
    func filterdData() {
        let url = Constant.shared.baseUrl + Constant.shared.FilterdData
        let params = ["page_no": page ,"id" : self.id]  as? [String : AnyObject] ?? [:]
        print(params)
        PKWrapperClass.svprogressHudShow(title: Constant.shared.appTitle, view: self)
        PKWrapperClass.requestPOSTWithFormDataWithoutImages(url, params: params) { (response) in
            DispatchQueue.main.async {
                PKWrapperClass.svprogressHudDismiss(view: self)
            }
            let status = response.data["status"] as? String ?? ""
            self.messgae = response.data["message"] as? String ?? ""
            if status == "1"{
                var newArr = [FilterProductData]()
                let allData = response.data["product_list"] as? [String:Any] ?? [:]
                for obj in allData["all_products"] as? [[String:Any]] ?? [[:]]{
                    print(obj)
                    newArr.append(FilterProductData(id: obj["id"] as? String ?? "", prod_cat:  obj["prod_cat"] as? String ?? "", prod_desc:  obj["prod_desc"] as? String ?? "", prod_image:  obj["prod_image"] as? String ?? "", prod_model:  obj["prod_model"] as? String ?? "", prod_name:  obj["prod_name"] as? String ?? "", prod_price:  obj["prod_price"] as? String ?? "", prod_sno:  obj["prod_sno"] as? String ?? ""))
                }
                for i in 0..<newArr.count{
                    self.filterProDArray.append(newArr[i])
                }
                self.allItemsTBView.reloadData()
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
        }
    }
    
//    MARK:- Button Actions
    
    @IBAction func openMenuButton(_ sender: Any) {
     
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func searchButton(_ sender: Any) {
        
//        let transition = CATransition()
//        transition.duration = 0.5
//        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//        transition.type = CATransitionType.fade
//        transition.subtype = CATransitionSubtype.fromTop
//        self.navigationController!.view.layer.add(transition, forKey: nil)
//        let writeView = self.storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
//        self.navigationController?.pushViewController(writeView, animated: false)
    }
}

// MARK:- TableView Cell Class

class AlItemsTBViewCell: UITableViewCell {
    
    @IBOutlet weak var modelName: UILabel!
    @IBOutlet weak var checkAvailabiltyButton: UIButton!
    @IBOutlet weak var detailsLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var dataView: UIView!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

// MARK:- TableView Cell Functions

extension HomeVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterProDArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlItemsTBViewCell", for: indexPath) as! AlItemsTBViewCell
        if filterProDArray.count > 0{
            cell.showImage.sd_setImage(with: URL(string: filterProDArray[indexPath.row].prod_image), placeholderImage: UIImage(named: "placeholder-img-logo (1)"), options: SDWebImageOptions.continueInBackground, completed: nil)
            cell.nameLbl.text = filterProDArray[indexPath.row].prod_name
            cell.showImage.roundTop()
            cell.modelName.text = filterProDArray[indexPath.row].prod_model
            currentIndex = filterProDArray[indexPath.row].id
            cell.checkAvailabiltyButton.tag = indexPath.row
            cell.priceLbl.text = filterProDArray[indexPath.row].prod_price
           // cell.checkAvailabiltyButton.addTarget(self, action: #selector(goto), for: .touchUpInside)
            if buttonTitle == "Customer"{
                cell.checkAvailabiltyButton.setTitle("More Details", for: .normal)
            }else{
                cell.checkAvailabiltyButton.setTitle("Check Availabilty", for: .normal)
            }
        }
        return cell
    }
    
//    @objc func goto(sender : UIButton) {
//        if [sender.tag].id.isEmpty == true{
//        }else{
//            let vc = ProductDetailsVC.instantiate(fromAppStoryboard: .Main)
//            vc.id = filterProDArray[sender.tag].id
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ProductDetailsVC.instantiate(fromAppStoryboard: .Main)
        vc.id = filterProDArray[indexPath.row].id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if lastPage == "FALSE"{
            let bottamEdge = Float(self.allItemsTBView.contentOffset.y + self.allItemsTBView.frame.size.height)
            if bottamEdge >= Float(self.allItemsTBView.contentSize.height) && filterProDArray.count > 0 {
                page = page + 1
                filterdData()
            }
        }else{
            let bottamEdge = Float(self.allItemsTBView.contentOffset.y + self.allItemsTBView.frame.size.height)
            if bottamEdge >= Float(self.allItemsTBView.contentSize.height) && filterProDArray.count > 0 {
            }
        }
    }
}

struct TableViewData {
    var image : String
    var name : String
    var modelName : String
    var details : String
    var price : String
    var prod_sno : String
    var prod_type : String
    var id : String
    var prod_video : String
    var prod_qty : String
    var prod_pdf : String
    var prod_desc : String
    
    init(image : String,name : String,modelName : String,details : String,price : String,prod_sno : String,prod_type : String,id : String,prod_video : String,prod_qty : String,prod_pdf : String,prod_desc : String) {
        self.image = image
        self.name = name
        self.modelName = modelName
        self.details = details
        self.price = price
        self.prod_sno = prod_sno
        self.prod_type = prod_type
        self.id = id
        self.prod_video = prod_video
        self.prod_qty = prod_qty
        self.prod_pdf = prod_pdf
        self.prod_desc = prod_desc
    }
}
extension  UIView {
    func roundTop(radius:CGFloat = 12){
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        } else {
            // Fallback on earlier versions
        }
    }
}



struct FilterProductData {
     init(id: String, prod_cat: String, prod_desc: String, prod_image: String, prod_model: String, prod_name: String, prod_price: String, prod_sno: String) {
        self.id = id
        self.prod_cat = prod_cat
        self.prod_desc = prod_desc
        self.prod_image = prod_image
        self.prod_model = prod_model
        self.prod_name = prod_name
        self.prod_price = prod_price
        self.prod_sno = prod_sno
    }
    
    var id : String
    var prod_cat : String
    var prod_desc : String
    var prod_image : String
    var prod_model : String
    var prod_name : String
    var prod_price : String
    var prod_sno : String
}
