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
    @IBOutlet weak var notificationTBView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationTBView.separatorStyle = .none
        
        notificationArray.append(NotificationData(name: "New Notification", image: "img-1", details: "Loreum ipsumor Iipusm as it is sometimes known, is dummy text used in lying out print, graphics or web , designs.", date: "12/09/20 9:02 AM"))
        notificationArray.append(NotificationData(name: "New Notification", image: "img-1", details: "Loreum ipsumor Iipusm as it is sometimes known, is dummy text used in lying out print, graphics or web , designs.", date: "12/09/20 9:02 AM"))
        notificationArray.append(NotificationData(name: "New Notification", image: "img-1", details: "Loreum ipsumor Iipusm as it is sometimes known, is dummy text used in lying out print, graphics or web , designs.", date: "12/09/20 9:02 AM"))
        notificationArray.append(NotificationData(name: "New Notification", image: "img-1", details: "Loreum ipsumor Iipusm as it is sometimes known, is dummy text used in lying out print, graphics or web , designs.", date: "12/09/20 9:02 AM"))
        notificationArray.append(NotificationData(name: "New Notification", image: "img-1", details: "Loreum ipsumor Iipusm as it is sometimes known, is dummy text used in lying out print, graphics or web , designs.", date: "12/09/20 9:02 AM"))
        notificationArray.append(NotificationData(name: "New Notification", image: "img-1", details: "Loreum ipsumor Iipusm as it is sometimes known, is dummy text used in lying out print, graphics or web , designs.", date: "12/09/20 9:02 AM"))
        notificationArray.append(NotificationData(name: "New Notification", image: "img-1", details: "Loreum ipsumor Iipusm as it is sometimes known, is dummy text used in lying out print, graphics or web , designs.", date: "12/09/20 9:02 AM"))
        notificationArray.append(NotificationData(name: "New Notification", image: "img-1", details: "Loreum ipsumor Iipusm as it is sometimes known, is dummy text used in lying out print, graphics or web , designs.", date: "12/09/20 9:02 AM"))
        notificationArray.append(NotificationData(name: "New Notification", image: "img-1", details: "Loreum ipsumor Iipusm as it is sometimes known, is dummy text used in lying out print, graphics or web , designs.", date: "12/09/20 9:02 AM"))


        // Do any additional setup after loading the view.
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
