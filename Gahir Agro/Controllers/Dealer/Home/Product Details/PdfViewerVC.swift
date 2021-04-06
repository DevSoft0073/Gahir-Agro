//
//  PdfViewerVC.swift
//  Gahir Agro
//
//  Created by Apple on 20/03/21.
//

import UIKit
import WebKit

class PdfViewerVC: UIViewController , WKNavigationDelegate {

   
    @IBOutlet weak var openPdfUrl: WKWebView!
    var pdfUrl = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let trimmedUrl = pdfUrl.trimmingCharacters(in: CharacterSet(charactersIn: "")).replacingOccurrences(of: "", with: "%20")
        let url = URL(string: trimmedUrl)
        let urlRequest = URLRequest(url: url!)

        openPdfUrl.load(urlRequest)
        openPdfUrl.autoresizingMask = [.flexibleWidth,.flexibleHeight]
               view.addSubview(openPdfUrl)
    }
    
//    MARK:- Button Action
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
//    MARK:- Webview Function
    
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
    
}
extension String {
    func replace(string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
}
