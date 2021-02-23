//
//  SideMenuVC.swift
//  Gahir Agro
//
//  Created by Apple on 23/02/21.
//

import UIKit

class SideMenuVC: UIViewController {
    
    var sideMenuItemsArray = [SideMenuItems]()
    @IBOutlet weak var settingTBView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideMenuItemsArray.append(SideMenuItems(name: "Home", selectedImage: "home"))
        sideMenuItemsArray.append(SideMenuItems(name: "Orders", selectedImage: "order"))
        sideMenuItemsArray.append(SideMenuItems(name: "Notifications", selectedImage: "noti"))
        sideMenuItemsArray.append(SideMenuItems(name: "Contact", selectedImage: "contact"))
        sideMenuItemsArray.append(SideMenuItems(name: "Privacy Policy", selectedImage: "privacy"))
        sideMenuItemsArray.append(SideMenuItems(name: "Logout", selectedImage: "logout"))
        
        self.settingTBView.separatorStyle = .none

        // Do any additional setup after loading the view.
    }
    
    
    

}

class SettingTBViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var showImage: UIImageView!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension SideMenuVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sideMenuItemsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTBViewCell", for: indexPath) as! SettingTBViewCell
        cell.nameLbl.text = sideMenuItemsArray[indexPath.row].name
        cell.showImage.image = UIImage(named: sideMenuItemsArray[indexPath.row].selectedImage)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}

struct SideMenuItems {
    var name : String
    var selectedImage : String
    
    init(name : String , selectedImage : String) {
        self.name = name
        self.selectedImage = selectedImage
    }
}
