//
//  AppFunctions.swift
//  Nodat
//
//  Created by apple on 30/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit


enum AppStoryboard : String {
    case Auth
    case Main
    case DealerUI
    
}

extension AppStoryboard {
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T : UIViewController>(viewControllerClass : T.Type, function : String = #function, line : Int = #line, file : String = #file) -> T {
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            fatalError("ViewController with identifier \(storyboardID), not found")
        }
        return scene
    }
    
    func initialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
}

extension UIViewController {
    class var storyboardID : String {
        return "\(self)"
    }
    static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self {
        return appStoryboard.viewController(viewControllerClass: self)
    }
}



extension UIImageView {
    func setRounded() {
        self.layoutIfNeeded()
        self.layer.cornerRadius = (self.frame.width / 2)
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
}
