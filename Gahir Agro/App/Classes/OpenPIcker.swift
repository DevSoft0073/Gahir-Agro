//
//  OpenPIcker.swift
//  Gahir Agro
//
//  Created by Apple on 28/02/21.
//

import Foundation
import UIKit

protocol ToolbarPickerViewDelegate: class {
    func didTapDone()
    func didTapCancel()
}

class ToolbarPickerView: UIPickerView {

    public private(set) var toolbar: UIToolbar?
    public weak var toolbarDelegate: ToolbarPickerViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    private func commonInit() {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .black
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelTapped))

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        self.toolbar = toolBar
    }

    @objc func doneTapped() {
        self.toolbarDelegate?.didTapDone()
    }

    @objc func cancelTapped() {
        self.toolbarDelegate?.didTapCancel()
    }
}


//    Mark :- >  Code use in view controller to access picker view


//class MyViewController: UIViewController {
//
//    @IBOutlet weak var textField: UITextField!
//    fileprivate let pickerView = ToolbarPickerView()
//    fileprivate let titles = ["0", "1", "2", "3"]
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.textField.inputView = self.pickerView
//        self.textField.inputAccessoryView = self.pickerView.toolbar
//
//        self.pickerView.dataSource = self
//        self.pickerView.delegate = self
//        self.pickerView.toolbarDelegate = self
//
//        self.pickerView.reloadAllComponents()
//    }
//}
//
//extension MyViewController: UIPickerViewDataSource, UIPickerViewDelegate {
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return self.titles.count
//    }
//
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return self.titles[row]
//    }
//
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        self.textField.text = self.titles[row]
//    }
//}
//
//extension MyViewController: ToolbarPickerViewDelegate {
//
//    func didTapDone() {
//        let row = self.pickerView.selectedRow(inComponent: 0)
//        self.pickerView.selectRow(row, inComponent: 0, animated: false)
//        self.textView.text = self.titles[row]
//        self.textField.resignFirstResponder()
//    }
//
//    func didTapCancel() {
//        self.textField.text = nil
//        self.textField.resignFirstResponder()
//    }
//}
