//
//  SelectCategoryVC.swift
//  Gahir Agro
//
//  Created by Apple on 30/04/21.
//

import UIKit
import Foundation
import LGSideMenuController
import SDWebImage

class SelectCategoryVC : UIViewController {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var categotyCollectionVIew: UICollectionView!
    @IBOutlet weak var allCatCollectionView: UICollectionView!
    var currentPage = 0
    var messgae = String()
    var page = 1
    var catArray = [CatData]()
    var lastPage = String()
    var catImages = ["img2","card2","img3","img4","img6","img7"]
    
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
    
    func catData() {
        let url = Constant.shared.baseUrl + Constant.shared.Category
        var deviceID = UserDefaults.standard.value(forKey: "deviceToken") as? String
        let accessToken = UserDefaults.standard.value(forKey: "accessToken")
        print(deviceID ?? "")
        if deviceID == nil  {
            deviceID = "777"
        }
        let params = ["access_token": accessToken]  as? [String : AnyObject] ?? [:]
        print(params)
        PKWrapperClass.svprogressHudShow(title: Constant.shared.appTitle, view: self)
        PKWrapperClass.requestPOSTWithFormData(url, params: params, imageData: []) { (response) in
            print(response.data)
            PKWrapperClass.svprogressHudDismiss(view: self)
            let status = response.data["status"] as? String ?? ""
            self.messgae = response.data["message"] as? String ?? ""
            if status == "1"{
                var newArr = [CatData]()
                let allData = response.data["category_list"] as? [String:Any] ?? [:]
                self.lastPage = allData["last_page"] as? String ?? ""
                for obj in allData["all_categories"] as? [[String:Any]] ?? [[:]] {
                    print(obj)
                    
                    newArr.append(CatData(name: obj["cat_name"] as? String ?? "", image: obj["cat_image"] as? String ?? "", type: obj["cat_type"] as? String ?? "", id: obj["id"] as? String ?? "", feature_product: obj["feature_product"] as? String ?? ""))
                }
                for i in 0..<newArr.count{
                    self.catArray.append(newArr[i])
                }
                self.categotyCollectionVIew.reloadData()
                self.allCatCollectionView.reloadData()
            }else if status == "0"{
                PKWrapperClass.svprogressHudDismiss(view: self)
            }else{
                UserDefaults.standard.removeObject(forKey: "tokenFString")
                let appDel = UIApplication.shared.delegate as! AppDelegate
                appDel.Logout1()
            }
        } failure: { (error) in
            print(error)
            PKWrapperClass.svprogressHudDismiss(view: self)
        }
    }
    
    func getRandomColor() -> UIColor {
        //Generate between 0 to 1
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        
        return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
    }
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.catData()
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //------------------------------------------------------
    
    //MARK: Actions
    
    @IBAction func openMenu(_ sender: Any) {
        sideMenuController?.showLeftViewAnimated()
    }
    
    @IBAction func searchBtn(_ sender: Any) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromTop
        self.navigationController!.view.layer.add(transition, forKey: nil)
        let writeView = self.storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        self.navigationController?.pushViewController(writeView, animated: false)
    }
}

class featuredProductCell: UICollectionViewCell {
    
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var colorView: UIView!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

class categoryCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var colorView: UIView!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension SelectCategoryVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categotyCollectionVIew {
            self.pageControl.numberOfPages = catArray.count
            return catArray.count
            
        }else{
            return catArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categotyCollectionVIew{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "featuredProductCell", for: indexPath) as! featuredProductCell
            // cell.nameLbl.text = catArray[indexPath.item].name
            cell.showImage.sd_setImage(with: URL(string: catArray[indexPath.item].image), placeholderImage: UIImage(named: ""), options: SDWebImageOptions.continueInBackground, completed: nil)
            cell.colorView.backgroundColor = getRandomColor()
            self.pageControl.numberOfPages = catArray.count
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! categoryCell
            cell.colorView.backgroundColor = getRandomColor()
            cell.nameLbl.text = catArray[indexPath.item].name
            cell.showImage.image = UIImage(named: catImages[indexPath.item])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == categotyCollectionVIew{
            return 0.0
        }else{
            return 10.0
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == categotyCollectionVIew{
            return 0.0
        }else{
            return 10.0
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let pageWidth = scrollView.frame.width
        self.currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
        self.pageControl.currentPage = self.currentPage
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categotyCollectionVIew{
            
        }else{
            let vc = HomeVC.instantiate(fromAppStoryboard: .Main)
            vc.id = catArray[indexPath.item].id
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categotyCollectionVIew{
            return CGSize(width: collectionView.frame.width*4/4, height: collectionView.frame.height)
        }else{
            
            let noOfCellsInRow = 2
            
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            
            let totalSpace = flowLayout.sectionInset.left
                + flowLayout.sectionInset.right
                + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
            
            let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
            
            return CGSize(width: size, height: size)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView == categotyCollectionVIew{
            let cellWidth : CGFloat = collectionView.frame.width*4/4
            
            let numberOfCells = floor(collectionView.frame.width / cellWidth)
            let edgeInsets = (collectionView.frame.width - (numberOfCells * cellWidth)) / (numberOfCells + 1)
            
            return UIEdgeInsets(top: 0, left: edgeInsets, bottom: 0, right: edgeInsets)
        }else{
            let cellWidth : CGFloat = collectionView.frame.width*4/9 + 5
            
            let numberOfCells = floor(collectionView.frame.width / cellWidth)
            let edgeInsets = (collectionView.frame.width - (numberOfCells * cellWidth)) / (numberOfCells + 1)
            
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
}

struct CatData {
    
    var name : String
    var image : String
    var type : String
    var id : String
    var feature_product : String
    
    init(name: String, image: String, type: String, id: String, feature_product: String) {
        self.name = name
        self.image = image
        self.type = type
        self.id = id
        self.feature_product = feature_product
    }
}

