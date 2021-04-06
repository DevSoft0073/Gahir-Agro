//
//  AdminPrivacyPolicyLinkVC.swift
//  Gahir Agro
//
//  Created by Apple on 01/04/21.
//

import UIKit
import WebKit
import LGSideMenuController


class AdminPrivacyPolicyLinkVC: UIViewController {
    
    @IBOutlet weak var openUrl: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: Constant.shared.baseUrl + Constant.shared.PrivacyPolicy)!
        let urlRequest = URLRequest(url: url)
        openUrl.load(urlRequest)
        openUrl.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        view.addSubview(openUrl)
        
        // Do any additional setup after loading the view.
    }
    @IBAction func openMenu(_ sender: Any) {
        sideMenuController?.showLeftViewAnimated()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated  {
            if let url = navigationAction.request.url,
               let host = url.host, !host.hasPrefix("www.google.com"),
               UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                print(url)
                print("Redirected to browser. No need to open it locally")
                decisionHandler(.cancel)
            } else {
                print("Open it locally")
                decisionHandler(.allow)
            }
        } else {
            print("not a user click")
            decisionHandler(.allow)
        }
    }
}
