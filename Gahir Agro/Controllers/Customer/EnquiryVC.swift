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
    var listingArray = ["First","Second","Third","Fourth"]
    
    
    var indexesNeedPicker: [NSIndexPath]?
    
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
        
        super.viewDidLoad()
    }
    
    @objc func onDoneButtonTapped(sender:UIButton) {
        self.view.endEditing(true)
    }
    
    //    MARK:->    Picker View Methods
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        listingArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedValue = listingArray[row]
//        selectTypeTxtFld.text = listingArray[row]
        selectedValue = listingArray[row]
        print(selectedValue)
        DispatchQueue.main.async {
            self.enquiryDataTBView.reloadData()
        }
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = (view as? UILabel) ?? UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: "Poppins-Medium", size: 20)
        label.text = listingArray[row]
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    @IBAction func backbutton(_ sender: Any) {
    }
    
    
    @IBAction func submitButton(_ sender: Any) {
    }
    
    
    @IBAction func addLbl(_ sender: Any) {
    }
    
    @IBAction func minusButton(_ sender: Any) {
    }
}

class EnquiryDataTBViewCell: UITableViewCell {
    
    @IBOutlet weak var openPicker: UITextField!
    @IBOutlet weak var dropDownbutton: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var namelbl: UILabel!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension EnquiryVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tbaleViewArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EnquiryDataTBViewCell", for: indexPath) as! EnquiryDataTBViewCell
//        DispatchQueue.main.async {
//            self.heightConstraint.constant = self.enquiryDataTBView.contentSize.height
//        }
        cell.namelbl.text = tbaleViewArray[indexPath.row]
        cell.dropDownbutton.addTarget(self, action: #selector(openPickerView), for: .touchUpInside)
        cell.openPicker.inputView = picker
        cell.titleLbl.text = selectedValue
        return cell
    }
    @objc func openPickerView() {
        picker.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
}
