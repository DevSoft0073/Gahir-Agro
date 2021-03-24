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
    var pdfUrl = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        let url: URL! = URL(string: pdfUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        let urlRequest = URLRequest(url: url)
        openPdfUrl.load(urlRequest)
        openPdfUrl.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        view.addSubview(openPdfUrl)
        PKWrapperClass.svprogressHudShow(title: Constant.shared.appTitle, view: self)
        openPdfUrl.navigationDelegate = self
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        PKWrapperClass.svprogressHudDismiss(view: self)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        alert(Constant.shared.appTitle, message: error.localizedDescription, view: self)
        PKWrapperClass.svprogressHudDismiss(view: self)
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error){
        alert(Constant.shared.appTitle, message: error.localizedDescription, view: self)
        PKWrapperClass.svprogressHudDismiss(view: self)
    }
    
}
