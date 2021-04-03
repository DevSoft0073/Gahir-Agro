//
//  BookOrderVC.swift
//  Gahir Agro
//
//  Created by Apple on 25/02/21.
//

import UIKit
import SDWebImage

class BookOrderVC: UIViewController {

    var enquiryID = String()
    var messgae = String()
    var name = String()
    var modelName = String()
    var amount = String()
    var quantity = String()
    var accessoriesName = String()
    var status = String()
    var image = String()
    var productTitle = String()
    
    @IBOutlet weak var bookOrderButton: UIButton!
    @IBOutlet weak var showStatus: UILabel!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var showImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        enquiryDetails()
        
    }
    
//    MARK:- Button Action
    
    @IBAction func backButton(_ sender: Any) {
        let comesFrom = UserDefaults.standard.value(forKey: "comesFromPush") as? Bool ?? false
        if comesFrom == true{
            UserDefaults.standard.set(false, forKey: "comesFromPush")
            AppDelegate().redirectToHomeVC()
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
  
    @IBAction func bookOrderButton(_ sender: Any) {
        let vc = SubmitDetailsVC.instantiate(fromAppStoryboard: .Main)
        vc.enquiryID = enquiryID
        vc.name = name
        vc.quantity = quantity
        vc.amount = amount
        vc.accessoriesName = accessoriesName
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
//    MARK:- Service Call
    
    
    func enquiryDetails() {
        PKWrapperClass.svprogressHudShow(title: Constant.shared.appTitle, view: self)
        let url = Constant.shared.baseUrl + Constant.shared.EnquiryDetails
        var deviceID = UserDefaults.standard.value(forKey: "deviceToken") as? String
        let accessToken = UserDefaults.standard.value(forKey: "accessToken")
        print(deviceID ?? "")
        if deviceID == nil  {
            deviceID = "777"
        }
        let params = ["access_token": accessToken , "id" : self.enquiryID]  as? [String : AnyObject] ?? [:]
        print(params)
        PKWrapperClass.requestPOSTWithFormData(url, params: params, imageData: []) { (response) in
            print(response.data)
            PKWrapperClass.svprogressHudDismiss(view: self)
            let status = response.data["status"] as? String ?? ""
            self.messgae = response.data["message"] as? String ?? ""
            if status == "1"{
                let enquiryData = response.data["enquiry_detail"] as? [String:Any] ?? [:]
                self.quantityLbl.text = enquiryData["qty"] as? String ?? ""
                self.showStatus.text = enquiryData["status"] as? String ?? ""
                let productDetails = enquiryData["product_detail"] as? [String:Any] ?? [:]
                if self.showStatus.text == "Not Responded"{
                    self.bookOrderButton.isHidden = true
                }else{
                    self.bookOrderButton.isHidden = false
                }
                print(productDetails)
                self.showImage.sd_setImage(with: URL(string:productDetails["prod_image"] as? String ?? ""), placeholderImage: UIImage(named: "placeholder-img-logo (1)"), options: SDWebImageOptions.continueInBackground, completed: nil)
                self.titleLbl.text = productDetails["prod_model"] as? String ?? ""
            }else{
                PKWrapperClass.svprogressHudDismiss(view: self)
                alert(Constant.shared.appTitle, message: self.messgae, view: self)
            }
        } failure: { (error) in
            print(error)
            PKWrapperClass.svprogressHudDismiss(view: self)
            showAlertMessage(title: Constant.shared.appTitle, message: error as? String ?? "", okButton: "Ok", controller: self, okHandler: nil)
        }
    }

    
}
