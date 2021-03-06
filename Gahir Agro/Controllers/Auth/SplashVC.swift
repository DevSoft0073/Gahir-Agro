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
        // Do any additional setup after loading the view.
//        animate(splashImage)
        Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(navigateToLogin), userInfo: nil, repeats: false)

    }
    
    @objc func navigateToLogin() {
        
        let credentials = UserDefaults.standard.value(forKey: "tokenFString") as? Int ?? 0
        if credentials == 1{
            let story = UIStoryboard(name: "Main", bundle: nil)
            let rootViewController:UIViewController = story.instantiateViewController(withIdentifier: "SideMenuControllerID")
            self.navigationController?.pushViewController(rootViewController, animated: true)
        }else if credentials == 0{
            let vc = SignInVC.instantiate(fromAppStoryboard: .Auth)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
