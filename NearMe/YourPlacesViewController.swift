//
//  YourPlacesViewController.swift
//  NearMe
//
//  Created by Shravan Prasanth on 5/23/20.
//  Copyright © 2020 Shravan Prasanth. All rights reserved.
//

import UIKit

class YourPlacesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let userDefaults = UserDefaults()
    
    var yourPlaces = [String]()

    @IBOutlet weak var tblList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblList.tableFooterView = UIView.init(frame: .zero)
        tblList.delegate = self
        tblList.dataSource = self
        overrideUserInterfaceStyle = .light
        addplaces()
        save()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if let name = cell?.contentView.viewWithTag(101) as? UILabel {
            name.text = yourPlaces[indexPath.row]
        }
        
        if let btnDelete = cell?.contentView.viewWithTag(102) as? UIButton {
            btnDelete.addTarget(self, action: #selector(deleteRow), for: .touchUpInside)
        }
        
        return cell!
    }
    
    @objc func deleteRow(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tblList)
        guard let indexPath = tblList.indexPathForRow(at: point) else {
            return
        }
        yourPlaces.remove(at: indexPath.row)
        tblList.deleteRows(at: [indexPath], with: .left)
        save()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        yourPlaces.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tblList.deselectRow(at: indexPath, animated: true)
        let query = yourPlaces[indexPath.row]
        userDefaults.setValue(query, forKey: "up")
        performSegue(withIdentifier: "up", sender: self)
    }
    
    func addplaces() {
        guard let arr = userDefaults.value(forKey: "uarray") else {
            return print("None")
        }
        let revAr = (arr as! NSArray).reversed()
        for place in revAr {
            let uppplace = place as! String
            yourPlaces.insert(uppplace.capitalized, at: 0)
            tblList.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
        }
    }
    
    func save() {
        userDefaults.setValue(yourPlaces, forKey: "uarray")
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
