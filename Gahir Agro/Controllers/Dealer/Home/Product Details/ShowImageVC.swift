//
//  ShowImageVC.swift
//  Gahir Agro
//
//  Created by Apple on 18/05/21.
//
import UIKit
import Foundation
import SDWebImage
import ISVImageScrollView


class ShowImageVC : UIViewController , UIScrollViewDelegate{
    
    var imgString = String()
    
    @IBOutlet weak var imageView: ISVImageScrollView!
    var imageViews: UIImageView?
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
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
      return self.imageView
    }
    
    //------------------------------------------------------
    
    //MARK: Action
    
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.imageView = self.imageViews
        self.imageView.maximumZoomScale = 4.0
        self.imageView.delegate = self
        
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //------------------------------------------------------
}
