//
//  EnquiryVC.swift
//  Gahir Agro
//
//  Created by Apple on 25/02/21.
//

import UIKit

class EnquiryVC: UIViewController, UINavigationControllerDelegate, UIPickerViewDelegate,UIPickerViewDataSource, UITextFieldDelegate {
    
    var jassIndex = Int()
    
    var tbaleViewArray = ["SYSTEM","ACCESSORY"]
    var picker  = UIPickerView()

    var pickerToolBar = UIToolbar()
    var selectedValue = String()
    var selectedValue1 = String()
    var selectedname = String()
    var selectType = String()
    var currentIndex = Int()
    var count = 0
    var id = String()
    var productId = String()
    var indexesNeedPicker: [NSIndexPath]?
    var messgae = String()
    var categoryArray = [EnquieyData]()
    var accessory = [AccessoriesData]()
    var systemArray = [SystemData]()
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var enquiryDataTBView: UITableView!
    @IBOutlet weak var quantitylbl: UILabel!
    @IBOutlet weak var detailsLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var showImage: UIImageView!
    override func viewDidLoad() {
        productDetails()
        picker = UIPickerView.init()
        picker.delegate = self
        pickerToolBar.sizeToFit()
        let doneBtn = UIBarButtonItem(title: "Done", style:.plain, target: self, action: #selector(onDoneButtonTapped))
        doneBtn.tintColor = #colorLiteral(red: 0.08110561222, green: 0.2923257351, blue: 0.6798375845, alpha: 1)
//        doneBtn.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 20)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        pickerToolBar.setItems([spaceButton,doneBtn], animated: false)
        pickerToolBar.isUserInteractionEnabled = true
        self.enquiryDataTBView.reloadData()
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.heightConstraint.constant = self.enquiryDataTBView.contentSize.height

    }
    
    @objc func onDoneButtonTapped(sender:UIButton) {
        self.view.endEditing(true)
    }
    
     //MARK:- Service call methods
    
    func submitEnquiry() {
        PKWrapperClass.svprogressHudShow(title: Constant.shared.appTitle, view: self)
        let url = Constant.shared.baseUrl + Constant.shared.AddEnquiry
        var deviceID = UserDefaults.standard.value(forKey: "deviceToken") as? String
        let accessToken = UserDefaults.standard.value(forKey: "accessToken")
        print(deviceID ?? "")
        if deviceID == nil  {
            deviceID = "777"
        }
        
        let params = ["product_id" : id , "quantity" : "2", "accessory" : selectedValue1 ,"access_token": accessToken,"system" : selectedValue1 , "type" : self.productId]  as? [String : AnyObject] ?? [:]
        print(params)
        PKWrapperClass.requestPOSTWithFormData(url, params: params, imageData: [[:]]) { (response) in
            print(response.data)
            PKWrapperClass.svprogressHudDismiss(view: self)
            let status = response.data["status"] as? String ?? ""
            self.messgae = response.data["message"] as? String ?? ""
            if status == "1"{
                showAlertMessage(title: Constant.shared.appTitle, message: self.messgae, okButton: "Ok", controller: self) {
                    self.navigationController?.popViewController(animated: true)
                }
            }else{
                PKWrapperClass.svprogressHudDismiss(view: self)
                alert(Constant.shared.appTitle, message: self.messgae, view: self)
            }
        } failure: { (error) in
            print(error)
            showAlertMessage(title: Constant.shared.appTitle, message: error as? String ?? "", okButton: "Ok", controller: self, okHandler: nil)
        }
    }
    
    func productDetails() {
        PKWrapperClass.svprogressHudShow(title: Constant.shared.appTitle, view: self)
        let url = Constant.shared.baseUrl + Constant.shared.ProductDetails
        var deviceID = UserDefaults.standard.value(forKey: "deviceToken") as? String
        let accessToken = UserDefaults.standard.value(forKey: "accessToken")
        print(deviceID ?? "")
        if deviceID == nil  {
            deviceID = "777"
        }
        let params = ["id": id,"access_token": accessToken]  as? [String : AnyObject] ?? [:]
        print(params)
        PKWrapperClass.requestPOSTWithFormData(url, params: params, imageData: [[:]]) { (response) in
            print(response.data)
            PKWrapperClass.svprogressHudDismiss(view: self)
            let status = response.data["status"] as? String ?? ""
            self.messgae = response.data["message"] as? String ?? ""
            if status == "1"{
                let allData = response.data["product_detail"] as? [String:Any] ?? [:]
                print(allData)
                self.productId = allData["id"] as? String ?? ""
                let accessories = allData["accessories"] as? [[String:Any]] ?? [[:]]
                for obj in accessories {
                    print(obj)
                    self.accessory.append(AccessoriesData(name: obj["acc_name"] as? String ?? "", id: obj["id"] as? String ?? ""))
                }
                let systemData = allData["systems"] as? [[String:Any]] ?? [[:]]
                for obj in systemData{
                    self.systemArray.append(SystemData(name: obj["trac_name"] as? String ?? "", id: obj["id"] as? String ?? ""))
                }
                self.categoryArray.append(EnquieyData(accessory: self.accessory, system: self.systemArray))
//                self.picker.reloadAllComponents()
            }else{
                PKWrapperClass.svprogressHudDismiss(view: self)
                alert(Constant.shared.appTitle, message: self.messgae, view: self)
            }
        } failure: { (error) in
            print(error)
            showAlertMessage(title: Constant.shared.appTitle, message: error as? String ?? "", okButton: "Ok", controller: self, okHandler: nil)
        }
    }
    
    //    MARK:->    Picker View Methods
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        let numberOfRows = 0
        print(currentIndex)
        if currentIndex == 0{
            return systemArray.count
        }else if currentIndex == 1{
            return accessory.count
        }else{
            return numberOfRows
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        if currentIndex == 0{
            
            selectedValue = systemArray[row].id
            selectedname = systemArray[row].name
            self.enquiryDataTBView.reloadData()
            print(selectedValue)
            
        }else if currentIndex == 1{
            
            selectedValue1 = accessory[row].id
            selectType = accessory[row].name
            print(selectedValue1)
            self.enquiryDataTBView.reloadData()

        }else{
                        
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = (view as? UILabel) ?? UILabel()
        
        if currentIndex == 0{
            label.textColor = .black
            label.textAlignment = .center
            label.font = UIFont(name: "Poppins-Medium", size: 20)
            label.text = systemArray[row].name
            return label
        }else if currentIndex == 1{
            
            label.textColor = .black
            label.textAlignment = .center
            label.font = UIFont(name: "Poppins-Medium", size: 20)
            label.text = accessory[row].name
            return label
            
        }else{
            return label
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if currentIndex == 0{
            return systemArray[row].name
        }else if currentIndex == 1{
            return accessory[row].name
        }
        return accessory[row].name
    }
    
    @IBAction func backbutton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func submitButton(_ sender: Any) {
        submitEnquiry()
    }
    
    
    @IBAction func addLbl(_ sender: Any) {
        
    }
    
    @IBAction func minusButton(_ sender: Any) {
    }
}

class EnquiryDataTBViewCell: UITableViewCell,UITextFieldDelegate {
    
    var DotBTN:(()->Void)?
    @IBOutlet weak var openPicker: UITextField!
    @IBOutlet weak var dropDownbutton: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var namelbl: UILabel!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    @IBAction func openPicker(_ sender: Any) {
//        DotBTN!()
    }
}

extension EnquiryVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tbaleViewArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EnquiryDataTBViewCell", for: indexPath) as! EnquiryDataTBViewCell
        cell.namelbl.text = tbaleViewArray[indexPath.row]
        cell.titleLbl.text = selectedValue
        let index = indexPath.row
        if index == 0{
            cell.titleLbl.text = selectedValue
        }else if index == 1{
            cell.titleLbl.text = selectedValue1
        }
        cell.dropDownbutton.tag = indexPath.row
        cell.openPicker.tag = indexPath.row
        cell.openPicker.delegate = self
        cell.dropDownbutton.addTarget(self, action: #selector(openPickerView(sender:)), for: .touchUpInside)
        DispatchQueue.main.async {
            self.heightConstraint.constant = CGFloat(self.enquiryDataTBView.contentSize.height)
        }
        return cell
    }
    
    @objc func openPickerView(sender: UIButton) {
        if let cell = sender.superview?.superview as? EnquiryDataTBViewCell, let indexPath = enquiryDataTBView.indexPath(for: cell){
            currentIndex = sender.tag
            cell.openPicker.inputView = picker
            cell.openPicker.becomeFirstResponder()
            print("asdssad\(cell.openPicker.tag)")
            if indexPath.row == 0{
                cell.titleLbl.text = selectedname
            }else if indexPath.row == 1{
                cell.titleLbl.text = selectType
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}


struct EnquieyData {
    var accessory : [AccessoriesData]
    var system : [SystemData]
    
    init(accessory : [AccessoriesData],system : [SystemData]) {
        self.accessory = accessory
        self.system = system
    }
}

struct AccessoriesData {
    var name : String
    var id : String
    
    init(name : String,id : String) {
        self.name = name
        self.id = id
    }
}
struct SystemData {
    var name : String
    var id : String
    
    init(name : String,id : String) {
        self.name = name
        self.id = id
    }
}
