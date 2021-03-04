//
//  SearchVC.swift
//  Gahir Agro
//
//  Created by Apple on 24/02/21.
//

import UIKit

class SearchVC: UIViewController,UITextFieldDelegate {
    
    
    var page = 1
    var lastPage = 1
    var messgae = String()
    var searchArray = ["First Item","Second Item"]
    var tableViewDataArray = [SearchTableViewData]()

    @IBOutlet weak var showSearchedDataTBView: UITableView!
    @IBOutlet weak var searchDataTBView: UITableView!
    @IBOutlet weak var searchTxtFld: UITextField!
    @IBOutlet weak var searchView: UIView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        searchDataTBView.separatorStyle = .none
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func filterdData() {
        PKWrapperClass.svprogressHudShow(title: Constant.shared.appTitle, view: self)
        let url = Constant.shared.baseUrl + Constant.shared.SearchData
        var deviceID = UserDefaults.standard.value(forKey: "deviceToken") as? String
        let accessToken = UserDefaults.standard.value(forKey: "accessToken")
        print(deviceID ?? "")
        if deviceID == nil  {
            deviceID = "777"
        }
        let params = ["page_no": page,"access_token": accessToken,"search" : searchTxtFld.text ?? ""]  as? [String : AnyObject] ?? [:]
        print(params)
        PKWrapperClass.requestPOSTWithFormData(url, params: params, imageData: [[:]]) { (response) in
            print(response.data)
            PKWrapperClass.svprogressHudDismiss(view: self)
            let status = response.data["status"] as? String ?? ""
            self.messgae = response.data["message"] as? String ?? ""
            if status == "1"{
                var newArr = [SearchTableViewData]()
                let allData = response.data["product_list"] as? [String:Any] ?? [:]
                for obj in allData["all_products"] as? [[String:Any]] ?? [[:]] {
                    print(obj)
                    newArr.append(SearchTableViewData(image: obj["prod_image"] as? String ?? "", name: obj["prod_name"] as? String ?? "", modelName: obj["prod_desc"] as? String ?? "", details: obj["prod_desc"] as? String ?? "", price: obj["prod_price"] as? String ?? "", prod_sno: obj["GAIC2K213000"] as? String ?? "", prod_type: obj["prod_type"] as? String ?? "", id: obj["id"] as? String ?? "", prod_video: obj["prod_video"] as? String ?? "", prod_qty: obj["prod_qty"] as? String ?? "", prod_pdf: obj["prod_pdf"] as? String ?? ""))
                }
                for i in 0..<newArr.count{
                    self.tableViewDataArray.append(newArr[i])
                }
                self.searchDataTBView.reloadData()
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

class SearchDataTBViewCell: UITableViewCell {
    
    
    @IBOutlet weak var nameLbl: UILabel!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

class ShowSearchedDataTBViewCell: UITableViewCell {
    
    @IBOutlet weak var detailsLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var nameLbl: UIStackView!
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var dataView: UIView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension SearchVC : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       var numberOfRow = 1
        switch tableView {
        case searchDataTBView:
            numberOfRow = searchArray.count
        case showSearchedDataTBView:
            numberOfRow = tableViewDataArray.count
        default:
            print("Some things Wrong!!")
        }
        return numberOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell = UITableViewCell()
            switch tableView {
            case searchDataTBView:
                cell = tableView.dequeueReusableCell(withIdentifier: "SearchDataTBViewCell", for: indexPath) as! SearchDataTBViewCell
                
            case showSearchedDataTBView:
                cell = tableView.dequeueReusableCell(withIdentifier: "SearchDataTBViewCell", for: indexPath) as! SearchDataTBViewCell
            default:
                print("Some things Wrong!!")
            }
            return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
        
    }
    
}


struct SearchTableViewData {
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
