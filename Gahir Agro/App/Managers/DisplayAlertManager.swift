//
//  DisplayAlertManager.swift
//  Nodat
//
//  Created by apple on 05/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit
class DisplayAlertManager : NSObject, UITextFieldDelegate {
    
    static var shared = DisplayAlertManager()
    
    //------------------------------------------------------
    
    //MARK: Customs
    
//    func displayAlert(target : AnyObject? = nil, animated : Bool, message : String, okTitle: String, handlerOK:(()->Void)?) {
//
//        if let controller : UIViewController = UIApplication.topViewController() {
//
//            let alertController = UIAlertController(title: kAppName, message: message, preferredStyle: UIAlertController.Style.alert)
//
//            let actionOK = UIAlertAction(title: okTitle, style: UIAlertAction.Style.default) { (OK : UIAlertAction) in
//
//                handlerOK?()
//            }
//
//            alertController .addAction(actionOK)
//            controller .present(alertController, animated: animated, completion: nil)
//        }
//    }
//
//
//    func displayAlertWithCancelOk(target : UIViewController, animated : Bool, message : String, alertTitleOk: String, alertTitleCancel: String, handlerCancel:@escaping (()->Void?), handlerOk:@escaping (()->Void?)) {
//        
//        let alertController = UIAlertController(title: kAppName, message: message, preferredStyle: UIAlertController.Style.alert)
//        
//        let actionCancel = UIAlertAction(title: alertTitleCancel, style: UIAlertAction.Style.default) { (CANCEL : UIAlertAction) in
//            
//            handlerCancel()
//        }
//        
//        let actionSave = UIAlertAction(title: alertTitleOk, style: UIAlertAction.Style.default) { (SAVE : UIAlertAction) in
//            
//            handlerOk()
//        }
//        
//        alertController .addAction(actionCancel)
//        alertController .addAction(actionSave)
//        
//        target.present(alertController, animated: animated, completion: nil)
//    }
}
