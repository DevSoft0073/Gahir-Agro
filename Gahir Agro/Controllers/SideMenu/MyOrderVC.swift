//
//  MyOrderVC.swift
//  Gahir Agro
//
//  Created by Apple on 24/02/21.
//

import UIKit
import LGSideMenuController

class MyOrderVC: UIViewController {

    @IBOutlet weak var myOrderTBView: UITableView!
    var orderHistoryArray = [OrderHistoryData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        myOrderTBView.separatorStyle = .none
        // Do any additional setup after loading the view.
        orderHistoryArray.append(OrderHistoryData(name: "Product-1", id: "ID - 1233445", quantity: "3", deliveryDate: "24 Feb 2021", price: "$440.00", image: "im"))
        orderHistoryArray.append(OrderHistoryData(name: "Product-1", id: "ID - 1233445", quantity: "3", deliveryDate: "24 Feb 2021", price: "$440.00", image: "im"))
        orderHistoryArray.append(OrderHistoryData(name: "Product-1", id: "ID - 1233445", quantity: "3", deliveryDate: "24 Feb 2021", price: "$440.00", image: "im"))
        orderHistoryArray.append(OrderHistoryData(name: "Product-1", id: "ID - 1233445", quantity: "3", deliveryDate: "24 Feb 2021", price: "$440.00", image: "im"))
        orderHistoryArray.append(OrderHistoryData(name: "Product-1", id: "ID - 1233445", quantity: "3", deliveryDate: "24 Feb 2021", price: "$440.00", image: "im"))
        
    }

    @IBAction func openMenu(_ sender: Any) {
        sideMenuController?.showLeftViewAnimated()

    }
}

class MyOrderTBViewCell: UITableViewCell {
    
    
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var reorderbutton: UIButton!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var showImage: UIImageView!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension MyOrderVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderHistoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrderTBViewCell", for: indexPath) as! MyOrderTBViewCell
        cell.priceLbl.text = orderHistoryArray[indexPath.section].price
        cell.timeLbl.text = orderHistoryArray[indexPath.section].deliveryDate
        cell.quantityLbl.text = orderHistoryArray[indexPath.section].quantity
//        cell.priceLbl.text = orderHistoryArray[indexPath.section].price
        cell.showImage.image = UIImage(named: orderHistoryArray[indexPath.section].image)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
}

struct OrderHistoryData {
    var name : String
    var id : String
    var quantity : String
    var deliveryDate : String
    var price : String
    var image : String
    
    init(name : String , id : String , quantity : String , deliveryDate : String , price : String , image : String) {
        self.name = name
        self.id = id
        self.quantity = quantity
        self.deliveryDate = deliveryDate
        self.price = price
        self.image = image
    }
}
