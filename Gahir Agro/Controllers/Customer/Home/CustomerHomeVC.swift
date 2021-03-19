//
//  CustomerHomeVC.swift
//  Gahir Agro
//
//  Created by Apple on 25/02/21.
//

import UIKit
import LGSideMenuController
import SDWebImage

class CustomerHomeVC: UIViewController {
    
    var page = 1
    var lastPage = Bool()
    var productType = String()
    var messgae = String()
    var currentIndex = String()
    var customerCollectionViewDataArray = [CollectionViewDataForDealer]()
    var customerTableViewDataArray = [TableViewDataForDealer]()

    @IBOutlet weak var tableViewData: UITableView!
    @IBOutlet weak var collectionViewData: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewData.separatorStyle = .none
        customerCollectionViewDataArray.append(CollectionViewDataForDealer(name: "TRACTOR", selected: true, type: "0"))
        customerCollectionViewDataArray.append(CollectionViewDataForDealer(name: "LASER", selected: false, type: "1"))
        customerCollectionViewDataArray.append(CollectionViewDataForDealer(name: "PUMP", selected: false, type: "2"))
        tableViewData.separatorStyle = .none
        getAllProducts()
    }
    
    
    func filterdData() {
        PKWrapperClass.svprogressHudShow(title: Constant.shared.appTitle, view: self)
        let url = Constant.shared.baseUrl + Constant.shared.FilterProducts
        var deviceID = UserDefaults.standard.value(forKey: "deviceToken") as? String
        let accessToken = UserDefaults.standard.value(forKey: "accessToken")
        print(deviceID ?? "")
        if deviceID == nil  {
            deviceID = "777"
        }
        let params = ["page_no": page,"access_token": accessToken,"type" : self.productType]  as? [String : AnyObject] ?? [:]
        print(params)
        PKWrapperClass.requestPOSTWithFormData(url, params: params, imageData: []) { (response) in
            print(response.data)
            PKWrapperClass.svprogressHudDismiss(view: self)
            self.customerTableViewDataArray.removeAll()
            let status = response.data["status"] as? String ?? ""
            self.messgae = response.data["message"] as? String ?? ""
            self.lastPage = response.data["last_page"] as? Bool ?? false
            if status == "1"{
                var newArr = [TableViewDataForDealer]()
                let allData = response.data["product_list"] as? [String:Any] ?? [:]
                self.lastPage = response.data["product_list"] as? Bool ?? false
                for obj in allData["all_products"] as? [[String:Any]] ?? [[:]] {
                    print(obj)
                    
                    newArr.append(TableViewDataForDealer(image: obj["prod_image"] as? String ?? "", name: obj["prod_name"] as? String ?? "", modelName: obj["prod_desc"] as? String ?? "", details: obj["prod_desc"] as? String ?? "", price: obj["prod_price"] as? String ?? "", prod_sno: obj["GAIC2K213000"] as? String ?? "", prod_type: obj["prod_type"] as? String ?? "", id: obj["id"] as? String ?? "", prod_video: obj["prod_video"] as? String ?? "", prod_qty: obj["prod_qty"] as? String ?? "", prod_pdf: obj["prod_pdf"] as? String ?? "", prod_desc:  obj["prod_desc"] as? String ?? ""))
                }
                for i in 0..<newArr.count{
                    self.customerTableViewDataArray.append(newArr[i])
                }
                self.tableViewData.reloadData()
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
            showAlertMessage(title: Constant.shared.appTitle, message: error as? String ?? "", okButton: "Ok", controller: self, okHandler: nil)
        }
    }
    
    
    func getAllProducts() {
        PKWrapperClass.svprogressHudShow(title: Constant.shared.appTitle, view: self)
        let url = Constant.shared.baseUrl + Constant.shared.AllProduct
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
            self.customerTableViewDataArray.removeAll()
            PKWrapperClass.svprogressHudDismiss(view: self)
            let status = response.data["status"] as? String ?? ""
            self.messgae = response.data["message"] as? String ?? ""
            if status == "1"{
                var newArr = [TableViewDataForDealer]()
                let allData = response.data["product_list"] as? [String:Any] ?? [:]
                self.lastPage = response.data["product_list"] as? Bool ?? false
                for obj in allData["all_products"] as? [[String:Any]] ?? [[:]] {
                    print(obj)
                    newArr.append(TableViewDataForDealer(image: obj["prod_image"] as? String ?? "", name: obj["prod_name"] as? String ?? "", modelName: obj["prod_desc"] as? String ?? "", details: obj["prod_desc"] as? String ?? "", price: obj["prod_price"] as? String ?? "", prod_sno: obj["GAIC2K213000"] as? String ?? "", prod_type: obj["prod_type"] as? String ?? "", id: obj["id"] as? String ?? "", prod_video: obj["prod_video"] as? String ?? "", prod_qty: obj["prod_qty"] as? String ?? "", prod_pdf: obj["prod_pdf"] as? String ?? "", prod_desc: obj["prod_desc"] as? String ?? ""))
                }
                for i in 0..<newArr.count{
                    self.customerTableViewDataArray.append(newArr[i])
                }
                self.tableViewData.reloadData()
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
            showAlertMessage(title: Constant.shared.appTitle, message: error as? String ?? "", okButton: "Ok", controller: self, okHandler: nil)
        }
    }
    
    
    @IBAction func menuButton(_ sender: Any) {
        sideMenuController?.showLeftViewAnimated()
    }
    
    @IBAction func searchButton(_ sender: Any) {
        
    }
}

class TableViewDataCell: UITableViewCell {
    
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var moreDetailsButton: UIButton!
    @IBOutlet weak var subDetailsLbl: UILabel!
    @IBOutlet weak var detailslbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

class CollectionViewDataCell: UICollectionViewCell {
    
    
    @IBOutlet weak var nameLbl: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}



struct CollectionViewDataForDealer {
    var name : String
    var selected : Bool
    var type : String
    
    init(name : String , selected : Bool,type : String) {
        self.name = name
        self.selected = selected
        self.type = type
    }
}


struct TableViewDataForDealer {
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


extension CustomerHomeVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customerTableViewDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewDataCell", for: indexPath) as! TableViewDataCell
        cell.showImage.image = UIImage(named: customerTableViewDataArray[indexPath.row].image)
        cell.showImage.roundTop()
        cell.nameLbl.text = customerTableViewDataArray[indexPath.row].name
        cell.detailslbl.text = customerTableViewDataArray[indexPath.row].modelName
        cell.subDetailsLbl.text = customerTableViewDataArray[indexPath.row].details
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ProductDetailsVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 330
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if lastPage == true{
            let bottamEdge = Float(self.tableViewData.contentOffset.y + self.tableViewData.frame.size.height)
            if bottamEdge >= Float(self.tableViewData.contentSize.height) && customerTableViewDataArray.count > 0 {
                page = page + 1
                filterdData()
            }
        }else{
            let bottamEdge = Float(self.tableViewData.contentOffset.y + self.tableViewData.frame.size.height)
            if bottamEdge >= Float(self.tableViewData.contentSize.height) && customerTableViewDataArray.count > 0 {
//                filterdData()
            }
        }
    }
    
}

extension CustomerHomeVC : UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return customerCollectionViewDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewDataCell", for: indexPath) as! CollectionViewDataCell
        cell.nameLbl.text = customerCollectionViewDataArray[indexPath.item].name
        
        let data = self.customerCollectionViewDataArray[indexPath.row]
        if data.selected{
            cell.contentView.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            cell.nameLbl.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }else{
            cell.contentView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.nameLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if self.customerCollectionViewDataArray[indexPath.row].selected{
            self.customerCollectionViewDataArray[indexPath.row].selected = !self.customerCollectionViewDataArray[indexPath.row].selected
            self.customerCollectionViewDataArray = self.customerCollectionViewDataArray.map({ (data) -> CollectionViewDataForDealer in
                var mutableData = data
                mutableData.selected = false
                return mutableData
                
                
            })
        }else{
            self.customerCollectionViewDataArray = self.customerCollectionViewDataArray.map({ (data) -> CollectionViewDataForDealer in
                var mutableData = data
                mutableData.selected = false
                return mutableData
            })
            self.customerCollectionViewDataArray[indexPath.row].selected = !self.customerCollectionViewDataArray[indexPath.row].selected
            print(customerCollectionViewDataArray)
            self.customerTableViewDataArray.removeAll()

            if let obj = customerCollectionViewDataArray.filter({$0.selected == true}).first{
                productType = obj.type ?? "0"
                filterdData()
            }
            self.tableViewData.reloadData()
        }
        collectionViewData.reloadData()
    }
}
