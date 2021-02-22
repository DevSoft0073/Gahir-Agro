//
//  ValidationManager.swift
//  Nodat
//
//  Created by apple on 05/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
//import NVActivityIndicatorView

enum RegularExpressions: String {
    case url = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
    //case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    case email = "^(([\\w-]+\\.)+[\\w-]+|([a-zA-Z]{1}|[\\w-]{2,}))@((([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\.([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\.([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\.([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])){1}|([a-zA-Z]+[\\w-]+\\.)+[a-zA-Z]{2,4})$"
    case phone = "^\\s*(?:\\+?(\\d{1,3}))?([-. (]*(\\d{3})[-. )]*)?((\\d{3})[-. ]*(\\d{2,4})(?:[-.x ]*(\\d+))?)\\s*$"
    case password8AS = "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}"
    case password82US2N3L = "^(?=.*[A-Z].*[A-Z])(?=.*[!@#$&*])(?=.*[0-9].*[0-9])(?=.*[a-z].*[a-z].*[a-z]).{8}$"
    case username = "^[a-zA-Z][a-zA-Z.-_]*"
    case zipCode = "^[0-9]{5}(-[0-9]{4})?$"
}


class ValidationManager: NSObject {
    
    let kNameMinLimit = 2
    let kPasswordMinLimit = 5
    let kPasswordMaxLimit = 20
    
    //------------------------------------------------------
           
    //MARK: Shared
              
    static let shared = ValidationManager()
   
    //------------------------------------------------------
    
    //MARK: Private
    
    private func isValid(input: String, matchesWith regex: String) -> Bool {
        let matches = input.range(of: regex, options: .regularExpression)
        return matches != nil
    }
    
    //------------------------------------------------------
    
    //MARK: Public
    
//    func isEmpty(text : String?) -> Bool {
//        return text?.toTrim().isEmpty ?? true
//    }
//    
    func isValid(text: String, for regex: RegularExpressions) -> Bool {
        
        return isValid(input: text, matchesWith: regex.rawValue)
    }
    
    func isValidConfirm(password : String, confirmPassword : String) -> Bool{
        if password == confirmPassword {
            return true
        } else {
            return false
        }
    }
    
    func isValid(year: String) -> Bool {
        
        let calender = Calendar.current
        let calenderYear = calender.component(.year, from: Date())
        
        if let intYear = Int(year), intYear > 999, intYear <= calenderYear {
            return true
        } else {
            return false
        }
    }
    
    func isValidBirth(date: Date) -> Bool {
        
        let now = Date()
        let calendar = Calendar.current
        
        let ageComponents = calendar.dateComponents([.year], from: date, to: now)
        if let age = ageComponents.year, age > 5 && age < 110 {
            return true
        }
        return false
    }
}


extension UIViewController {
    
    func ValidateData(strMessage: String)
    {
        let alert = UIAlertController(title: Constant.shared.appTitle, message: strMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
