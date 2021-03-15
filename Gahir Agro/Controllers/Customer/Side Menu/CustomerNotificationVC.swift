//
//  CustomerNotificationVC.swift
//  Gahir Agro
//
//  Created by Apple on 15/03/21.
//

import UIKit
import LGSideMenuController

class CustomerNotificationVC: UIViewController {
    
    var messgae = String()
    var lastPage = Bool()
    var page = 1
    var notificationArray = [CustomerNotificationData]()
    @IBOutlet weak var notificationTBView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationArray.append(CustomerNotificationData(name: "New Notification", image: "img-1", details: "Loreum ipsumor Iipusm as it is sometimes known, is dummy text used in lying out print, graphics or web , designs.", date: "12/09/20 9:02 AM"))
        notificationArray.append(CustomerNotificationData(name: "New Notification", image: "img-1", details: "Loreum ipsumor Iipusm as it is sometimes known, is dummy text used in lying out print, graphics or web , designs.", date: "12/09/20 9:02 AM"))
        notificationArray.append(CustomerNotificationData(name: "New Notification", image: "img-1", details: "Loreum ipsumor Iipusm as it is sometimes known, is dummy text used in lying out print, graphics or web , designs.", date: "12/09/20 9:02 AM"))
        notificationArray.append(CustomerNotificationData(name: "New Notification", image: "img-1", details: "Loreum ipsumor Iipusm as it is sometimes known, is dummy text used in lying out print, graphics or web , designs.", date: "12/09/20 9:02 AM"))
        notificationArray.append(CustomerNotificationData(name: "New Notification", image: "img-1", details: "Loreum ipsumor Iipusm as it is sometimes known, is dummy text used in lying out print, graphics or web , designs.", date: "12/09/20 9:02 AM"))
        notificationArray.append(CustomerNotificationData(name: "New Notification", image: "img-1", details: "Loreum ipsumor Iipusm as it is sometimes known, is dummy text used in lying out print, graphics or web , designs.", date: "12/09/20 9:02 AM"))
        notificationArray.append(CustomerNotificationData(name: "New Notification", image: "img-1", details: "Loreum ipsumor Iipusm as it is sometimes known, is dummy text used in lying out print, graphics or web , designs.", date: "12/09/20 9:02 AM"))
        notificationArray.append(CustomerNotificationData(name: "New Notification", image: "img-1", details: "Loreum ipsumor Iipusm as it is sometimes known, is dummy text used in lying out print, graphics or web , designs.", date: "12/09/20 9:02 AM"))
        notificationArray.append(CustomerNotificationData(name: "New Notification", image: "img-1", details: "Loreum ipsumor Iipusm as it is sometimes known, is dummy text used in lying out print, graphics or web , designs.", date: "12/09/20 9:02 AM"))
        notificationTBView.reloadData()
        
        // Do any additional setup after loading the view.
    }
}

class NotificationTBViewCellForCustomer: UITableViewCell {
    
    @IBOutlet weak var detailsLbl: UILabel!
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var dataLbl: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension CustomerNotificationVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTBViewCellForCustomer", for: indexPath) as! NotificationTBViewCellForCustomer
        cell.dataLbl.text = notificationArray[indexPath.row].name
        cell.detailsLbl.text = notificationArray[indexPath.row].details
        cell.dateTimeLbl.text = notificationArray[indexPath.row].date
        cell.iconImage.image = UIImage(named: notificationArray[indexPath.row].image)
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
//                notifationData()
            }
        }else{
            let bottamEdge = Float(self.notificationTBView.contentOffset.y + self.notificationTBView.frame.size.height)
            if bottamEdge >= Float(self.notificationTBView.contentSize.height) && notificationArray.count > 0 {
//                notifationData()
            }
        }
    }
}

struct CustomerNotificationData {
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
