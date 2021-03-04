//
//  HomeVC.swift
//  Gahir Agro
//
//  Created by Apple on 23/02/21.
//

import UIKit
import LGSideMenuController

class HomeVC: UIViewController {
    
    var collectionViewDataArray = [CollectionViewData]()
    var tableViewDataArray = [TableViewData]()
    
    var page = 1
    var lastPage = 1
    var productType = String()
    var messgae = String()

    @IBOutlet weak var allItemsTBView: UITableView!
    @IBOutlet weak var itemsCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        allItemsTBView.separatorStyle = .none

        collectionViewDataArray.append(CollectionViewData(name: "Tractor", selected: false, type: "0"))
        collectionViewDataArray.append(CollectionViewData(name: "Laser", selected: false, type: "1"))
        collectionViewDataArray.append(CollectionViewData(name: "Pump", selected: false, type: "2"))
        
        getAllProducts()
        itemsCollectionView.reloadData()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    @IBAction func openMenuButton(_ sender: Any) {
        sideMenuController?.showLeftViewAnimated()
    }
    
    @IBAction func searchButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        self.present(vc, animated: true, completion: nil)
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
        PKWrapperClass.requestPOSTWithFormData(url, params: params, imageData: [[:]]) { (response) in
            print(response.data)
            PKWrapperClass.svprogressHudDismiss(view: self)
            let status = response.data["status"] as? String ?? ""
            self.messgae = response.data["message"] as? String ?? ""
            if status == "1"{
                
                var newArr = [TableViewData]()
                let allData = response.data["product_list"] as? [String:Any] ?? [:]
                for obj in allData["all_products"] as? [[String:Any]] ?? [[:]] {
                    print(obj)
                    newArr.append(TableViewData(image: obj["prod_image"] as? String ?? "", name: obj["prod_name"] as? String ?? "", modelName: obj["prod_desc"] as? String ?? "", details: obj["prod_desc"] as? String ?? "", price: obj["prod_price"] as? String ?? "", prod_sno: obj["GAIC2K213000"] as? String ?? "", prod_type: obj["prod_type"] as? String ?? "", id: obj["id"] as? String ?? "", prod_video: obj["prod_video"] as? String ?? "", prod_qty: obj["prod_qty"] as? String ?? "", prod_pdf: obj["prod_pdf"] as? String ?? ""))
                }
                for i in 0..<newArr.count{
                    self.tableViewDataArray.append(newArr[i])
                }
                self.allItemsTBView.reloadData()
            }else{
                PKWrapperClass.svprogressHudDismiss(view: self)
                alert(Constant.shared.appTitle, message: self.messgae, view: self)
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
        PKWrapperClass.requestPOSTWithFormData(url, params: params, imageData: [[:]]) { (response) in
            print(response.data)
            PKWrapperClass.svprogressHudDismiss(view: self)
            let status = response.data["status"] as? String ?? ""
            self.messgae = response.data["message"] as? String ?? ""
            if status == "1"{
                var newArr = [TableViewData]()
                let allData = response.data["product_list"] as? [String:Any] ?? [:]
                for obj in allData["all_products"] as? [[String:Any]] ?? [[:]] {
                    print(obj)
                    newArr.append(TableViewData(image: obj["prod_image"] as? String ?? "", name: obj["prod_name"] as? String ?? "", modelName: obj["prod_desc"] as? String ?? "", details: obj["prod_desc"] as? String ?? "", price: obj["prod_price"] as? String ?? "", prod_sno: obj["GAIC2K213000"] as? String ?? "", prod_type: obj["prod_type"] as? String ?? "", id: obj["id"] as? String ?? "", prod_video: obj["prod_video"] as? String ?? "", prod_qty: obj["prod_qty"] as? String ?? "", prod_pdf: obj["prod_pdf"] as? String ?? ""))
                }
                for i in 0..<newArr.count{
                    self.tableViewDataArray.append(newArr[i])
                }
                self.allItemsTBView.reloadData()
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

class ItemsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

class AlItemsTBViewCell: UITableViewCell {
    
    @IBOutlet weak var checkAvailabiltyButton: UIButton!
    @IBOutlet weak var detailsLbl: UILabel!
    @IBOutlet weak var modelLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var dataView: UIView!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}


extension HomeVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlItemsTBViewCell", for: indexPath) as! AlItemsTBViewCell
        cell.showImage.sd_setImage(with: URL(string:tableViewDataArray[indexPath.row].image), placeholderImage: UIImage(named: "im"))
        cell.nameLbl.text = tableViewDataArray[indexPath.row].name
        cell.showImage.roundTop()
        cell.modelLbl.text = tableViewDataArray[indexPath.row].modelName
        cell.detailsLbl.text = tableViewDataArray[indexPath.row].details
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ProductDetailsVC.instantiate(fromAppStoryboard: .Main)
        vc.id = tableViewDataArray[indexPath.row].id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 360
    }
    
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            if page <= lastPage{
                let bottamEdge = Float(self.allItemsTBView.contentOffset.y + self.allItemsTBView.frame.size.height)
                if bottamEdge >= Float(self.allItemsTBView.contentSize.height) && tableViewDataArray.count > 0 {
                    page = page + 1
                    getAllProducts()
                }
            }
        }

    
}

extension HomeVC : UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemsCollectionViewCell", for: indexPath) as! ItemsCollectionViewCell
        //        cell.dataView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        cell.nameLbl.text = collectionViewDataArray[indexPath.item].name
        
        let data = self.collectionViewDataArray[indexPath.row]
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
        
        if self.collectionViewDataArray[indexPath.row].selected{
            self.collectionViewDataArray[indexPath.row].selected = !self.collectionViewDataArray[indexPath.row].selected
            self.collectionViewDataArray = self.collectionViewDataArray.map({ (data) -> CollectionViewData in
                var mutableData = data
                mutableData.selected = false
                return mutableData
                
                
            })
        }else{
            self.collectionViewDataArray = self.collectionViewDataArray.map({ (data) -> CollectionViewData in
                var mutableData = data
                mutableData.selected = false
                return mutableData
            })
            self.collectionViewDataArray[indexPath.row].selected = !self.collectionViewDataArray[indexPath.row].selected
            print(collectionViewDataArray)
            let filterArray = collectionViewDataArray.filter({$0.selected == true})
            print(filterArray)
            for obj in filterArray{
                productType = obj.type
                self.tableViewDataArray.removeAll()
                filterdData()
            }
        }
        itemsCollectionView.reloadData()
    }
}

struct CollectionViewData {
    var name : String
    var selected : Bool
    var type : String
    
    init(name : String , selected : Bool,type : String) {
        self.name = name
        self.selected = selected
        self.type = type
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
    
    init(image : String,name : String,modelName : String,details : String,price : String,prod_sno : String,prod_type : String,id : String,prod_video : String,prod_qty : String,prod_pdf : String) {
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
