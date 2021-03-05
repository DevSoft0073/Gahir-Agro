//
//  Constant.swift
//  racinewalker
//
//  Created by Vivek Dharmani on 7/1/20.
//  Copyright © 2020 Vivek Dharmani. All rights reserved.
//

import Foundation

class Constant: NSObject {
    
    static let shared = Constant()
    let appTitle  = "Gahir Agro"
    
    let baseUrl = "https://www.dharmani.com/gahir/api/"
    
    let SignUp = "DealerSignup.php"
    let PhoneLogin = "DealerPhoneLogin.php"
    let SignIn = "DealerLogin.php"
    let ForgotPassword = "ForgotPassword.php"
    let AllProduct = "GetAllProducts.php"
    let ProductDetails = "GetProductDetail.php"
    let contactUS = "ContactUs.php"
    let EditProfile = "UpdateProfile.php"
    let FilterProducts = "FilterProduct.php"
    let SearchData = "SearchProduct.php"
    let ProfileApi = "GetUserProfile.php"
    let RecentSearches = "GetRecentSearch.php"
    let AddEnquiry = "AddEnquiry.php"
    
}

class Singleton  {
   static let sharedInstance = Singleton()
    var currentAddress = [String: Any]()
    var lat = Double()
    var long = Double()
    var authToken = String()
    var isComingFromSubDetailsScreen =  false
    var lastSelectedIndex = 0

}
