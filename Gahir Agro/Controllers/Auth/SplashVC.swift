//
//  SplashVC.swift
//  Gahir Agro
//
//  Created by Apple on 26/02/21.
//

import UIKit

class SplashVC: UIViewController {
    
    @IBOutlet weak var splashImage: UIImageView!
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
    
//    func getLoggedUser(){
//        var credentials = Bool()
//        credentials = UserDefaults.standard.bool(forKey: "tokenFString")
//        if credentials == true{
//            let storyBoard = UIStoryboard.init(name: "Auth", bundle: nil)
//            let vc = storyBoard.instantiateViewController(withIdentifier: "SignInWithVC") as! SignInWithVC
//            self.navigationController?.pushViewController(vc, animated: false)
//        }else{
//            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
//            let rootVc = storyBoard.instantiateViewController(withIdentifier: "SideMenuControllerID") as! SideMenuController
//            navigationController?.pushViewController(rootVc, animated: false)
//        }
//    }
    
    func animate(_ image: UIImageView) {
        self.splashImage.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.splashImage.transform = .identity

            self.schedule()
        }, completion:nil)
    }
    
    func schedule() {
        DispatchQueue.main.async {
            _ = Timer.scheduledTimer(timeInterval: 3, target: self,
                                     selector: #selector(self.timerDidFire(timer:)), userInfo: nil, repeats: false)
        }
    }
    
    @objc private func timerDidFire(timer: Timer) {
        let storyBoard = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "SignInWithVC") as! SignInWithVC
        self.navigationController?.pushViewController(vc, animated: false)
//        self.getLoggedUser()
    }
    
    
}
