//
//  EditProfileVC.swift
//  Gahir Agro
//
//  Created by Apple on 24/02/21.
//

import UIKit
import SDWebImage
import SKCountryPicker
import AVFoundation
import Alamofire

class EditProfileVC: UIViewController,UITextFieldDelegate ,UITextViewDelegate ,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nameTxtFld: UITextField!
    @IBOutlet weak var bioTxtView: UITextView!
    @IBOutlet weak var addCountryButton: UIButton!
    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var bioView: UIView!
    @IBOutlet weak var passwordVIew: UIView!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var emailTxtFld: UITextField!
    var messgae = String()
    var name = String()
    var imagePicker: ImagePicker!
    var imagePickers = UIImagePickerController()
    var base64String = String()
    var flagBase64 = String()
    var userDetails = [String:Any]()  
    var countryName = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        emailTxtFld.isUserInteractionEnabled = false
        passwordTxtFld.isUserInteractionEnabled = false
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        guard let country = CountryManager.shared.currentCountry else {
            self.flagImage.isHidden = true
            return
        }

//        addCountryButton.setTitle(country.dialingCode, for: .normal)
        flagImage.image = country.flag
        addCountryButton.clipsToBounds = true
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = profileImage.frame.height/2
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    func getData() {
        PKWrapperClass.svprogressHudShow(title: Constant.shared.appTitle, view: self)
        let url = Constant.shared.baseUrl + Constant.shared.ProfileApi
        var deviceID = UserDefaults.standard.value(forKey: "deviceToken") as? String
        let accessToken = UserDefaults.standard.value(forKey: "accessToken")
        print(deviceID ?? "")
        if deviceID == nil  {
            deviceID = "777"
        }
        let params = ["access_token": accessToken]  as? [String : AnyObject] ?? [:]
        print(params)
        PKWrapperClass.requestPOSTWithFormData(url, params: params, imageData: []) { (response) in
            print(response.data)
            PKWrapperClass.svprogressHudDismiss(view: self)
            let status = response.data["status"] as? String ?? ""
            self.messgae = response.data["message"] as? String ?? ""
            if status == "1"{
                let allData = response.data["user_detail"] as? [String:Any] ?? [:]
                self.bioTxtView.text = allData["bio"] as? String
                self.nameTxtFld.text = allData["first_name"] as? String ?? ""
                self.emailTxtFld.text = allData["username"] as? String
                self.passwordTxtFld.text = "**********"
                self.profileImage.sd_setImage(with: URL(string:allData["image"] as? String ?? ""), placeholderImage: UIImage(named: "placehlder"))
                self.flagImage.sd_setImage(with: URL(string:allData["flag_image"] as? String ?? ""), placeholderImage: UIImage(named: "flag"))

                let url = URL(string:allData["image"] as? String ?? "")
                if url != nil{
                    if let data = try? Data(contentsOf: url!)
                    {
                        if let image: UIImage = (UIImage(data: data)){
                            self.profileImage.image = image
                            self.profileImage.contentMode = .scaleToFill
                            IJProgressView.shared.hideProgressView()
                        }
                    }
                }
                else{
                    self.profileImage.image = UIImage(named: "placehlder")
                }
                let urls = URL(string:allData["flag_image"] as? String ?? "")
                if urls != nil{
                    if let data = try? Data(contentsOf: urls!)
                    {
                        if let image: UIImage = (UIImage(data: data)){
                            self.flagImage.image = image
                            self.flagImage.contentMode = .scaleToFill
                            IJProgressView.shared.hideProgressView()
                        }
                    }
                }
                else{
                    self.flagImage.image = UIImage(named: "flag")
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

    
    //MARK:-->    Upload Images
    
    func showActionSheet(){
        //Create the AlertController and add Its action like button in Actionsheet
        let actionSheetController: UIAlertController = UIAlertController(title: NSLocalizedString("Upload Image", comment: ""), message: nil, preferredStyle: .actionSheet)
        actionSheetController.view.tintColor = UIColor.black
        let cancelActionButton: UIAlertAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { action -> Void in
            print("Cancel")
        }
        actionSheetController.addAction(cancelActionButton)
        
        let saveActionButton: UIAlertAction = UIAlertAction(title: NSLocalizedString("Take Photo", comment: ""), style: .default)
        { action -> Void in
//            self.openCamera()
            self.checkCameraAccess()
        }
        actionSheetController.addAction(saveActionButton)
        
        let deleteActionButton: UIAlertAction = UIAlertAction(title: NSLocalizedString("Choose From Gallery", comment: ""), style: .default)
        { action -> Void in
            self.gallery()
        }
        actionSheetController.addAction(deleteActionButton)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePickers.delegate = self
            imagePickers.sourceType = UIImagePickerController.SourceType.camera
            imagePickers.allowsEditing = true
            self.present(imagePickers, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func checkCameraAccess() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied:
            print("Denied, request permission from settings")
            presentCameraSettings()
        case .restricted:
            print("Restricted, device owner must approve")
        case .authorized:
            print("Authorized, proceed")
            self.openCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                if success {
                    print("Permission granted, proceed")
                } else {
                    print("Permission denied")
                }
            }
        }
    }

    func presentCameraSettings() {
        let alertController = UIAlertController(title: "Error",
                                      message: "Camera access is denied",
                                      preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default))
        alertController.addAction(UIAlertAction(title: "Settings", style: .cancel) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                })
            }
        })

        present(alertController, animated: true)
    }
    
    func gallery()
    {
        
        let myPickerControllerGallery = UIImagePickerController()
        myPickerControllerGallery.delegate = self
        myPickerControllerGallery.sourceType = UIImagePickerController.SourceType.photoLibrary
        myPickerControllerGallery.allowsEditing = true
        self.present(myPickerControllerGallery, animated: true, completion: nil)
        
    }
    
    
    //MARK:- ***************  UIImagePickerController delegate Methods ****************
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.editedImage]
            as? UIImage else {
                return
        }
        
        self.profileImage.contentMode = .scaleToFill
        self.profileImage.image = image
        guard let imgData3 = image.jpegData(compressionQuality: 0.2) else {return}
        base64String = imgData3.base64EncodedString(options: .lineLength64Characters)
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.imagePickers = UIImagePickerController()
        dismiss(animated: true, completion: nil)
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if textField == addressTxtFld {
//            addressView.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
//            bioView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//
//
//        } else if textField == emailTxtFld{
//
//        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == bioTxtView{
            bioView.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func uploadImageButton(_ sender: Any) {
        showActionSheet()
    }
    
    @IBAction func uploadCountryButton(_ sender: Any) {
        let countryController = CountryPickerWithSectionViewController.presentController(on: self) { [weak self] (country: Country) in

           guard let self = self else { return }

            self.flagImage.image = country.flag
            UserDefaults.standard.setValue(country.countryName, forKey: "name")
            self.flagBase64 = country.flag?.toString() ?? ""
            UserDefaults.standard.setValue(country.flag?.toString() ?? "", forKey: "flagImage")
            print(UserDefaults.standard.value(forKey: "flagImage"))
         }

         // can customize the countryPicker here e.g font and color
         countryController.detailColor = UIColor.red
    }
    
    @IBAction func openChangePasswordVC(_ sender: Any) {
        let vc = ChangePasswordVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func submitButton(_ sender: Any) {
        if nameTxtFld.text?.isEmpty == true {
            ValidateData(strMessage: "Name field shoud not be empty")
        }else{
            updateData()
        }
    }
    
    
    func updateData()  {
        
        PKWrapperClass.svprogressHudShow(title: Constant.shared.appTitle, view: self)
        let url = Constant.shared.baseUrl + Constant.shared.EditProfile
        _ = UserDefaults.standard.value(forKey: "deviceToken") as? String
        let accessToken = UserDefaults.standard.value(forKey: "accessToken")
        let nameCountry = UserDefaults.standard.value(forKey: "name")
        //        userDetails = ["userID" : id,"name" : nameTxtFld.text ?? "","bio" : bioTxtView.text ?? "","countryName" : countryName]
        
        let params = ["access_token": accessToken,"bio": bioTxtView.text ?? "","first_name":nameTxtFld.text ?? "","country":nameCountry] as? [String : AnyObject] ?? [:]
        print(params)
        print(self.userDetails)
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            print(multipartFormData)
            let imageData1 = self.profileImage.image!.jpegData(compressionQuality: 0.3)
            multipartFormData.append(imageData1!, withName: "image" , fileName: "\(String.random(length: 8))", mimeType: "image/jpeg")
            
        }, to: url, usingThreshold: UInt64.init(), method: .post, headers: nil, interceptor: nil, fileManager: .default)
        
        .uploadProgress(closure: { (progress) in
            print("Upload Progress: \(progress.fractionCompleted)")
        })
        .responseJSON { (response) in
            PKWrapperClass.svprogressHudDismiss(view: self)
            switch response.result {
            case .success(let value):
                if let JSON = value as? [String: Any] {
                    if let dataDict = JSON as? NSDictionary{
                        let message = dataDict["message"] as? String ?? ""
                        let status = JSON["status"] as? String ?? ""
                        if status == "1"{
                            showAlertMessage(title: Constant.shared.appTitle, message: message, okButton: "Ok", controller: self) {
                                NotificationCenter.default.post(name: .sendUserData, object: nil)
                                self.navigationController?.popViewController(animated: true)
                            }
                        }else{
                            alert(Constant.shared.appTitle, message: message, view: self)
                        }
                    }
                }
                
            case .failure(let error):
                if let JSON2 = error as? AFError {
                    PKWrapperClass.svprogressHudDismiss(view: self)
                    print(JSON2)
                    alert(Constant.shared.appTitle, message: "\(JSON2)", view: self)
                }
                break
                
            }
            self.userDetails.removeAll()
        }
    }
}



extension EditProfileVC: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        self.profileImage.image = image
    }
}


extension String {
        func fromBase64() -> String? {
                guard let data = Data(base64Encoded: self) else {
                        return nil
                }
                return String(data: data, encoding: .utf8)
        }
        func toBase64() -> String {
                return Data(self.utf8).base64EncodedString()
        }
}


extension UIImage {
    func toStrings() -> String? {
        let data: Data? = self.pngData()
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
}

extension String {
    
    static func random(length: Int = 8) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
}
