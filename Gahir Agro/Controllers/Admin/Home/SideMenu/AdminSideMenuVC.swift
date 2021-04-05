//
//  AdminSideMenuVC.swift
//  Gahir Agro
//
//  Created by Apple on 17/03/21.
//

import UIKit

class AdminSideMenuVC: UIViewController {
    
    var messgae = String()
    var sideMenuItemsArrayForCustomer : [SideMenuItemsForCustomer] = []{
        didSet{
            settingTBView.reloadData()
        }
    }
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var settingTBView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        sideMenuItemsArrayForCustomer.append(SideMenuItemsForCustomer(name: "Enquiries", selectedImage: "home", selected: true, unselected: "home-1"))
        
        sideMenuItemsArrayForCustomer.append(SideMenuItemsForCustomer(name: "Order List", selectedImage: "order", selected: false, unselected: "order-1"))
        sideMenuItemsArrayForCustomer.append(SideMenuItemsForCustomer(name: "Notifications", selectedImage: "noti", selected: false, unselected: "noti-1"))
        sideMenuItemsArrayForCustomer.append(SideMenuItemsForCustomer(name: "Privacy Policy", selectedImage: "privacy", selected: false, unselected: "privacy-1"))
        sideMenuItemsArrayForCustomer.append(SideMenuItemsForCustomer(name: "Logout", selectedImage: "logout", selected: false, unselected: "logout-1"))
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(_:)), name: .sendUserDataToSideMenu, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showSelected(_:)), name: .sendUserDataToSideMenu, object: nil)
        self.settingTBView.separatorStyle = .none
        // Do any additional setup after loading the view.
    }
    
    @objc func showSelected(_ notification: Notification) {
        sideMenuItemsArrayForCustomer[0].selected = false
        sideMenuItemsArrayForCustomer[1].selected = false
        sideMenuItemsArrayForCustomer[2].selected = false
        sideMenuItemsArrayForCustomer[3].selected = false
        sideMenuItemsArrayForCustomer[4].selected = false
        settingTBView.reloadData()
    }
    
    @objc func notificationReceived(_ notification: Notification) {
        self.getData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = profileImage.frame.height/2
    }
    
    func logout()  {
        UserDefaults.standard.removeObject(forKey: "tokenFString")
        let appDel = UIApplication.shared.delegate as! AppDelegate
        appDel.Logout1()
    }
    
    @IBAction func gotoProfileVC(_ sender: Any) {
        sideMenuController?.hideLeftViewAnimated()
        let vc = AdminProfileVC.instantiate(fromAppStoryboard: .AdminMain)
        (sideMenuController?.rootViewController as! UINavigationController).pushViewController(vc, animated: true)
    }
    
    
    func getData() {
        let url = Constant.shared.baseUrl + Constant.shared.ProfileApi
        var deviceID = UserDefaults.standard.value(forKey: "deviceToken") as? String
        let accessToken = UserDefaults.standard.value(forKey: "accessToken")
        print(deviceID ?? "")
        if deviceID == nil  {
            deviceID = "777"
        }
        let params = ["access_token": accessToken]  as? [String : AnyObject] ?? [:]
        print(params)
        PKWrapperClass.requestPOSTWithFormData(url, params: params, imageData: []) { (response) in
            print(response.data)
            let status = response.data["status"] as? String ?? ""
            self.messgae = response.data["message"] as? String ?? ""
            if status == "1"{
                let allData = response.data["user_detail"] as? [String:Any] ?? [:]
               
                self.profileImage.sd_setImage(with: URL(string:allData["image"] as? String ?? ""), placeholderImage: UIImage(named: "placehlder"))
                self.nameLbl.text = allData["first_name"] as? String ?? ""
                let url = URL(string:allData["image"] as? String ?? "")
                if url != nil{
                    if let data = try? Data(contentsOf: url!)
                    {
                        if let image: UIImage = (UIImage(data: data)){
                            self.profileImage.image = image
                            self.profileImage.contentMode = .scaleToFill
                            IJProgressView.shared.hideProgressView()
                        }
                    }
                }
                else{
                    self.profileImage.image = UIImage(named: "placehlder")
                }
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

class AdminSettingTBViewCell: UITableViewCell {
    
    @IBOutlet weak var namelbl: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}


extension AdminSideMenuVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sideMenuItemsArrayForCustomer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdminSettingTBViewCell", for: indexPath) as! AdminSettingTBViewCell
        cell.namelbl.text = sideMenuItemsArrayForCustomer[indexPath.row].name
        if sideMenuItemsArrayForCustomer[indexPath.row].selected == true{
            cell.namelbl.textColor = #colorLiteral(red: 0.8846299052, green: 0.04529493302, blue: 0, alpha: 1)
            cell.iconImage.image = UIImage(named: sideMenuItemsArrayForCustomer[indexPath.row].unselected)
        }else{
            cell.namelbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.iconImage.image = UIImage(named: sideMenuItemsArrayForCustomer[indexPath.row].selectedImage)
        }
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        sideMenuItemsArrayForCustomer = sideMenuItemsArrayForCustomer.map({ (obj) -> SideMenuItemsForCustomer in
            var mutableObj = obj
            mutableObj.selected = false
            return mutableObj
        })
        
        if sideMenuItemsArrayForCustomer[indexPath.row].name == "Logout"{
            sideMenuItemsArrayForCustomer[indexPath.row].selected = true
        }else{
            sideMenuItemsArrayForCustomer[indexPath.row].selected = true
        }
        sideMenuController?.hideLeftViewAnimated()
        
        if(indexPath.row == 0) {
            let vc = AdminHomeVC.instantiate(fromAppStoryboard: .AdminMain)
            (sideMenuController?.rootViewController as! UINavigationController).pushViewController(vc, animated: true)
        }
        
        else if(indexPath.row == 1) {
            let vc = AdminEnquriesVC.instantiate(fromAppStoryboard: .AdminMain)
            (sideMenuController?.rootViewController as! UINavigationController).pushViewController(vc, animated: true)
        }
        
        else if(indexPath.row == 2) {
            let vc = AdminNotificationVC.instantiate(fromAppStoryboard: .AdminMain)
            (sideMenuController?.rootViewController as! UINavigationController).pushViewController(vc, animated: true)
            
        }
       
        else if(indexPath.row == 3) {
            
            let vc = AdminPrivacyPolicyLinkVC.instantiate(fromAppStoryboard: .AdminMain)
            (sideMenuController?.rootViewController as! UINavigationController).pushViewController(vc, animated: true)
            
        }
        
        else if(indexPath.row == 4) {
            let dialogMessage = UIAlertController(title: Constant.shared.appTitle, message: "Are you sure you want to Logout?", preferredStyle: .alert)
            
            // Create OK button with action handler
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                print("Ok button click...")
                UserDefaults.standard.set(false, forKey: "tokenFString")
                self.logout()
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
