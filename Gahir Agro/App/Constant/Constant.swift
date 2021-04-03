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
    
    //MARK:-> Dealer Flow Api's
    
    let baseUrl = "https://www.dharmani.com/gahir/api/"
    
    
    let VerifyDealer = "VerifyDealer.php"
    let VerifyCustomer = "VerifyCustomer.php"
    let PhoneLogin = "PhoneLogin.php"
    
    
    let SignUp = "DealerSignup.php"
    let SignIn = "EmailLogin.php"
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
    let EnquiryListing = "GetAllEnquiries.php"
    let AllOrders = "GetAllOrders.php"
    let BookOrder = "AddOrder.php"
    let Notification = "GetAllNotifications.php"
    let ChangePassword = "ChangePassword.php"
    let UpdateLocation = "UpdateLocation.php"
    let EnquiryDetails = "GetEnquiryDetail.php"
    let OrderDetails = "GetOrderDetail.php"
    
    //MARK:-> Customer Flow Api's
    
    let CustomerLogin = "CustomerPhoneLogin.php"
    let CustomerSignUp = "VerifyCustomer.php"
    let CustomerNewSignUp = "CustomerSignup.php"
    
    //MARK:-> Admin Flow Api's
    
    let AdminSignIn = "AdminLogin.php"
    let AllDealerEnquries = "GetDealerEnquiries.php"
    let AllDealerOrder = "GetDealerOrders.php"
    
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

struct LocationData {
    var long : Double
    var lat : Double
    
    init(long : Double,lat : Double ) {
        self.lat = lat
        self.long = long
    }
}
