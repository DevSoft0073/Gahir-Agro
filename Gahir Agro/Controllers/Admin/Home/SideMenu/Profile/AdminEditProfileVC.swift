//
//  AdminEditProfileVC.swift
//  Gahir Agro
//
//  Created by Apple on 17/03/21.
//

import UIKit
import SDWebImage
import SKCountryPicker
import AVFoundation
import Alamofire

class AdminEditProfileVC: UIViewController ,UITextFieldDelegate , UITextViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var nameTxtFld: UITextField!
    @IBOutlet weak var bioView: UIView!
    @IBOutlet weak var bioTxtView: UITextView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var addressTxtFld: UITextField!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailTxtFld: UITextField!
    var imagePickers = UIImagePickerController()
    var base64String = String()
    var messgae = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        emailTxtFld.isUserInteractionEnabled = false
        passwordTxtFld.isUserInteractionEnabled = false
        // Do any additional setup after loading the view.
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
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == addressTxtFld {
            addressView.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            bioView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            
            
        } else if textField == emailTxtFld{
           
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == bioTxtView{
            bioView.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            addressView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    
    @IBAction func backButtonAction(_ sender: Any) {
    }
    
    @IBAction func submitButton(_ sender: Any) {
    }
    
    @IBAction func uploadImageButtonAction(_ sender: Any) {
        showActionSheet()
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
    

}

extension AdminEditProfileVC: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        self.profileImage.image = image
    }
}