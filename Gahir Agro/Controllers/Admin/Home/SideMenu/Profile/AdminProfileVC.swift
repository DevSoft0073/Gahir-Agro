//
//  AdminProfileVC.swift
//  Gahir Agro
//
//  Created by Apple on 17/03/21.
//

import UIKit

class AdminProfileVC: UIViewController {

    @IBOutlet weak var bioTxtView: UITextView!
    @IBOutlet weak var namelbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    var messgae = String()
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var emailtxtFld: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        emailtxtFld.isUserInteractionEnabled = false
        passwordTxtFld.isUserInteractionEnabled = false
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = profileImage.frame.height/2
    }
    
    func getData() {
        PKWrapperClass.svprogressHudShow(title: Constant.shared.appTitle, view: self)
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
            PKWrapperClass.svprogressHudDismiss(view: self)
            let status = response.data["status"] as? String ?? ""
            self.messgae = response.data["message"] as? String ?? ""
            if status == "1"{
                let allData = response.data["user_detail"] as? [String:Any] ?? [:]
                self.namelbl.text = allData["first_name"] as? String ?? ""
                self.bioTxtView.text = allData["bio"] as? String
                self.emailtxtFld.text = allData["username"] as? String
                self.passwordTxtFld.text = "**********"
                self.profileImage.sd_setImage(with: URL(string:allData["image"] as? String ?? ""), placeholderImage: UIImage(named: "placehlder"))
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

    

    @IBAction func openMenu(_ sender: Any) {
        sideMenuController?.showLeftViewAnimated()
    }
    
    
    @IBAction func gotoEditVC(_ sender: Any) {
        let vc = AdminEditProfileVC.instantiate(fromAppStoryboard: .AdminMain)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension Notification.Name {
    public static let sendUserDataToSideMenu = Notification.Name(rawValue: "sendUserData")
}

extension Notification.Name {
    public static let showHomeSelectedAdminSideMenu = Notification.Name(rawValue: "showHomeSelected")
}
