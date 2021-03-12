//
//  ThankYouVC.swift
//  Gahir Agro
//
//  Created by Apple on 09/03/21.
//

import UIKit

class ThankYouVC: UIViewController {
    

    @IBOutlet weak var thankYouView: UIView!
    @IBOutlet weak var popUpView: UIView!
    var enquiryRedirection:(()->Void)?
    var centerFrame : CGRect!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.isOpaque = true
        let mytapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.view.addGestureRecognizer(mytapGestureRecognizer)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func handleTap(_ sender:UITapGestureRecognizer){
        self.dismiss(animated: true) {
            self.enquiryRedirection?()
        }
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        centerFrame = self.thankYouView.frame
    }

    func presentPopUp()  {
        
        thankYouView.frame = CGRect(x: centerFrame.origin.x, y: view.frame.size.height, width: centerFrame.width, height: centerFrame.height)
        thankYouView.isHidden = false
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.90, initialSpringVelocity: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.thankYouView.frame = self.centerFrame
        }, completion: nil)
    }
    
    func dismissPopUp(_ dismissed:@escaping ()->())  {
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.90, initialSpringVelocity: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            
            self.thankYouView.frame = CGRect(x: self.centerFrame.origin.x, y: self.view.frame.size.height, width: self.centerFrame.width, height: self.centerFrame.height)
            
        },completion:{ (completion) in
            self.dismiss(animated: false, completion: {
            })
        })
    }
    
    
}
