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

class EditProfileVC: UIViewController,UITextFieldDelegate ,UITextViewDelegate ,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var bioTxtView: UITextView!
    @IBOutlet weak var addCountryButton: UIButton!
    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var bioView: UIView!
    @IBOutlet weak var passwordVIew: UIView!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var addressTxtFld: UITextField!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var emailTxtFld: UITextField!
    var message = String()
    var name = String()
    var imagePicker: ImagePicker!
    var imagePickers = UIImagePickerController()
    var base64String = String()
    var flagBase64 = String()
    override func viewDidLoad() {
        super.viewDidLoad()
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
        //        guard let image = info[UIImagePickerController.InfoKey.originalImage]
        guard let image = info[UIImagePickerController.InfoKey.editedImage]
            as? UIImage else {
                return
        }
        //        let imgData3 = image.jpegData(compressionQuality: 0.4)
//        self.profileImage.contentMode = .scaleToFill
//        self.profileImage.image = image
        guard let imgData3 = image.jpegData(compressionQuality: 0.2) else {return}
        base64String = imgData3.base64EncodedString(options: .lineLength64Characters)
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.imagePickers = UIImagePickerController()
        dismiss(animated: true, completion: nil)
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
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func uploadImageButton(_ sender: Any) {
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
    
    @IBAction func submitButton(_ sender: Any) {
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
