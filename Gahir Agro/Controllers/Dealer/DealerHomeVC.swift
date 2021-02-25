//
//  DealerHomeVC.swift
//  Gahir Agro
//
//  Created by Apple on 25/02/21.
//

import UIKit

class DealerHomeVC: UIViewController {

    var collectionViewDataArray = [CollectionViewDataForDealer]()
    var tableViewDataArray = [TableViewDataForDealer]()
    var nameArray = ["TRACKTORS","TRACKTORS","TRACKTORS","TRACKTORS","TRACKTORS","TRACKTORS","TRACKTORS"]

    @IBOutlet weak var tableViewData: UITableView!
    @IBOutlet weak var collectionViewData: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableViewData.separatorStyle = .none
        tableViewDataArray.append(TableViewDataForDealer(image: "im", name: "Product-1", modelName: "HP-28", details: "Drive"))
        tableViewDataArray.append(TableViewDataForDealer(image: "im", name: "Product-2", modelName: "HP-28", details: "Drive"))
        tableViewDataArray.append(TableViewDataForDealer(image: "im", name: "Product-3", modelName: "HP-28", details: "Drive"))
        tableViewDataArray.append(TableViewDataForDealer(image: "im", name: "Product-4", modelName: "HP-28", details: "Drive"))
        tableViewDataArray.append(TableViewDataForDealer(image: "im1", name: "Product-5", modelName: "HP-28", details: "Drive"))
        tableViewDataArray.append(TableViewDataForDealer(image: "im", name: "Product-6", modelName: "HP-28", details: "Drive"))
        
        collectionViewDataArray.append((CollectionViewDataForDealer(name: "TRACKTORS", selected: false)))
        collectionViewDataArray.append((CollectionViewDataForDealer(name: "TRACKTORS", selected: false)))
        collectionViewDataArray.append((CollectionViewDataForDealer(name: "TRACKTORS", selected: false)))
        collectionViewDataArray.append((CollectionViewDataForDealer(name: "TRACKTORS", selected: false)))
        collectionViewDataArray.append((CollectionViewDataForDealer(name: "TRACKTORS", selected: false)))
        collectionViewDataArray.append((CollectionViewDataForDealer(name: "TRACKTORS", selected: false)))
        collectionViewDataArray.append((CollectionViewDataForDealer(name: "TRACKTORS", selected: false)))

        tableViewData.reloadData()
        collectionViewData.reloadData()
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func menuButton(_ sender: Any) {
    }
    
    @IBAction func searchButton(_ sender: Any) {
    }
}

class TableViewDataCell: UITableViewCell {
    
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var moreDetailsButton: UIButton!
    @IBOutlet weak var subDetailsLbl: UILabel!
    @IBOutlet weak var detailslbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

class CollectionViewDataCell: UICollectionViewCell {
    
    
    @IBOutlet weak var nameLbl: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}



struct CollectionViewDataForDealer {
    var name : String
    var selected : Bool
    
    init(name : String , selected : Bool) {
        self.name = name
        self.selected = selected
    }
}


struct TableViewDataForDealer {
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


extension DealerHomeVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewDataArray[section].image.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewDataCell", for: indexPath) as! TableViewDataCell
        cell.showImage.image = UIImage(named: tableViewDataArray[indexPath.row].image)
        cell.nameLbl.text = tableViewDataArray[indexPath.row].name
        cell.detailslbl.text = tableViewDataArray[indexPath.row].modelName
        cell.subDetailsLbl.text = tableViewDataArray[indexPath.row].details
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ProductDetailsVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 330
    }
    
}

extension DealerHomeVC : UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewDataCell", for: indexPath) as! CollectionViewDataCell
        cell.nameLbl.text = nameArray[indexPath.item]
        return cell
    }
}
