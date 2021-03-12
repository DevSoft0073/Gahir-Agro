//
//  SideMenuVC.swift
//  Gahir Agro
//
//  Created by Apple on 23/02/21.
//

import UIKit

class SideMenuVC: UIViewController {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    var sideMenuItemsArray : [SideMenuItems] = []{
        didSet{
            settingTBView.reloadData()
        }
    }
    
    var messgae = String()
    @IBOutlet weak var settingTBView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        sideMenuItemsArray.append(SideMenuItems(name: "Home", selectedImage: "home", selected: true, unselected: "home-1"))
        sideMenuItemsArray.append(SideMenuItems(name: "Enquiry List", selectedImage: "order", selected: false, unselected: "order-1"))
        sideMenuItemsArray.append(SideMenuItems(name: "Notifications", selectedImage: "noti", selected: false, unselected: "noti-1"))
        sideMenuItemsArray.append(SideMenuItems(name: "Contact", selectedImage: "contact", selected: false, unselected: "contact-1"))
        sideMenuItemsArray.append(SideMenuItems(name: "Privacy Policy", selectedImage: "privacy", selected: false, unselected: "privacy-1"))
        sideMenuItemsArray.append(SideMenuItems(name: "Logout", selectedImage: "logout", selected: false, unselected: "logout-1"))
        
        self.settingTBView.separatorStyle = .none
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = profileImage.frame.height/2
    }
    
    
    @IBAction func gotoProfile(_ sender: Any) {
        sideMenuController?.hideLeftViewAnimated()
        let vc = ProfileVC.instantiate(fromAppStoryboard: .Main)
        (sideMenuController?.rootViewController as! UINavigationController).pushViewController(vc, animated: true)
    }
    
    func logout()  {
        UserDefaults.standard.removeObject(forKey: "tokenFString")
        let appDel = UIApplication.shared.delegate as! AppDelegate
        appDel.Logout1()
    }
    
    func getData() {
//        PKWrapperClass.svprogressHudShow(title: Constant.shared.appTitle, view: self)
        let url = Constant.shared.baseUrl + Constant.shared.ProfileApi
        var deviceID = UserDefaults.standard.value(forKey: "deviceToken") as? String
        let accessToken = UserDefaults.standard.value(forKey: "accessToken")
        print(deviceID ?? "")
        if deviceID == nil  {
            deviceID = "777"
        }
        let params = ["access_token": accessToken]  as? [String : AnyObject] ?? [:]
        print(params)
        PKWrapperClass.requestPOSTWithFormData(url, params: params, imageData: [[:]]) { (response) in
            print(response.data)
//            PKWrapperClass.svprogressHudDismiss(view: self)
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
            showAlertMessage(title: Constant.shared.appTitle, message: error as? String ?? "", okButton: "Ok", controller: self, okHandler: nil)
        }
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
        if sideMenuItemsArray[indexPath.row].selected == true{
            cell.nameLbl.textColor = #colorLiteral(red: 0.8846299052, green: 0.04529493302, blue: 0, alpha: 1)
            cell.showImage.image = UIImage(named: sideMenuItemsArray[indexPath.row].unselected)
        }else{
            cell.nameLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.showImage.image = UIImage(named: sideMenuItemsArray[indexPath.row].selectedImage)
        }
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        sideMenuItemsArray = sideMenuItemsArray.map({ (obj) -> SideMenuItems in
            var mutableObj = obj
            mutableObj.selected = false
            return mutableObj
        })
        sideMenuItemsArray[indexPath.row].selected = true
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
            let vc = NotificationVC.instantiate(fromAppStoryboard: .Main)
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

struct SideMenuItems {
    var name : String
    var selectedImage : String
    var unselected : String
    var selected : Bool
    
    init(name : String , selectedImage : String,selected : Bool,unselected : String) {
        self.name = name
        self.selectedImage = selectedImage
        self.selected = selected
        self.unselected = unselected
    }
}
