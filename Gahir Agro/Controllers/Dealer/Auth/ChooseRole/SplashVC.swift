//
//  SplashVC.swift
//  Gahir Agro
//
//  Created by Apple on 26/02/21.
//

import UIKit

class SplashVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(navigateToLogin), userInfo: nil, repeats: false)

    }
    
//    MARK:- Nevigate to login
    
    @objc func navigateToLogin() {
        
        let credentials = UserDefaults.standard.value(forKey: "tokenFString") as? Int ?? 0
        if credentials == 1{
            let selectedRole = UserDefaults.standard.value(forKey: "checkRole") as? String
            if selectedRole == "Dealer"{
                let story = UIStoryboard(name: "Main", bundle: nil)
                let rootViewController:UIViewController = story.instantiateViewController(withIdentifier: "SideMenuControllerID")
                self.navigationController?.pushViewController(rootViewController, animated: true)
            }else if selectedRole == "Customer"{
                let story = UIStoryboard(name: "Main", bundle: nil)
                let rootViewController:UIViewController = story.instantiateViewController(withIdentifier: "SideMenuControllerID")
                self.navigationController?.pushViewController(rootViewController, animated: true)
            }else if selectedRole == "admin"{
                let story = UIStoryboard(name: "AdminMain", bundle: nil)
                let rootViewController:UIViewController = story.instantiateViewController(withIdentifier: "AdminSideMenuControllerID")
                self.navigationController?.pushViewController(rootViewController, animated: true)
            }else if selectedRole == "Sales"{
                let story = UIStoryboard(name: "AdminMain", bundle: nil)
                let rootViewController:UIViewController = story.instantiateViewController(withIdentifier: "AdminSideMenuControllerID")
                self.navigationController?.pushViewController(rootViewController, animated: true)
            }
            
        }else if credentials == 0{
            UserDefaults.standard.removeObject(forKey: "accessToken")
            UserDefaults.standard.setValue(false, forKey: "comesFromLogout")
            let story = UIStoryboard(name: "Main", bundle: nil)
            let rootViewController:UIViewController = story.instantiateViewController(withIdentifier: "SideMenuControllerID")
            self.navigationController?.pushViewController(rootViewController, animated: true)
        }
    }
    
}
