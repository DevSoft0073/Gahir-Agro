//
//  AdminHomeVC.swift
//  Gahir Agro
//
//  Created by Apple on 17/03/21.
//

import UIKit
import LGSideMenuController
import CoreLocation
import MapKit

class AdminHomeVC: UIViewController {
    
    var page = 1
    var lastPage = Bool()
    var messgae = String()
    var enquiryID = [String]()
    var quantityArray = [String]()
    var accName = [String]()
    var dealerCode = [String]()
    var dealerName = [String]()
    var dispatchDateArray = [String]()
    var adminEnquriesArray = [OrderDataForAdmin]()
    var enqArray = [String]()
    var addressArray = [String]()
    let geocoder = CLGeocoder()
    
    
    @IBOutlet weak var enquriesTBView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllEnquries()
        // Do any additional setup after loading the view.
    }
    @IBAction func backButtonAction(_ sender: Any) {
        sideMenuController?.showLeftViewAnimated()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        adminEnquriesArray.removeAll()
        addressArray.removeAll()
        page = 1
        getAllEnquries()
    }
    
    func getAllEnquries() {
        PKWrapperClass.svprogressHudShow(title: Constant.shared.appTitle, view: self)
        let url = Constant.shared.baseUrl + Constant.shared.AllDealerEnquries
        var deviceID = UserDefaults.standard.value(forKey: "deviceToken") as? String
        let accessToken = UserDefaults.standard.value(forKey: "accessToken")
        print(deviceID ?? "")
        if deviceID == nil  {
            deviceID = "777"
        }
        let params = ["page_no": page,"access_token": accessToken]  as? [String : AnyObject] ?? [:]
        print(params)
        PKWrapperClass.requestPOSTWithFormData(url, params: params, imageData: []) {[self](response) in
            print(response.data)
            PKWrapperClass.svprogressHudDismiss(view: self)
            let status = response.data["status"] as? String ?? ""
            self.messgae = response.data["message"] as? String ?? ""
            self.lastPage = response.data[""] as? Bool ?? false
            if status == "1"{
                var newArr = [OrderDataForAdmin]()
                let allData = response.data["enquiry_list"] as? [String:Any] ?? [:]
                for obj in allData["all_enquiries"] as? [[String:Any]] ?? [[:]]{
                    print(obj)
                    let accessoriesData = obj["accessories"] as? [String:Any] ?? [:]
                    self.dealerCode.append(obj["enquiry_id"] as? String ?? "")
                    let dateValue = obj["creation_date"] as? String ?? ""
                    self.enqArray.append(obj["enquiry_id"] as? String ?? "")
                    let dateVal = NumberFormatter().number(from: dateValue)?.doubleValue ?? 0.0
                    self.accName.append(accessoriesData["acc_name"] as? String ?? "")
                    let dealerData = obj["dealer_detail"] as? [String:Any] ?? [:]
                    addressArray.append(obj["dealer_loc"] as? String ?? "")
                    self.dispatchDateArray.append(obj["dispatch_day"] as? String ?? "")
                    self.dealerName.append("\(dealerData["first_name"] as? String ?? "") " + "\(dealerData["last_name"] as? String ?? "")")
                    self.quantityArray.append(obj["qty"] as? String ?? "")
                    self.enquiryID.append(obj["enquiry_id"] as? String ?? "")
                    let productDetails = obj["product_detail"] as? [String:Any] ?? [:]
                    print(productDetails)
                    newArr.append(OrderDataForAdmin(name: productDetails["prod_name"] as? String ?? "", id: productDetails["id"] as? String ?? "", quantity: "\(productDetails["qty"] as? String ?? "")", deliveryDate: self.convertTimeStampToDate(dateVal: dateVal), price: "$\(productDetails["prod_price"] as? String ?? "")", image: productDetails["prod_image"] as? String ?? "", accName: self.accName, modelName: productDetails["prod_name"] as? String ?? "", enqID: self.enquiryID, address: productDetails["address"] as? String ?? ""))
                }
                for i in 0..<newArr.count{
                    self.adminEnquriesArray.append(newArr[i])
                }
                self.enquriesTBView.reloadData()
            }else if status == "0"{
                PKWrapperClass.svprogressHudDismiss(view: self)
                alert(Constant.shared.appTitle, message: self.messgae, view: self)
            } else if status == "100"{
                showAlertMessage(title: Constant.shared.appTitle, message: self.messgae, okButton: "Ok", controller: self) {
                    UserDefaults.standard.removeObject(forKey: "tokenFString")
                    let appDel = UIApplication.shared.delegate as! AppDelegate
                    appDel.Logout1()
                }
            }
        } failure: { (error) in
            print(error)
            PKWrapperClass.svprogressHudDismiss(view: self)
            showAlertMessage(title: Constant.shared.appTitle, message: error as? String ?? "", okButton: "Ok", controller: self, okHandler: nil)
        }
    }
}

class AdminEnquriesTBViewCell: UITableViewCell {
    
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var idLbl: UILabel!
    @IBOutlet weak var timelbl: UILabel!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var pricveLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var showImage: UIImageView!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension AdminHomeVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adminEnquriesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdminEnquriesTBViewCell", for: indexPath) as! AdminEnquriesTBViewCell
        cell.idLbl.text = dispatchDateArray[indexPath.row]
        cell.quantityLbl.text = adminEnquriesArray[indexPath.row].enqID[indexPath.row]
        cell.pricveLbl.text = adminEnquriesArray[indexPath.row].price
        cell.timelbl.text = quantityArray[indexPath.row]
        cell.nameLbl.text = adminEnquriesArray[indexPath.row].name
        cell.showImage.sd_setImage(with: URL(string:adminEnquriesArray[indexPath.row].image), placeholderImage: UIImage(named: "im"))
        cell.addressLbl.text = addressArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = BookOrderVC.instantiate(fromAppStoryboard: .Main)
        UserDefaults.standard.set(true, forKey: "comesFromAdmin")
        vc.enquiryID = self.enqArray[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if lastPage == false{
            let bottamEdge = Float(self.enquriesTBView.contentOffset.y + self.enquriesTBView.frame.size.height)
            if bottamEdge >= Float(self.enquriesTBView.contentSize.height) && adminEnquriesArray.count > 0 {
                page = page + 1
                getAllEnquries()
            }
        }else{
            let bottamEdge = Float(self.enquriesTBView.contentOffset.y + self.enquriesTBView.frame.size.height)
            if bottamEdge >= Float(self.enquriesTBView.contentSize.height) && adminEnquriesArray.count > 0 {
            }
        }
    }
}


struct GetAddress {
    
    var city : String
    var address : String
    
    init(city : String , address : String) {
        self.city = city
        self.address = address
    }
}

struct OrderDataForAdmin {
    var name : String
    var id : String
    var quantity : String
    var deliveryDate : String
    var price : String
    var image : String
    var modelName : String
    var accName : [String]
    var enqID : [String]
    var address : String
    
    init(name : String , id : String , quantity : String , deliveryDate : String , price : String , image : String,accName : [String],modelName : String,enqID : [String],address : String) {
        self.name = name
        self.id = id
        self.quantity = quantity
        self.deliveryDate = deliveryDate
        self.price = price
        self.image = image
        self.accName = accName
        self.modelName = modelName
        self.enqID = enqID
        self.address = address
    }
}

//extension AdminHomeVC {
//    func getAddressFromLatLon(pdblLatitude: String,pdblLongitude: String)-> String {
//            var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
//        let lat: Double = Double("\(pdblLatitude)") ?? 0.0
//            //21.228124
//        let lon: Double = Double("\(pdblLongitude)") ?? 0.0
//            //72.833770
//            let ceo: CLGeocoder = CLGeocoder()
//            center.latitude = lat
//            center.longitude = lon
//
//            let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
//
//         var addressString : String = ""
//            ceo.reverseGeocodeLocation(loc, completionHandler:
//                {(placemarks, error) in
//                    if (error != nil)
//                    {
//                        print("reverse geodcode fail: \(error!.localizedDescription)")
//                    }
//                    let pm = (placemarks ?? nil) ?? [NSObject]()
//
//                    if pm.count > 0 {
//                        let pm = placemarks![0]
//                        print(pm.country)
//                        print(pm.locality)
//                        print(pm.subLocality)
//                        print(pm.thoroughfare)
//                        print(pm.postalCode)
//                        print(pm.subThoroughfare)
//
//                        if pm.subLocality != nil {
//                            addressString = addressString + pm.subLocality! + ", "
//                        }
//                        if pm.thoroughfare != nil {
//                            addressString = addressString + pm.thoroughfare! + ", "
//                        }
//                        if pm.locality != nil {
//                            addressString = addressString + pm.locality! + ", "
//                        }
//                        if pm.country != nil {
//                            addressString = addressString + pm.country! + ", "
//                        }
//                        if pm.postalCode != nil {
//                            addressString = addressString + pm.postalCode! + " "
//                        }
////                        self.addressArray = "\(addressString)"
////                        print(self.addressArray)
//                  }
//            })
//        return addressString
//         }
    
//    func convertLatLongToAddress(latitude:Double,longitude:Double){
//
//        let geoCoder = CLGeocoder()
//        let location = CLLocation(latitude: latitude, longitude: longitude)
//        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
//
//            // Place details
//            var placeMark: CLPlacemark!
//            placeMark = placemarks?[0]
//
//            // Location name
////            if let locationName = placemark.location {
////                print(locationName)
////            }
//            // Street address
//            if let street = placeMark.thoroughfare {
//                print(street)
//            }
//            // City
//            if let city = placeMark.locality {
//                print(city)
//            }
//            // State
////            if let state = placemark.administrativeArea {
////                print(state)
////            }
//            // Zip code
////            if let zipCode = placeMark.postalCode {
////                print(zipCode)
////            }
//            // Country
//            if let country = placeMark.country {
//                print(country)
//            }
//            let address = "\(placeMark.locality ?? "") " + "\(placeMark.country ?? "")"
//            print(address)
//            self.addressArray = address
//        })
//
//    }
//
//}

