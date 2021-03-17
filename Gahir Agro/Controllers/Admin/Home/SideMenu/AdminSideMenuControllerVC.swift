//
//  AdminSideMenuControllerVC.swift
//  Gahir Agro
//
//  Created by Apple on 17/03/21.
//

import UIKit
import LGSideMenuController

class AdminSideMenuControllerVC: LGSideMenuController , LGSideMenuDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        leftViewPresentationStyle = LGSideMenuPresentationStyle.slideAbove
        leftViewWidth = self.view.frame.size.width - 80.0
        sideMenuController?.delegate = self;
    }
    
    func didShowLeftView(_ leftView: UIView, sideMenuController: LGSideMenuController) {
        
    }
    func willShowLeftView(_ leftView: UIView, sideMenuController: LGSideMenuController) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SideMenuOpen"), object: nil)
    }

}
