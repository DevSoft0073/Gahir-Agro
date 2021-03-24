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
        let params = ["page_no" : self.page ,"access_token": accessToken]  as? [String : AnyObject] ?? [:]
        print(params)
        PKWrapperClass.requestPOSTWithFormData(url, params: params, imageData: []) { (response) in
            print(response.data)
            self.notificationArray.removeAll()
            PKWrapperClass.svprogressHudDismiss(view: self)
            self.lastPage = response.data["product_list"] as? Bool ?? false
            let status = response.data["status"] as? String ?? ""
            self.messgae = response.data["message"] as? String ?? ""
            self.lastPage = response.data[""] as? Bool ?? false
            if status == "1"{
                var newArr = [NotificationData]()
                let allData = response.data["notification_list"] as? [String:Any] ?? [:]
                for obj in allData["all_notifications"] as? [[String:Any]] ?? [[:]] {
                    print(obj)
                    let dateValue = obj["creation_date"] as? String ?? ""
                    let dateVal = NumberFormatter().number(from: dateValue)?.doubleValue ?? 0.0
                    self.convertTimeStampToDate(dateVal: dateVal)
                    newArr.append(NotificationData(name: obj["notify_title"] as? String ?? "", image: "img-1", details: obj["notify_message"] as? String ?? "", date: self.convertTimeStampToDate(dateVal: dateVal)))
                }
                for i in 0..<newArr.count{
                    self.notificationArray.append(newArr[i])
                }
                self.notificationTBView.reloadData()
            }else{
                PKWrapperClass.svprogressHudDismiss(view: self)
//                alert(Constant.shared.appTitle, message: self.messgae, view: self)
            }
        } failure: { (error) in
            print(error)
            showAlertMessage(title: Constant.shared.appTitle, message: error as? String ?? "", okButton: "Ok", controller: self, okHandler: nil)
        }
    }
    
    func convertTimeStampToDate(dateVal : Double) -> String{
        let timeinterval = TimeInterval(dateVal)
        let dateFromServer = Date(timeIntervalSince1970:timeinterval)
        print(dateFromServer)
        let dateFormater = DateFormatter()
        dateFormater.timeZone = .current
        dateFormater.dateFormat = "dd-MM-YYYY"
        return dateFormater.string(from: dateFromServer)
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
        cell.nameLbl.text = notificationArray[indexPath.row].name
        cell.detailsLbl.text = notificationArray[indexPath.row].details
        cell.dateLbl.text = notificationArray[indexPath.row].date
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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
