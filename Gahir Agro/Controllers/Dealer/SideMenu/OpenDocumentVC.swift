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
    var pdfDownloadUrl = String()
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
                self.pdfDownloadUrl = allData["dealer_doc"] as? String ?? ""
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
            }else if status == "0"{
                PKWrapperClass.svprogressHudDismiss(view: self)
                alert(Constant.shared.appTitle, message: self.messgae, view: self)
            } else if status == "100"{
                showAlertMessage(title: Constant.shared.appTitle, message: self.messgae, okButton: "Ok", controller: self) {
                    UserDefaults.standard.removeObject(forKey: "tokenFString")
                    let appDel = UIApplication.shared.delegate as! AppDelegate
                    appDel.Logout1()
                }
            }
        } failure: { (error) in
            print(error)
            PKWrapperClass.svprogressHudDismiss(view: self)
            showAlertMessage(title: Constant.shared.appTitle, message: error as? String ?? "", okButton: "Ok", controller: self, okHandler: nil)
        }
    }
    
    func dowloadPdf()  {
        
        if pdfDownloadUrl.isEmpty == true{
            alert(Constant.shared.appTitle, message: "No file available for download", view: self)
        }else{
            PKWrapperClass.svprogressHudShow(title: Constant.shared.appTitle, view: self)
            let url = URL(string: pdfDownloadUrl)
            let fileName = String((url!.lastPathComponent)) as NSString
            // Create destination URL
            let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let destinationFileUrl = documentsUrl.appendingPathComponent("\(fileName)")
            //Create URL to the source file you want to download
            let fileURL = URL(string: pdfDownloadUrl)
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig)
            let request = URLRequest(url:fileURL!)
            let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
                if let tempLocalUrl = tempLocalUrl, error == nil {
                    // Success
                    PKWrapperClass.svprogressHudDismiss(view: self)
                    if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                        print("Successfully downloaded. Status code: \(statusCode)")
                        DispatchQueue.main.async {
                            alert(Constant.shared.appTitle, message: "File saved", view: self)
                        }
                    }
                    do {
                        try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                        do {
                            //Show UIActivityViewController to save the downloaded file
                            let contents  = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
                            for indexx in 0..<contents.count {
                                if contents[indexx].lastPathComponent == destinationFileUrl.lastPathComponent {
                                    let activityViewController = UIActivityViewController(activityItems: [contents[indexx]], applicationActivities: nil)
                                    self.present(activityViewController, animated: true, completion: nil)
                                }
                            }
                        }
                        catch (let err) {
                            print("error: \(err)")
                        }
                    } catch (let writeError) {
                        print("Error creating a file \(destinationFileUrl) : \(writeError)")
                    }
                } else {
                    print("Error took place while downloading a file. Error description: \(error?.localizedDescription ?? "")")
                }
            }
            task.resume()
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
    
    @IBAction func downloadPdfFile(_ sender: Any) {
        //       let url = URL(string: self.pdfDownloadUrl)
        //        FileDownloader.loadFileAsync(url: url!) { (path, error) in
        //            print("PDF File downloaded to : \(path!)")
        //            alert(Constant.shared.appTitle, message: "File saved", view: self)
        //        }
        DispatchQueue.main.async {
            self.dowloadPdf()
        }
    }
}
