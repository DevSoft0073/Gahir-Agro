//
//  ShowImageVC.swift
//  Gahir Agro
//
//  Created by Apple on 18/05/21.
//
import UIKit
import Foundation
import SDWebImage

class ShowImageVC : UIViewController , UIScrollViewDelegate{
    
    @IBOutlet weak var imageView: ZoomImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var showImage: UIImageView!
    var imgString = String()
    
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
        return showImage
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
        
        showImage.sd_setShowActivityIndicatorView(true)
        if #available(iOS 13.0, *) {
            showImage.sd_setIndicatorStyle(.large)
        } else {
            // Fallback on earlier versions
        }
        showImage.sd_setImage(with: URL(string: imgString), placeholderImage: UIImage(named: "placeholder-img-logo (1)"), options: SDWebImageOptions.continueInBackground, completed: nil)

        scrollView.delegate = self
//        let url = URL(string: imgString)
//        if let data = try? Data(contentsOf: url!)
//        {
//            let image: UIImage = UIImage(data: data)!
//            self.showImage.image = image
//            self.imageView.zoomMode = .fit
//        }
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //------------------------------------------------------
}
