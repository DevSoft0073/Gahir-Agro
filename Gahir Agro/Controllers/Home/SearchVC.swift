//
//  SearchVC.swift
//  Gahir Agro
//
//  Created by Apple on 24/02/21.
//

import UIKit

class SearchVC: UIViewController {

    @IBOutlet weak var searchDataTBView: UITableView!
    @IBOutlet weak var searchTxtFld: UITextField!
    @IBOutlet weak var searchView: UIView!
    var searchArray = ["First Item","Second Item"]
    override func viewDidLoad() {
        super.viewDidLoad()
        searchDataTBView.separatorStyle = .none
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}

class SearchDataTBViewCell: UITableViewCell {
    
    
    @IBOutlet weak var nameLbl: UILabel!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension SearchVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchDataTBViewCell", for: indexPath) as! SearchDataTBViewCell
        cell.nameLbl.text = searchArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
        
    }
    
}
