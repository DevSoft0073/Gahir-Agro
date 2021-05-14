//
//  AppConstants.swift
//  Nodat
//
//  Created by apple on 30/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit


let kAppName : String = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? "Gahir Agro"
let kAppBundleIdentifier : String = Bundle.main.bundleIdentifier ?? String()

class KeyMessages{
    static let shared = KeyMessages()
    let kNoInternet = "There is no internet connection."
    let kEnterName = "Please enter username."
    let kValidUserName = "Username may only have alpha numeric characters and the special characters (.) (-) (_) and may not begin with special characters."
    let kEnterPhone = "Please enter phone number."
    let kEnterEmailPwd = "Please enter email and password."
    let kEnterEmail = "Please enter email address."
    let kEnterValidEmail = "Invalid email, Please try again."
    let kEnterConfirmEmail = "Please enter confirm email."
    let kEnterPassword = "Please enter password."
    let kEnterConfirmPassword = "Please enter confirm password."
    let kPasswordNotMatch = "Passwords does not matched."
    let kPasswordWeak = "Password must be atleast 6 characters in length. It can be changed later."
    let kEnterZip = "Please enter zip code."
    let kEnterValidZip = "Invalid zipcode. Please enter a correct 5 digit zipcode."
    let kLogout = "Are you sure you want to log out?"
    let kAcceptTerms = "Please read Terms & Conditions and accept for register new account."
}

struct DefaultKeys{
    static let deviceToken = "deviceToken"
    static let token = "AuthToken"
    static let expireValue = "TokenExpire"
    static let id = "userId"
    static let radius = "radius"
}
