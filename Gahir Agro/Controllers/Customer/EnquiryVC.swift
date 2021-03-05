//
//  EnquiryVC.swift
//  Gahir Agro
//
//  Created by Apple on 25/02/21.
//

import UIKit

class EnquiryVC: UIViewController, UINavigationControllerDelegate, UIPickerViewDelegate,UIPickerViewDataSource {
    
    var tbaleViewArray = ["TYPE","COLOR","SYSTEM","SYSTEM"]
    var picker  = UIPickerView()

    var pickerToolBar = UIToolbar()
    var selectedValue = String()
    var selectedValue1 = String()
    var selectedValue2 = String()
    var selectedValue3 = String()
    var listingArray = ["First","Second","Third","Fourth"]
    var colorArray = ["Blue","Red","Yellow","Green"]
    var systemArray = [""]
    var modelNameArray = [""]
    var currentIndex = Int()
    var count = 0
    var id = String()
    var productId = String()
    var indexesNeedPicker: [NSIndexPath]?
    var messgae = String()
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var enquiryDataTBView: UITableView!
    @IBOutlet weak var quantitylbl: UILabel!
    @IBOutlet weak var detailsLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var showImage: UIImageView!
    override func viewDidLoad() {
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
    
    
    func submitEnquiry() {
        PKWrapperClass.svprogressHudShow(title: Constant.shared.appTitle, view: self)
        let url = Constant.shared.baseUrl + Constant.shared.contactUS
        var deviceID = UserDefaults.standard.value(forKey: "deviceToken") as? String
        let accessToken = UserDefaults.standard.value(forKey: "accessToken")
        print(deviceID ?? "")
        if deviceID == nil  {
            deviceID = "777"
        }
        
        let params = ["product_id" : id , "quantity" : "quantity", "accessory" : "accessory" ,"access_token": accessToken,"system" : "system" , "type" : "type"]  as? [String : AnyObject] ?? [:]
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
    
    //    MARK:->    Picker View Methods
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        let numberOfRows = 0
        
        if currentIndex == 0{
            return listingArray.count
            
        }else if currentIndex == 1{
            return colorArray.count
        }else if currentIndex == 2{
            return systemArray.count
        }else if currentIndex == 3{
            return systemArray.count
        }else{
            return numberOfRows
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        if currentIndex == 0{
            
            selectedValue = listingArray[row]
            self.enquiryDataTBView.reloadData()
            print(selectedValue)
            
        }else if currentIndex == 1{
            
            selectedValue1 = colorArray[row]
            print(selectedValue1)
            self.enquiryDataTBView.reloadData()

        }else if currentIndex == 2{
            
            selectedValue2 = systemArray[row]
            print(selectedValue2)
            self.enquiryDataTBView.reloadData()
        }else if currentIndex == 3{
            
            selectedValue3 = systemArray[row]
            print(selectedValue3)
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
            label.text = listingArray[row]
            return label
        }else if currentIndex == 1{
            
            label.textColor = .black
            label.textAlignment = .center
            label.font = UIFont(name: "Poppins-Medium", size: 20)
            label.text = colorArray[row]
            return label
            
        }else if currentIndex == 2{
            
            label.textColor = .black
            label.textAlignment = .center
            label.font = UIFont(name: "Poppins-Medium", size: 20)
            label.text = systemArray[row]
            return label
            
        }else if currentIndex == 3{
            
            label.textColor = .black
            label.textAlignment = .center
            label.font = UIFont(name: "Poppins-Medium", size: 20)
            label.text = systemArray[row]
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
            return listingArray[row]
        }else if currentIndex == 1{
            return colorArray[row]
        }else if currentIndex == 2{
            return systemArray[row]
        }else if currentIndex == 3{
            return systemArray[row]
        }
        return listingArray[row]
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

class EnquiryDataTBViewCell: UITableViewCell {
    
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
        if currentIndex == 0{
            cell.titleLbl.text = selectedValue
        }else if currentIndex == 1{
            cell.titleLbl.text = selectedValue1
        }else if currentIndex == 2{
            cell.titleLbl.text = selectedValue2
        }else if currentIndex == 3{
            cell.titleLbl.text = selectedValue3
        }
        cell.dropDownbutton.tag = indexPath.row
        cell.dropDownbutton.addTarget(self, action: #selector(openPickerView), for: .allEvents)
        DispatchQueue.main.async {
            self.heightConstraint.constant = CGFloat(self.enquiryDataTBView.contentSize.height)
        }
        return cell
    }
    
    @objc func openPickerView(sender: UIButton) {
        
        let section = 0
        let row = sender.tag
        let indexPath = IndexPath(row: row, section: section)
        let cell: EnquiryDataTBViewCell = self.enquiryDataTBView.cellForRow(at: indexPath) as! EnquiryDataTBViewCell
        print(indexPath.row)
        currentIndex = indexPath.row
        cell.openPicker.inputView = picker
        self.picker.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
