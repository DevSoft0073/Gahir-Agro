//
//  PKWrapperClass.swift
//  Nodat
//
//  Created by apple on 05/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SVProgressHUD


class PKWrapperClass{
    class func requestPOSTURL(_ strURL : String, params : Parameters, encoding: ParameterEncoding, success:@escaping (_ response: SuccessModal) -> Void, failure:@escaping (NSError) -> Void){
        if !Reachability.isConnectedToNetwork(){
            self.showCustomAlert(title: kAppName, msg: KeyMessages.shared.kNoInternet, vc: nil, buttonTitle: "Ok")
            return
        }
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        AF.request(urlwithPercentEscapes!, method: .post, parameters: params, encoding: encoding, headers: ["Content-Type":"application/json"])
            .responseJSON { (response) in
                switch response.result{
                case .success(let json):
                    let resJson = json as! NSDictionary
                    let responseCode = response.response?.statusCode ?? -10
                    success(SuccessModal(statusCode: responseCode, data: resJson))
                case .failure(let error):
                    let error : NSError = error as NSError
                    failure(error)
                }
        }
    }


    class func requestPOSTURLWithHeaders(_ strURL : String, params : Parameters,headers: [String:Any], encoding: ParameterEncoding, success:@escaping (NSDictionary) -> Void, failure:@escaping (NSError) -> Void){
        if !Reachability.isConnectedToNetwork(){
            self.showCustomAlert(title: kAppName, msg: KeyMessages.shared.kNoInternet, vc: nil, buttonTitle: "Ok")
            return
        }
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        AF.request(urlwithPercentEscapes!, method: .post, parameters: params, encoding: encoding, headers: headers as? HTTPHeaders)
            .responseJSON { (response) in
                switch response.result{
                case .success(let json):
                    let resJson = json as! NSDictionary
                    success(resJson)
                case .failure(let error):
                    let error : NSError = error as NSError
                    failure(error)
                }
        }
    }


    class func requestPUTWithHeaders(_ strURL : String, params : Parameters,headers: HTTPHeaders, encoding: ParameterEncoding, success:@escaping (SuccessModal) -> Void, failure:@escaping (NSError) -> Void){
        if !Reachability.isConnectedToNetwork(){
            
            self.showCustomAlert(title: kAppName, msg: KeyMessages.shared.kNoInternet, vc: nil, buttonTitle: "Ok")
            return
        }
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        AF.request(urlwithPercentEscapes!, method: .put, parameters: params, encoding: encoding, headers: headers)
            .responseJSON { (response) in
                switch response.result{
                case .success(let json):
                    if let responseJson = json as? NSDictionary{
                        let responseCode = response.response?.statusCode ?? -10
                        success(SuccessModal(statusCode: responseCode, data: responseJson))
                    }
                case .failure(let error):
                    let error : NSError = error as NSError
                    failure(error)
                }
        }
    }


    class func requestPOSTWithFormData(_ strURL : String, params : [String : AnyObject]?,imageData:[[String:Any]], success:@escaping (SuccessModal) -> Void, failure:@escaping (Error) -> Void) {
        if !Reachability.isConnectedToNetwork(){
            self.showCustomAlert(title: kAppName, msg: KeyMessages.shared.kNoInternet, vc: nil, buttonTitle: "Ok")
            return
        }
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        AF.upload(multipartFormData: { (multipartData) in
            for (key, value) in params!{
                multipartData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
            }
            if imageData.count > 0{
                for obj in imageData{
                    let name = obj["param"] as? String ?? ""
                    let data = obj["imageData"] as? Data ?? Data()
                    multipartData.append(data, withName: name, fileName: randomString(length: 6)+".jpg", mimeType: "image/jpeg")
                }
            }
        }, to: urlwithPercentEscapes!, method: .post).responseJSON(completionHandler: { (response) in
            switch response.result{
            case .success(let json):
                if let responseJson = json as? NSDictionary{
                    let responseCode = response.response?.statusCode ?? -10
                    success(SuccessModal(statusCode: responseCode, data: responseJson))
                }
                print(json)
            case .failure(let error):
                 failure(error)
                print(error.localizedDescription)
            }
        })
    }


    class func requestGETURL(_ strURL : String, success:@escaping (NSDictionary) -> Void, failure:@escaping (NSError) -> Void){
        if !Reachability.isConnectedToNetwork(){
            self.showCustomAlert(title: kAppName, msg: KeyMessages.shared.kNoInternet, vc: nil, buttonTitle: "Ok")
            return
        }
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        AF.request(urlwithPercentEscapes!, method: .get, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json"])
            .responseJSON { (response) in

                switch response.result{
                case .success(let json):
                    let resJson = json as! NSDictionary
                    success(resJson)
                case .failure(let error):
                    let error : NSError = error as NSError
                    failure(error)
                }
        }

    }
    
    class func showCustomAlert(title: String, msg: String,vc: UIViewController?, buttonTitle: String){
        let alertVC = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: { (action) in
            
        }))
        if vc != nil{
            vc!.present(alertVC, animated: true, completion: nil)
        }else{
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
                appDelegate.window?.rootViewController?.present(alertVC, animated: true, completion: nil)
            }
        }
    }
    
    class func svprogressHudShow(title:String,view:UIViewController) -> Void
    {
        SVProgressHUD.show()
        SVProgressHUD.setDefaultAnimationType(SVProgressHUDAnimationType.flat)
        SVProgressHUD.setForegroundColor(#colorLiteral(red: 0.8141649961, green: 0.03778114915, blue: 0, alpha: 1))
        SVProgressHUD.setFont(UIFont(name: "Avenir-Black", size: 17)!)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.setRingThickness(2)
        SVProgressHUD.setBackgroundColor(.clear)
        DispatchQueue.main.async {
            view.view.isUserInteractionEnabled = false;
        }
    }
    class func svprogressHudDismiss(view:UIViewController) -> Void
    {
        SVProgressHUD.dismiss();
        DispatchQueue.main.async {
            view.view.isUserInteractionEnabled = true;
        }
    }
    
    class func getRole()->Role{
        return Role(rawValue: UserDefaults.standard.value(forKey: "role") as? String ?? "") ?? .dealer
    }
}
func randomString(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0..<length).map{ _ in letters.randomElement()! })
}
   
