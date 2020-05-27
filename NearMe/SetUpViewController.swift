//
//  SetUpViewController.swift
//  NearMe
//
//  Created by Shravan Prasanth on 5/20/20.
//  Copyright © 2020 Shravan Prasanth. All rights reserved.
//

import UIKit
import BLTNBoard

class SetUpViewController: UIViewController {
    
    private lazy var boardManager: BLTNItemManager = {
       
        let item = BLTNPageItem(title: "Current Location")
        item.image = UIImage(named: "pin")
        item.actionButtonTitle = "Continue"
        item.alternativeButtonTitle = "Deny"
        item.descriptionText = "We need you to accept these permissions to continue. This app is pretty much useless without yout permisson. We do not share or distribute this and 100% Safe. Guaranteed."
        
        item.actionHandler = { _ in
            SetUpViewController.permissionAccept()
        }
        item.alternativeHandler = { _ in
            SetUpViewController.permissionDenied()
        }
        
        return BLTNItemManager(rootItem: item)
    }()
    
    
    
    @IBOutlet weak var lbl: UILabel!
    
    var time = 0
    var timer = Timer()
    var timere = Timer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(clock), userInfo: nil, repeats: true)
        timer.fire()
        
    }
    
    @objc func clock() {
        if time == 0 {
            lbl.text = "Setting Up."
            time += 1
        }
        else if time == 1 {
            lbl.text = "Setting Up.."
            time += 1
        }
        else if time == 2 {
            lbl.text = "Setting Up..."
            time += 1
        }
        else if time == 3 {
            lbl.text = "Setting Up."
            time += 1
        }
        else if time == 4 {
            lbl.text = "Setting Up.."
            time += 1
        }
        else if time == 5 {
            lbl.text = "Setting Up..."
            time += 1
        }
        else {
            c()
        }
    }

    
     func c() {
        timer.invalidate()
        timere.invalidate()
        print("DO SETUP NOW")
        lbl.text = "OKDONEe"
    }
    
    
    @IBAction func showBLTNBoard(_ sender: Any) {
        boardManager.showBulletin(above: self)
    }
    
    
    static func permissionAccept() {
        print("Permission Accpet")
        
    }
    
    static func permissionDenied() {
        print("Permission Deny")
    }
    
    
}
