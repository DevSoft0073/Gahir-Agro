//
//  InVoiceVC.swift
//  Gahir Agro
//
//  Created by Apple on 30/04/21.
//

import UIKit
import Foundation

class InVoiceVC : UIViewController {
    
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //------------------------------------------------------
    
    deinit { //same like dealloc in ObjectiveC
        
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
    
    //MARK: Actions
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
}
