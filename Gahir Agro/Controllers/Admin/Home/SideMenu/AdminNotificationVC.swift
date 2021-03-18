//
//  AdminNotificationVC.swift
//  Gahir Agro
//
//  Created by Apple on 17/03/21.
//

import UIKit

class AdminNotificationVC: UIViewController {
    
    
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
                    newArr.append(NotificationData(name: obj["notify_title"] as? String ?? "", image: "img-1", details: obj["notify_message"] as? String ?? "", date: "12/09/20 9:02 AM"))
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

    @IBAction func openMenu(_ sender: Any) {
        sideMenuController?.showLeftViewAnimated()

    }
}

class AdminNotificationTBViewCell: UITableViewCell {
    
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var timelbl: UILabel!
    @IBOutlet weak var detailsLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension AdminNotificationVC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdminNotificationTBViewCell", for: indexPath) as! AdminNotificationTBViewCell
        cell.showImage.image = UIImage(named: notificationArray[indexPath.row].image)
        cell.showImage.setRounded()
        cell.titleLbl.text = notificationArray[indexPath.row].name
        cell.detailsLbl.text = notificationArray[indexPath.row].details
        cell.timelbl.text = notificationArray[indexPath.row].date
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
                notifationData()
            }
        }
    }
    
}


