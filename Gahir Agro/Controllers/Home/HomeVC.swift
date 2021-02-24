//
//  HomeVC.swift
//  Gahir Agro
//
//  Created by Apple on 23/02/21.
//

import UIKit
import LGSideMenuController

class HomeVC: UIViewController {

    var collectionViewDataArray = [CollectionViewData]()
    var tableViewDataArray = [TableViewData]()
    @IBOutlet weak var allItemsTBView: UITableView!
    @IBOutlet weak var itemsCollectionView: UICollectionView!
    var nameArray = ["TRACKTORS","TRACKTORS","TRACKTORS","TRACKTORS","TRACKTORS","TRACKTORS","TRACKTORS"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewDataArray.append(TableViewData(image: "im", name: "Product-1", modelName: "HP-28", details: "Drive"))
        tableViewDataArray.append(TableViewData(image: "im", name: "Product-2", modelName: "HP-28", details: "Drive"))
        tableViewDataArray.append(TableViewData(image: "im", name: "Product-3", modelName: "HP-28", details: "Drive"))
        tableViewDataArray.append(TableViewData(image: "im", name: "Product-4", modelName: "HP-28", details: "Drive"))
        tableViewDataArray.append(TableViewData(image: "im1", name: "Product-5", modelName: "HP-28", details: "Drive"))
        tableViewDataArray.append(TableViewData(image: "im", name: "Product-6", modelName: "HP-28", details: "Drive"))
        
        collectionViewDataArray.append((CollectionViewData(name: "TRACKTORS", selected: false)))
        collectionViewDataArray.append((CollectionViewData(name: "TRACKTORS", selected: false)))
        collectionViewDataArray.append((CollectionViewData(name: "TRACKTORS", selected: false)))
        collectionViewDataArray.append((CollectionViewData(name: "TRACKTORS", selected: false)))
        collectionViewDataArray.append((CollectionViewData(name: "TRACKTORS", selected: false)))
        collectionViewDataArray.append((CollectionViewData(name: "TRACKTORS", selected: false)))
        collectionViewDataArray.append((CollectionViewData(name: "TRACKTORS", selected: false)))

        allItemsTBView.reloadData()
//        itemsCollectionView.reloadData()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func openMenuButton(_ sender: Any) {
        sideMenuController?.showLeftViewAnimated()
    }
    
    @IBAction func searchButton(_ sender: Any) {
    }
    

}

class ItemsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

class AlItemsTBViewCell: UITableViewCell {
    
    @IBOutlet weak var checkAvailabiltyButton: UIButton!
    @IBOutlet weak var detailsLbl: UILabel!
    @IBOutlet weak var modelLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var dataView: UIView!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}


extension HomeVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewDataArray[section].image.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlItemsTBViewCell", for: indexPath) as! AlItemsTBViewCell
        cell.showImage.image = UIImage(named: tableViewDataArray[indexPath.row].image)
        cell.nameLbl.text = tableViewDataArray[indexPath.row].name
        cell.modelLbl.text = tableViewDataArray[indexPath.row].modelName
        cell.detailsLbl.text = tableViewDataArray[indexPath.row].details
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ProductDetailsVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
}

extension HomeVC : UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewDataArray[section].name.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemsCollectionViewCell", for: indexPath) as! ItemsCollectionViewCell
//        cell.dataView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        cell.nameLbl.text = nameArray[indexPath.item]
        return cell
    }
}

struct CollectionViewData {
    var name : String
    var selected : Bool
    
    init(name : String , selected : Bool) {
        self.name = name
        self.selected = selected
    }
}


struct TableViewData {
    var image : String
    var name : String
    var modelName : String
    var details : String
    
    init(image : String,name : String,modelName : String,details : String) {
        self.image = image
        self.name = name
        self.modelName = modelName
        self.details = details
    }
}
