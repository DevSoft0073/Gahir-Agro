//
//  SignUPVC.swift
//  Gahir Agro
//
//  Created by Apple on 12/03/21.
//

import UIKit
import SKCountryPicker
class SignUPVC: UIViewController {
    
    @IBOutlet weak var serialNumberTxtFld: UITextField!
    @IBOutlet weak var numberTxtFld: UITextField!
    @IBOutlet weak var countryButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.countryButton.contentHorizontalAlignment = .right
        guard let country = CountryManager.shared.currentCountry else {
            return
        }
        countryButton.setTitle(country.countryCode, for: .highlighted)
        countryButton.clipsToBounds = true
    }
    @IBAction func generateButtonAction(_ sender: Any) {
        
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func openCountryPickerButtonAction(_ sender: Any) {
        let countryController = CountryPickerWithSectionViewController.presentController(on: self) { [weak self] (country: Country) in
            
            guard let self = self else { return }
            
            self.countryButton.setTitle(country.dialingCode, for: .normal)
            UserDefaults.standard.setValue(country.dialingCode, forKey: "code") as? String ?? "+91"
            UserDefaults.standard.setValue(country.flag?.toString() ?? "", forKey: "flagImage")
        }
    }
    
}
