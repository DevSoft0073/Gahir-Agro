//
//  SideMenuController.swift
//  Villar Scentral
//
//  Created by Vivek Dharmani on 08/12/20.
//

import UIKit
import LGSideMenuController

class SideMenuController: LGSideMenuController , LGSideMenuDelegate {

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
