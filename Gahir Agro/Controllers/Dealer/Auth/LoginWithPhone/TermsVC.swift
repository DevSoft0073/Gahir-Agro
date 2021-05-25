//
//  TermsVC.swift
//  Gahir Agro
//
//  Created by Apple on 24/05/21.
//
import UIKit
import Foundation
import WebKit

class TermsVC : UIViewController ,WKNavigationDelegate{
    
    @IBOutlet weak var openUrl: WKWebView!
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //------------------------------------------------------
    
    deinit { //same like dealloc in ObjectiveC
        
    }
    
    //------------------------------------------------------
    
    //MARK: Custome
    
    
    func setup() {
        let url = URL(string: "http://www.gahirindia.com/home.phps")!
        let urlRequest = URLRequest(url: url)
        openUrl.load(urlRequest)
        openUrl.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        view.addSubview(openUrl)
        IJProgressView.shared.showProgressView()
        openUrl.navigationDelegate = self
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
    
    //------------------------------------------------------
    
    //MARK: Actions
    
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //------------------------------------------------------
}
