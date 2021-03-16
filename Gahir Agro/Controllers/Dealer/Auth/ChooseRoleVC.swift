//
//  ChooseRoleVC.swift
//  Gahir Agro
//
//  Created by Apple on 12/03/21.
//

import UIKit

class ChooseRoleVC: UIViewController {

    var selectRoleArray = [SelectRole]()
    var matchIndex = 0
    var selectedRole = String()
    @IBOutlet weak var selectRoleCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectRoleArray.append(SelectRole(name: "Dealer", image: "icon0", selected: false, id: "0"))
        self.selectRoleArray.append(SelectRole(name: "Customer", image: "icon1", selected: false, id: "1"))
        self.selectRoleArray.append(SelectRole(name: "Sales Executive", image: "icon2", selected: false, id: "2"))
        self.selectRoleArray.append(SelectRole(name: "Admin", image: "icon3", selected: false, id: "3"))
        // Do any additional setup after loading the view.
    }
    
    func setRole(val: SelectRole){
        switch val.id {
        case "0":
            UserDefaults.standard.set(Role.dealer.rawValue, forKey: "role")
        case "1":
            UserDefaults.standard.set(Role.customer.rawValue, forKey: "role")
        case "2":
            UserDefaults.standard.set(Role.salesExecutive.rawValue, forKey: "role")
        case "3":
            UserDefaults.standard.set(Role.admin.rawValue, forKey: "role")
        default:
            print("none")
        }
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        let filterArray = self.selectRoleArray.filter({$0.selected == true})
        if filterArray.count > 0 {
            self.selectedRole = filterArray[0].id
            setRole(val: filterArray.first!)
            if selectedRole == "0"{
                let vc = SignInWithVC.instantiate(fromAppStoryboard: .Auth)
                self.navigationController?.pushViewController(vc, animated: true)
            }else if selectedRole == "1"{
                let vc = SignInWithScreenVC.instantiate(fromAppStoryboard: .AuthForCustomer)
                self.navigationController?.pushViewController(vc, animated: true)
            }
         
        }else{
            alert(Constant.shared.appTitle, message: "Please select role for user", view: self)
        }
    }
}

class SelectRoleCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var iconImage: UIImageView!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension ChooseRoleVC : UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectRoleArray.count
    }
    
    
    func applyShadowOnView(_ view: UIView) {
        view.layer.cornerRadius = 12
        view.layer.shadowColor = #colorLiteral(red: 0.9044200033, green: 0.9075989889, blue: 0.9171359454, alpha: 1)
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectRoleCollectionViewCell", for: indexPath) as! SelectRoleCollectionViewCell
        cell.iconImage.image = UIImage(named: selectRoleArray[indexPath.item].image)
        cell.nameLbl.text = selectRoleArray[indexPath.item].name
        let data = selectRoleArray[indexPath.item]
        if data.selected == true {
            cell.dataView.borderColor = #colorLiteral(red: 0.8132336612, green: 0.1636629304, blue: 0.1179455811, alpha: 1)
        }else{
            cell.dataView.borderColor = #colorLiteral(red: 0.9044200033, green: 0.9075989889, blue: 0.9171359454, alpha: 1)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.selectRoleArray[indexPath.row].selected{
            self.selectRoleArray[indexPath.row].selected = !self.selectRoleArray[indexPath.row].selected
            self.selectRoleArray = self.selectRoleArray.map({ (data) -> SelectRole in
                var mutableData = data
//                matchIndex = indexPath.row
                mutableData.selected = false
                return mutableData
            })
        }else{
            self.selectRoleArray = self.selectRoleArray.map({ (data) -> SelectRole in
                var mutableData = data
                mutableData.selected = false
                matchIndex = indexPath.row
                return mutableData
            })
            self.selectRoleArray[indexPath.row].selected = !self.selectRoleArray[indexPath.row].selected
        }
        collectionView.reloadData()
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let noOfCellsInRow = 2

        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

        return CGSize(width: size, height: size)
    }
   
}

struct SelectRole {
    var name : String
    var image : String
    var selected : Bool
    var id : String
    
    init(name : String,image : String,selected : Bool,id : String) {
        self.name = name
        self.image = image
        self.selected = selected
        self.id = id
    }
}

enum Role:String{
    case dealer
    case customer
    case admin
    case salesExecutive
}


