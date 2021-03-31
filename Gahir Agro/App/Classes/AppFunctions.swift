//
//  AppFunctions.swift
//  Nodat
//
//  Created by apple on 30/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation


enum AppStoryboard : String {
    case Auth
    case Main
    case Customer
    case AuthForCustomer
    case SalesAuth
    case SalesMain
    case AdminAuth
    case AdminMain
    
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


extension UIViewController {
    func convertTimeStampToDate(dateVal : Double) -> String{
        let timeinterval = TimeInterval(dateVal)
        let dateFromServer = Date(timeIntervalSince1970:timeinterval)
        print(dateFromServer)
        let dateFormater = DateFormatter()
        dateFormater.timeZone = .current
        dateFormater.dateFormat = "dd-MM-YYYY"
        return dateFormater.string(from: dateFromServer)
    }
}

extension UIViewController {
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)") ?? 0.0
        //21.228124
        let lon: Double = Double("\(pdblLongitude)") ?? 0.0
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
                                    {(placemarks, error) in
                                        if (error != nil)
                                        {
                                            print("reverse geodcode fail: \(error!.localizedDescription)")
                                        }
                                        let pm = placemarks! as [CLPlacemark]
                                        
                                        if pm.count > 0 {
                                            let pm = placemarks![0]
                                            print(pm.country)
                                            print(pm.locality)
                                            UserDefaults.standard.setValue(pm.locality, forKey: "city")
                                            UserDefaults.standard.setValue(pm.subLocality, forKey: "address")
                                            print(pm.subLocality)
                                            print(pm.thoroughfare)
                                            print(pm.postalCode)
                                            print(pm.subThoroughfare)
                                            var addressString : String = ""
                                            if pm.subLocality != nil {
                                                addressString = addressString + pm.subLocality! + ", "
                                            }
                                            if pm.thoroughfare != nil {
                                                addressString = addressString + pm.thoroughfare! + ", "
                                            }
                                            if pm.locality != nil {
                                                addressString = addressString + pm.locality! + ", "
                                            }
                                            if pm.country != nil {
                                                addressString = addressString + pm.country! + ", "
                                            }
                                            if pm.postalCode != nil {
                                                addressString = addressString + pm.postalCode! + " "
                                            }
                                            
                                            
                                            print(addressString)
                                        }
                                    })
        
    }
}
