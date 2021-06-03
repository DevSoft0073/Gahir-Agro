//
//  BookOrderVC.swift
//  Gahir Agro
//
//  Created by Apple on 25/02/21.
//

import UIKit
import SDWebImage
import Alamofire

class BookOrderVC: UIViewController {

    var enquiryID = String()
    var messgae = String()
    var name = String()
    var modelName = String()
    var amount = String()
    var quantity = String()
    var accessoriesName = String()
    var enqStatus = String()
    var image = String()
    var productTitle = String()
    var updateTblViewData:(()->Void)?
    
    @IBOutlet weak var orderDetailsStackView: UIStackView!
    @IBOutlet weak var statusStackView: UIStackView!
    @IBOutlet weak var orderStatusTxt: UILabel!
    @IBOutlet weak var orderTimeLbl: UILabel!
    @IBOutlet weak var bookOrderButton: UIButton!
    @IBOutlet weak var showStatus: UILabel!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var showImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.statusStackView.isHidden = true
        bookOrderButton.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let comesFrom = UserDefaults.standard.value(forKey: "comesFromAdmin") as? Bool ?? false
        if comesFrom == true {
            enquiryDetailsForAdmin()
        }else{
            enquiryDetails()
        }
    }
    
//    MARK:- Button Action
    
    @IBAction func backButton(_ sender: Any) {
        let comesFrom = UserDefaults.standard.value(forKey: "comesFromPush") as? Bool ?? false
        if comesFrom == true{
            UserDefaults.standard.set(false, forKey: "comesFromPush")
            AppDelegate().redirectToHomeVC()
        }else{
            self.navigationController?.popViewController(animated: true)
            self.updateTblViewData?()
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
                self.showStatus.text = enquiryData["dispatch_day"] as? String ?? ""
                self.orderTimeLbl.text = (enquiryData["order_time"] as? String ?? "")
                self.orderStatusTxt.text = enquiryData["status_text"] as? String ?? ""
                let productDetails = enquiryData["product_detail"] as? [String:Any] ?? [:]
                self.enqStatus = enquiryData["enq_status"] as? String ?? ""
                if self.enqStatus == "0" || self.enqStatus == "8" || self.enqStatus == "9"{
                    self.orderDetailsStackView.isHidden = true
                    self.statusStackView.isHidden = false
                    self.bookOrderButton.isHidden = true
                }else{
                    self.bookOrderButton.isHidden = false
                    self.statusStackView.isHidden = true
                    self.orderDetailsStackView.isHidden = false
                }
                print(productDetails)
                self.showImage.sd_setImage(with: URL(string:productDetails["prod_image"] as? String ?? ""), placeholderImage: UIImage(named: "placeholder-img-logo (1)"), options: SDWebImageOptions.continueInBackground, completed: nil)
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
    
    func enquiryDetailsForAdmin() {
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
                self.showStatus.text = enquiryData["dispatch_day"] as? String ?? ""
                self.orderTimeLbl.text = "\(enquiryData["order_time"] as? Int ?? 0) hr"
                self.orderStatusTxt.text = enquiryData["status_text"] as? String ?? ""
                let productDetails = enquiryData["product_detail"] as? [String:Any] ?? [:]
                self.enqStatus = enquiryData["enq_status"] as? String ?? ""
                if self.enqStatus == "0" || self.enqStatus == "8" || self.enqStatus == "9"{
                    self.orderDetailsStackView.isHidden = true
                    self.statusStackView.isHidden = false
                    self.bookOrderButton.isHidden = true
                }else{
                    self.bookOrderButton.isHidden = true
                    self.statusStackView.isHidden = true
                    self.orderDetailsStackView.isHidden = false
                }
                print(productDetails)
                self.showImage.sd_setImage(with: URL(string:productDetails["prod_image"] as? String ?? ""), placeholderImage: UIImage(named: "placeholder-img-logo (1)"), options: SDWebImageOptions.continueInBackground, completed: nil)
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
