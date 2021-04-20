//
//  OpenDocumentVC.swift
//  Gahir Agro
//
//  Created by Apple on 20/04/21.
//

import UIKit
import Foundation
import LGSideMenuController
import WebKit

class OpenDocumentVC : UIViewController ,WKNavigationDelegate{
    
    var messgae = String()
    
    @IBOutlet weak var openPdf: WKWebView!
    
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //------------------------------------------------------
    
    deinit { //same like dealloc in ObjectiveC
        
    }
    
    //MARK: Custome
    
    //------------------------------------------------------
    
    //MARK: Webview Function
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        PKWrapperClass.svprogressHudDismiss(view: self)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        alert(Constant.shared.appTitle, message: error.localizedDescription, view: self)
        PKWrapperClass.svprogressHudDismiss(view: self)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        if let response = navigationResponse.response as? HTTPURLResponse {
            if response.statusCode == 401 {
                // ...
            }
        }
        decisionHandler(.allow)
    }
    
    
    //------------------------------------------------------
    
    //MARK: Service Call
    
    func getData() {
        PKWrapperClass.svprogressHudShow(title: Constant.shared.appTitle, view: self)
        let url = Constant.shared.baseUrl + Constant.shared.ProfileApi
        var deviceID = UserDefaults.standard.value(forKey: "deviceToken") as? String
        let accessToken = UserDefaults.standard.value(forKey: "accessToken")
        print(deviceID ?? "")
        if deviceID == nil  {
            deviceID = "777"
        }
        let params = ["access_token": accessToken]  as? [String : AnyObject] ?? [:]
        print(params)
        PKWrapperClass.requestPOSTWithFormData(url, params: params, imageData: []) { (response) in
            print(response.data)
            PKWrapperClass.svprogressHudDismiss(view: self)
            let status = response.data["status"] as? String ?? ""
            self.messgae = response.data["message"] as? String ?? ""
            if status == "1"{
                let allData = response.data["user_detail"] as? [String:Any] ?? [:]
                print(allData)
                let pdfUrl = allData["dealer_doc"] as? String ?? ""
                if pdfUrl.isEmpty == true{
                    
                }else{
                    let trimmedUrl = pdfUrl.trimmingCharacters(in: CharacterSet(charactersIn: "")).replacingOccurrences(of: "", with: "%20")
                    let url = URL(string: trimmedUrl)
                    let urlRequest = URLRequest(url: url!)
                    PKWrapperClass.svprogressHudDismiss(view: self)
                    self.openPdf.load(urlRequest)
                    self.openPdf.autoresizingMask = [.flexibleWidth,.flexibleHeight]
                    self.view.addSubview(self.openPdf)
                }
            }else{
                PKWrapperClass.svprogressHudDismiss(view: self)
                alert(Constant.shared.appTitle, message: self.messgae, view: self)
            }
        } failure: { (error) in
            print(error)
            PKWrapperClass.svprogressHudDismiss(view: self)
            showAlertMessage(title: Constant.shared.appTitle, message: error as? String ?? "", okButton: "Ok", controller: self, okHandler: nil)
        }
    }
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //------------------------------------------------------
    
    //MARK:- Action
    
    @IBAction func btnBack(_ sender: Any) {
        sideMenuController?.showLeftViewAnimated()
    }
}
