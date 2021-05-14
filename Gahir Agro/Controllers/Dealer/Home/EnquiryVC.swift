//
//  EnquiryVC.swift
//  Gahir Agro
//
//  Created by Apple on 25/02/21.
//

import UIKit
import SDWebImage

class EnquiryVC: UIViewController, UINavigationControllerDelegate, UIPickerViewDelegate,UIPickerViewDataSource, UITextFieldDelegate {
    
    var jassIndex = Int()
    var tbaleViewArray = ["TYPE","SYSTEM"]
    var picker  = UIPickerView()
    
    @IBOutlet weak var remarkTxtView: UITextView!
    var pickerToolBar = UIToolbar()
    var selectedValue = String()
    var selectedValue1 = String()
    var selectedname = String()
    var selectType = String()
    var currentIndex = Int()
    var count = 1
    var id = String()
    var isAvailabele = Bool()
    var productId = String()
    var indexesNeedPicker: [NSIndexPath]?
    var messgae = String()
    var categoryArray = [EnquieyData]()
    var accessory = [AccessoriesData]()
    var systemArray = [SystemData]()
    var productDetailsAaay = [ProductData]()
    var comesFirstTime = Bool()
    let timer = Timer()
    var orderID = Int()
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
        
        if count < 1 {
            showAlertMessage(title: Constant.shared.appTitle, message: "Quantity should not be set to 0", okButton: "Ok", controller: self) {
            }
        }else{
            
            if selectedValue.isEmpty == true {
                ValidateData(strMessage: "Please select value for type")
            }else if selectedValue1.isEmpty == true{
                ValidateData(strMessage: "Please select value for system")
                
            }else{
                
                PKWrapperClass.svprogressHudShow(title: Constant.shared.appTitle, view: self)
                let url = Constant.shared.baseUrl + Constant.shared.AddEnquiry
                var deviceID = UserDefaults.standard.value(forKey: "deviceToken") as? String
                let accessToken = UserDefaults.standard.value(forKey: "accessToken")
                print(deviceID ?? "")
                if deviceID == nil  {
                    deviceID = "777"
                }
                
                let params = ["product_id" : id , "quantity" : count, "accessory" : selectedValue1 ,"access_token": accessToken,"system" : selectedValue , "type" : self.productId, "remark": self.remarkTxtView.text ?? ""]  as? [String : AnyObject] ?? [:]
                print(params)
                PKWrapperClass.requestPOSTWithFormData(url, params: params, imageData: []) { (response) in
                    print(response.data)
                    PKWrapperClass.svprogressHudDismiss(view: self)
                    let status = response.data["status"] as? String ?? ""
                    self.messgae = response.data["message"] as? String ?? ""
                    self.orderID = response.data["enquiry_id"] as? Int ?? 0
                    if status == "1"{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ThankYouVC") as! ThankYouVC
                        vc.modalPresentationStyle = .overCurrentContext
                        vc.modalTransitionStyle = .crossDissolve
                        vc.enquiryRedirection = {
                            DispatchQueue.main.async {
                                if self.isAvailabele == true {
                                    
                                }else{
                                    
                                }
                                let vc = BookOrderVC.instantiate(fromAppStoryboard: .Main)
                                vc.enquiryID = "\(self.orderID)"
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                        
                        self.present(vc, animated: true, completion: nil)
                        
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
    }
    
    func popBack(_ nb: Int) {
        if let viewControllers: [UIViewController] = self.navigationController?.viewControllers {
            guard viewControllers.count < nb else {
                self.navigationController?.popToViewController(viewControllers[viewControllers.count - nb], animated: true)
                return
            }
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
        PKWrapperClass.requestPOSTWithFormDataWithoutImages(url, params: params) { (response) in
            print(response.data)
            PKWrapperClass.svprogressHudDismiss(view: self)
            let status = response.data["status"] as? String ?? ""
            self.messgae = response.data["message"] as? String ?? ""
            if status == "1"{
                let allData = response.data["product_detail"] as? [String:Any] ?? [:]
                print(allData)
                self.nameLbl.text = allData["prod_name"] as? String ?? ""
                self.detailsLbl.text = allData["prod_model"] as? String ?? ""
                self.showImage.sd_setImage(with: URL(string: allData["prod_image"] as? String ?? ""), placeholderImage: UIImage(named: "placeholder-img-logo (1)"), options: SDWebImageOptions.continueInBackground, completed: nil)
                self.productId = allData["prod_type"] as? String ?? ""
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
                self.enquiryDataTBView.reloadData()
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
    
    //    MARK:->    Picker View Methods
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        let numberOfRows = 0
        print(currentIndex)
        if currentIndex == 0{
            return accessory.count
        }else if currentIndex == 1{
            return systemArray.count
        }else{
            return numberOfRows
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        if currentIndex == 0{
            
            selectedValue =  accessory[row].id
            selectedname =  accessory[row].name
            self.enquiryDataTBView.reloadData()
            print(selectedValue)
            
        }else if currentIndex == 1{
            
            selectedValue1 = systemArray[row].id
            selectType = systemArray[row].name
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
            label.text = accessory[row].name
            return label
        }else if currentIndex == 1{
            
            label.textColor = .black
            label.textAlignment = .center
            label.font = UIFont(name: "Poppins-Medium", size: 20)
            label.text = systemArray[row].name
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
            return accessory[row].name
        }else if currentIndex == 1{
            return systemArray[row].name 
        }
        return accessory[row].name
    }
    
    //      MARK:- Button Actions
    
    @IBAction func backbutton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func submitButton(_ sender: Any) {
        submitEnquiry()
    }
    
    
    @IBAction func addLbl(_ sender: Any) {
        count = count + 1
        quantitylbl.text = "\(count)"
    }
    
    @IBAction func minusButton(_ sender: Any) {
        if count < 1{
            showAlertMessage(title: Constant.shared.appTitle, message: "Quantity should not be set to 0", okButton: "Ok", controller: self) {
            }
        }else{
            count = count - 1
            quantitylbl.text = "\(count)"
        }
    }
}

//MARK:- Table View Cell Class

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

//MARK:- Table View Delegate Datasource

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
            cell.titleLbl.text = selectedname
        }else if index == 1{
            cell.titleLbl.text = selectType
        }
        cell.dropDownbutton.tag = indexPath.row
        cell.openPicker.tag = indexPath.row
        cell.openPicker.delegate = self
        cell.openPicker.inputView = picker
        cell.openPicker.tintColor = .clear
        //        cell.openPicker.isUserInteractionEnabled = false
        cell.dropDownbutton.addTarget(self, action: #selector(openPickerView(sender:)), for: .touchUpInside)
        DispatchQueue.main.async {
            self.heightConstraint.constant = CGFloat(self.enquiryDataTBView.contentSize.height)
        }
        return cell
    }
    
    func caretRect(for position: UITextPosition) -> CGRect {
        return CGRect.zero
    }
    
    @objc func openPickerView(sender: UIButton) {
        if let cell = sender.superview?.superview as? EnquiryDataTBViewCell, let indexPath = enquiryDataTBView.indexPath(for: cell){
            cell.openPicker.becomeFirstResponder()
            currentIndex = sender.tag
            
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentIndex = textField.tag
    }
    
}

//MARK:- Structurs


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

struct ProductData {
    var name : String
    var image : String
    var model : String
    
    init(name : String,image : String,model : String) {
        self.name = name
        self.image = image
        self.model = model
    }
}
