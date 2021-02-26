//
//  PopUpVC.swift
//  Gahir Agro
//
//  Created by Apple on 26/02/21.
//

import UIKit


protocol PopViewControllerDelegate: class {
    func dismissPopUP()
}


class PopUpVC: UIViewController {

    @IBOutlet weak var tableView: UIView!
    var delegates: PopViewControllerDelegate?
    var centerFrame : CGRect!
    var nameArray = [("Delaer",true),("Customer",false),("Sales",false)]
    @IBOutlet weak var selectTypeTBView: UITableView!
    @IBOutlet weak var popupView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        selectTypeTBView.separatorStyle = .none
        view.isOpaque = true
        let mytapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.view.addGestureRecognizer(mytapGestureRecognizer)

        // Do any additional setup after loading the view.
    }
    
    @objc func handleTap(_ sender:UITapGestureRecognizer){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        centerFrame = self.tableView.frame
    }
    
    func presentPopUp()  {
        
        tableView.frame = CGRect(x: centerFrame.origin.x, y: view.frame.size.height, width: centerFrame.width, height: centerFrame.height)
        tableView.isHidden = false
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.90, initialSpringVelocity: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.tableView.frame = self.centerFrame
        }, completion: nil)
    }
    
    
    func dismissPopUp(_ dismissed:@escaping ()->())  {
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.90, initialSpringVelocity: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            
            self.tableView.frame = CGRect(x: self.centerFrame.origin.x, y: self.view.frame.size.height, width: self.centerFrame.width, height: self.centerFrame.height)
            
        },completion:{ (completion) in
            self.dismiss(animated: false, completion: {
                self.selectTypeTBView.isHidden = true
                dismissed()
            })
        })
    }
    
}

class SelectTypeTBViewCell: UITableViewCell {
        
    @IBOutlet weak var selectUnselectButton: UIButton!
    @IBOutlet weak var selectUnselect: UIImageView!
    @IBOutlet weak var typelbl: UILabel!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension PopUpVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectTypeTBViewCell", for: indexPath) as! SelectTypeTBViewCell
        cell.selectUnselect.image = (self.nameArray[indexPath.row].1 == true) ? self.returnImage(name: "check") : self.returnImage(name: "uncheck")
        cell.selectUnselectButton.tag = indexPath.row
        cell.typelbl.text = nameArray[indexPath.row].0
        cell.selectUnselectButton.addTarget(self, action: #selector(increaseCounter(sender:)), for:  .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    @objc func increaseCounter(sender: UIButton) {
        for i in 0..<nameArray.count{
            nameArray[i].1 = false
        }
        nameArray[sender.tag].1 = true
        let new = nameArray[sender.tag].0
        print(new)
        UserDefaults.standard.setValue(new, forKey: "data") as? String ?? ""
        selectTypeTBView.reloadData()
        
    }

    
    func returnImage(name: String) -> UIImage{
        let image = UIImage(named: name)
        return image!
    }
}
