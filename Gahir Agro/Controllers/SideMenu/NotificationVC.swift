//
//  NotificationVC.swift
//  Gahir Agro
//
//  Created by Apple on 24/02/21.
//

import UIKit
import LGSideMenuController

class NotificationVC: UIViewController {

    var notificationArray = [NotificationData]()
    var messgae = String()
    var lastPage = Bool()
    var page = 1
    @IBOutlet weak var notificationTBView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationTBView.separatorStyle = .none
        
//        notificationArray.append(NotificationData(name: "New Notification", image: "img-1", details: "Loreum ipsumor Iipusm as it is sometimes known, is dummy text used in lying out print, graphics or web , designs.", date: "12/09/20 9:02 AM"))
//        notificationArray.append(NotificationData(name: "New Notification", image: "img-1", details: "Loreum ipsumor Iipusm as it is sometimes known, is dummy text used in lying out print, graphics or web , designs.", date: "12/09/20 9:02 AM"))
//        notificationArray.append(NotificationData(name: "New Notification", image: "img-1", details: "Loreum ipsumor Iipusm as it is sometimes known, is dummy text used in lying out print, graphics or web , designs.", date: "12/09/20 9:02 AM"))
//        notificationArray.append(NotificationData(name: "New Notification", image: "img-1", details: "Loreum ipsumor Iipusm as it is sometimes known, is dummy text used in lying out print, graphics or web , designs.", date: "12/09/20 9:02 AM"))
//        notificationArray.append(NotificationData(name: "New Notification", image: "img-1", details: "Loreum ipsumor Iipusm as it is sometimes known, is dummy text used in lying out print, graphics or web , designs.", date: "12/09/20 9:02 AM"))
//        notificationArray.append(NotificationData(name: "New Notification", image: "img-1", details: "Loreum ipsumor Iipusm as it is sometimes known, is dummy text used in lying out print, graphics or web , designs.", date: "12/09/20 9:02 AM"))
//        notificationArray.append(NotificationData(name: "New Notification", image: "img-1", details: "Loreum ipsumor Iipusm as it is sometimes known, is dummy text used in lying out print, graphics or web , designs.", date: "12/09/20 9:02 AM"))
//        notificationArray.append(NotificationData(name: "New Notification", image: "img-1", details: "Loreum ipsumor Iipusm as it is sometimes known, is dummy text used in lying out print, graphics or web , designs.", date: "12/09/20 9:02 AM"))
//        notificationArray.append(NotificationData(name: "New Notification", image: "img-1", details: "Loreum ipsumor Iipusm as it is sometimes known, is dummy text used in lying out print, graphics or web , designs.", date: "12/09/20 9:02 AM"))

        notifationData()

        // Do any additional setup after loading the view.
    }
    
    func notifationData() {
        PKWrapperClass.svprogressHudShow(title: Constant.shared.appTitle, view: self)
        let url = Constant.shared.baseUrl + Constant.shared.Notification
        var deviceID = UserDefaults.standard.value(forKey: "deviceToken") as? String
        let accessToken = UserDefaults.standard.value(forKey: "accessToken")
        print(deviceID ?? "")
        if deviceID == nil  {
            deviceID = "777"
        }
        let params = ["page_no" : "" ,"access_token": accessToken]  as? [String : AnyObject] ?? [:]
        print(params)
        PKWrapperClass.requestPOSTWithFormData(url, params: params, imageData: [[:]]) { (response) in
            print(response.data)
//            self.notificationArray.removeAll()
            PKWrapperClass.svprogressHudDismiss(view: self)
            self.lastPage = response.data["product_list"] as? Bool ?? false
            let status = response.data["status"] as? String ?? ""
            self.messgae = response.data["message"] as? String ?? ""
            if status == "1"{
                for obj in response.data["notification_list"] as? [[String:Any]] ?? [[:]] {
                    print(obj)
//                    self.
                }
                showAlertMessage(title: Constant.shared.appTitle, message: self.messgae, okButton: "Ok", controller: self) {
                    self.navigationController?.popViewController(animated: true)
                }
                self.notificationTBView.reloadData()
            }else{
                PKWrapperClass.svprogressHudDismiss(view: self)
                alert(Constant.shared.appTitle, message: self.messgae, view: self)
            }
        } failure: { (error) in
            print(error)
            showAlertMessage(title: Constant.shared.appTitle, message: error as? String ?? "", okButton: "Ok", controller: self, okHandler: nil)
        }
    }
    
    
    @IBAction func openMenu(_ sender: Any) {
        sideMenuController?.showLeftViewAnimated()

    }
    
}


class NotificationTBViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var detailsLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var showImage: UIImageView!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}


extension NotificationVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTBViewCell", for: indexPath) as! NotificationTBViewCell
        cell.showImage.image = UIImage(named: notificationArray[indexPath.row].image)
        cell.showImage.setRounded()
        cell.nameLbl.text = notificationArray[indexPath.row].name
        cell.detailsLbl.text = notificationArray[indexPath.row].details
        cell.dateLbl.text = notificationArray[indexPath.row].date
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if lastPage == true{
            let bottamEdge = Float(self.notificationTBView.contentOffset.y + self.notificationTBView.frame.size.height)
            if bottamEdge >= Float(self.notificationTBView.contentSize.height) && notificationArray.count > 0 {
                page = page + 1
                notifationData()
            }
        }else{
            let bottamEdge = Float(self.notificationTBView.contentOffset.y + self.notificationTBView.frame.size.height)
            if bottamEdge >= Float(self.notificationTBView.contentSize.height) && notificationArray.count > 0 {
                notifationData()
            }
        }
    }
    
}

struct NotificationData {
    var name : String
    var image : String
    var details : String
    var date : String
    
    init(name : String,image : String,details : String,date : String) {
        self.name = name
        self.image = image
        self.details = details
        self.date = date
    }
}
