//
//  ProfileVC.swift
//  Gahir Agro
//
//  Created by Apple on 24/02/21.
//

import UIKit
import LGSideMenuController
import SDWebImage

class ProfileVC: UIViewController, CAAnimationDelegate {

    @IBOutlet weak var nameLbl: UILabel!
    var messgae = String()
    @IBOutlet weak var bioTxtView: UITextView!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var emailtxtFld: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailtxtFld.isUserInteractionEnabled = false
        passwordTxtFld.isUserInteractionEnabled = false

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = profileImage.frame.height/2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
        PKWrapperClass.requestPOSTWithFormData(url, params: params, imageData: [[:]]) { (response) in
            print(response.data)
            PKWrapperClass.svprogressHudDismiss(view: self)
            let status = response.data["status"] as? String ?? ""
            self.messgae = response.data["message"] as? String ?? ""
            if status == "1"{
                let allData = response.data["user_detail"] as? [String:Any] ?? [:]
                self.nameLbl.text = allData["first_name"] as? String ?? ""
                let fullName = "\(allData["first_name"] as? String ?? "")" + "\(allData["last_name"] as? String ?? "")"
                self.bioTxtView.text = allData["bio"] as? String
                self.emailtxtFld.text = allData["username"] as? String
                self.passwordTxtFld.text = "**********"
                self.profileImage.sd_setImage(with: URL(string:allData["image"] as? String ?? ""), placeholderImage: UIImage(named: "placehlder"))
                let userInfo = [ "name" : fullName, "profileImage" : allData["image"] as? String ?? "" ]
                NotificationCenter.default.post(name: .sendUserData, object: nil, userInfo: userInfo as [AnyHashable : Any])
                

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

    
    
    @IBAction func gotoEditProfile(_ sender: Any) {
        let vc = EditProfileVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func menuButton(_ sender: Any) {
        sideMenuController?.showLeftViewAnimated()
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let controller = storyBoard.instantiateViewController(withIdentifier: "SideMenuControllerID") as UIViewController
//        let transition = CATransition.init()
//        transition.duration = 0.45
//        transition.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.default)
//        transition.type = CATransitionType.push //Transition you want like Push, Reveal
//        transition.subtype = CATransitionSubtype.fromLeft // Direction like Left to Right, Right to Left
//        
//        transition.delegate = self
//        view.window!.layer.add(transition, forKey: kCATransition)
//        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
}

extension Notification.Name {
    public static let sendUserData = Notification.Name(rawValue: "sendUserData")
}
