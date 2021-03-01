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
    
    
    @IBAction func gotoProfile(_ sender: Any) {
        let vc = ProfileVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(vc, animated: true)
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
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        sideMenuController?.hideLeftViewAnimated()
        
        if(indexPath.row == 0) {
            let vc = HomeVC.instantiate(fromAppStoryboard: .Main)
            (sideMenuController?.rootViewController as! UINavigationController).pushViewController(vc, animated: true)
        }
        
        else if(indexPath.row == 1) {
            let vc = MyOrderVC.instantiate(fromAppStoryboard: .Main)
            (sideMenuController?.rootViewController as! UINavigationController).pushViewController(vc, animated: true)
            //            guard let url = URL(string: "https://stackoverflow.com") else { return }
            //            UIApplication.shared.open(url)
            //
        }
        
        else if(indexPath.row == 2) {
            let vc = EnquiryVC.instantiate(fromAppStoryboard: .DealerUI)
            (sideMenuController?.rootViewController as! UINavigationController).pushViewController(vc, animated: true)
            
        }
        
        else if(indexPath.row == 3) {
            let vc = ContactUsVC.instantiate(fromAppStoryboard: .Main)
            (sideMenuController?.rootViewController as! UINavigationController).pushViewController(vc, animated: true)
        }
        
        else if(indexPath.row == 4) {
            
            guard let url = URL(string: "https://stackoverflow.com") else { return }
            UIApplication.shared.open(url)
            
        }
        
        else if(indexPath.row == 5) {
            let dialogMessage = UIAlertController(title: Constant.shared.appTitle, message: "Are you sure you want to Logout?", preferredStyle: .alert)
            
            // Create OK button with action handler
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                print("Ok button click...")
                UserDefaults.standard.set(false, forKey: "tokenFString")
                //                self.logout()
            })
            
            // Create Cancel button with action handlder
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                print("Cancel button click...")
            }
            
            //Add OK and Cancel button to dialog message
            dialogMessage.addAction(ok)
            dialogMessage.addAction(cancel)
            
            // Present dialog message to user
            self.present(dialogMessage, animated: true, completion: nil)
        }
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
