//
//  AppDelegate.swift
//  Gahir Agro
//
//  Created by Apple on 22/02/21.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import UserNotifications
import CoreLocation

func appDelegate() -> AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
}


@main
class AppDelegate: UIResponder, UIApplicationDelegate , LocationServiceDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        FirebaseApp.configure()
        LocationService.sharedInstance.startUpdatingLocation()
        LocationService.sharedInstance.isLocateSuccess = false
        LocationService.sharedInstance.delegate = self
        
        guard #available(iOS 13.0, *) else {
            setUpInitialScreen()
            return true
        }
        configureNotification(application: application)
        return true
    }
    
    
    func setUpInitialScreen(){
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Splash", bundle: nil)
        let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "SplashVC") as! SplashVC
        let nav = UINavigationController(rootViewController: homeViewController)
        nav.setNavigationBarHidden(true, animated: true)
        appdelegate.window?.rootViewController = nav
    }
    
    
    func getAddressForLocation(locationAddress: String, currentAddress: [String : Any]) {
        print(locationAddress)
        print(currentAddress)
        LocationData.init(long: Double(currentAddress["lat"] as? String ?? "") ?? 0.0, lat: Double(currentAddress["long"] as? String ?? "") ?? 0.0)
        
        Singleton.sharedInstance.lat = Double(currentAddress["lat"] as? String ?? "") ?? 0.0
        Singleton.sharedInstance.long = Double(currentAddress["long"] as? String ?? "") ?? 0.0
        
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}


//MARK:- Push notifications method(s)

extension AppDelegate: UNUserNotificationCenterDelegate{
    
    
    func configureNotification(application: UIApplication) {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        }else{
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
        }
        UIApplication.shared.registerForRemoteNotifications()
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if let userInfo = response.notification.request.content.userInfo as? [String:Any]{
            print(userInfo)
            let allData = userInfo["aps"] as? [String:Any] ?? [:]
            let alertData = userInfo["alert"] as? [String:Any] ?? [:]
            print(alertData)
//            let title = alertData["title"] as? String ?? ""
//            let body = alertData["body"] as? String ?? ""
//            redirectToHotOffer(title: title, body: body)
        }
        completionHandler()
    }
    
    func redirectToHotOffer(title: String, body: String){
        let vc = BookOrderVC.instantiate(fromAppStoryboard: .Main)
        vc.status = title
        vc.productTitle = body
        let nav = UINavigationController(rootViewController: vc)
        nav.setNavigationBarHidden(true, animated: true)
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.window?.rootViewController = nav
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print(deviceTokenString)
        UserDefaults.standard.set(deviceTokenString, forKey: DefaultKeys.deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNs registration failed: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let userDict = userInfo as! [String:Any]
        print("received", userDict)
        if application.applicationState == .inactive{
            
        }else{
            print("not invoked cause its in foreground")
        }
    }
    
    //MARK:- Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound,.alert,.badge])
    }
}



@available(iOS 10.0, *)
extension AppDelegate {
    func getLoggedUser(){
        let credentials = UserDefaults.standard.value(forKey: "tokenFString") as? Int
        if credentials == 1{
            
            let navigationController: UINavigationController? = (self.window?.rootViewController as? UINavigationController)
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            let rootVc = storyBoard.instantiateViewController(withIdentifier: "SideMenuControllerID") as! SideMenuController
            navigationController?.pushViewController(rootVc, animated: false)
            
        }else if credentials == 0{
            
            let navigationController: UINavigationController? = (self.window?.rootViewController as? UINavigationController)
            let storyBoard = UIStoryboard.init(name: "Auth", bundle: nil)
            let rootVc = storyBoard.instantiateViewController(withIdentifier: "SignInWithVC") as! SignInWithVC
            navigationController?.pushViewController(rootVc, animated: false)
            
        }
    }
    
    func Logout1(){
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
        let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "SignInWithVC") as! SignInWithVC
        let nav = UINavigationController(rootViewController: homeViewController)
        nav.setNavigationBarHidden(true, animated: true)
        appdelegate.window?.rootViewController = nav
    }
}

