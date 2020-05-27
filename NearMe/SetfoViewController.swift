//
//  SetfoViewController.swift
//  NearMe
//
//  Created by Shravan Prasanth on 5/26/20.
//  Copyright © 2020 Shravan Prasanth. All rights reserved.
//

import UIKit
import BLTNBoard

class SetfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var settings = ["Share bugs or request improvements here!", "Reset all data", "Credits", "Version 1.0.0","Copyright (c) 2020 Shravan Prasanth. All Rights Reserved."]
    
    private lazy var boardManager: BLTNItemManager = {
        
        let item = BLTNPageItem(title: "Delete Data?")
        item.image = UIImage(named: "bin")
        item.appearance.imageViewTintColor = UIColor.white
        item.actionButtonTitle = "Confirm"
        item.alternativeButtonTitle = "Cancel"
        item.descriptionText = "Are you sure you want to delte all data? This action cannot be un-done."
        item.actionHandler = { _ in
            self.confirmAndDelete()
        }
        item.alternativeHandler = { _ in
            self.noshow()
        }
        
        return BLTNItemManager(rootItem: item)
    }()
    
    @IBOutlet weak var tblList: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tblList.tableFooterView = UIView.init(frame: .zero)
        tblList.delegate = self
        tblList.dataSource = self
        
        overrideUserInterfaceStyle = .light
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = settings[indexPath.row]
        cell?.textLabel!.font = UIFont(name:"Jost", size:18)
        if indexPath.row > 2 {
            cell?.textLabel?.textColor = UIColor.lightGray
            cell?.isUserInteractionEnabled = false
            if indexPath.row == 4 {
                cell?.textLabel!.font = UIFont(name:"Jost", size:13)
            }
        }
        
        if let image = cell?.contentView.viewWithTag(1010) as? UIButton {
            if indexPath.row > 2 {
                image.isHidden = true
            }
        }

        cell?.separatorInset = .zero
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tblList.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            goToBugs()
        }
        else if indexPath.row == 1 {
            boardManager.showBulletin(above: self)
        }
        else if indexPath.row == 2 {
            performSegue(withIdentifier: "credits", sender: self)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 43.5
    }
    
    
    func goToBugs() {
        UIApplication.shared.open(NSURL(string: "https://docs.google.com/forms/d/e/1FAIpQLSfMspJs0SKkt_dxxuBmgwCk-lVOgMjDJLo0Lz2RMRnBSSDrSg/viewform")! as URL)
    }
    
    func confirmAndDelete() {
        boardManager.dismissBulletin(animated: true)
        // Delete all Data Saved in App
    }
    
    func noshow() {
        boardManager.dismissBulletin(animated: true)
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
}
