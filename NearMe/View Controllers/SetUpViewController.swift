//
//  SetUpViewController.swift
//  NearMe
//
//  Created by Shravan Prasanth on 5/20/20.
//  Copyright © 2020 Shravan Prasanth. All rights reserved.
//

import UIKit
import BLTNBoard
import CoreLocation

class SetUpViewController: UIViewController, CLLocationManagerDelegate {
    
    
    var locationManager: CLLocationManager?
    
    let userDefaults = UserDefaults()
    
    private lazy var boardManager: BLTNItemManager = {
        
        let item = BLTNPageItem(title: "Current Location")
        item.appearance.titleTextColor = UIColor.lightGray
        item.appearance.descriptionTextColor = UIColor.black
        item.image = UIImage(named: "pin")
        item.appearance.imageViewTintColor = UIColor.white
        item.actionButtonTitle = "Continue"
        item.alternativeButtonTitle = "Deny"
        item.descriptionText = "We need you to accept these permissions to continue. NearMe cannot function without your permission. No data will be distrubuted. This is 100% safe, guaranteed."
        item.actionHandler = { _ in
            self.permissionAccept()
        }
        item.alternativeHandler = { _ in
            self.permissionDenied()
        }
        
        
        return BLTNItemManager(rootItem: item)
    }()
    
    
    func permissionAccept() {
        boardManager.dismissBulletin(animated: true)
        askForPermission()
    }
    
    func permissionDenied() {
        boardManager.dismissBulletin(animated: true)
        denied()
    }
    
    
    @IBOutlet weak var deniedLbl: UILabel!
    @IBOutlet weak var pmButton: UIButton!
    @IBOutlet weak var lbl: UILabel!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        pmButton.isHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        sleep(UInt32(1))
        showBLTNBoard(self)
    }

    
    @IBAction func showBLTNBoard(_ sender: Any) {
        boardManager.backgroundColor = UIColor.white
        
        boardManager.showBulletin(above: self)
    }
    

    func askForPermission() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        checkIfEnabled()
    }
    
    
    func denied() {
        lbl.isHidden = true
        deniedLbl.isHidden = false
        pmButton.isHidden = false

    }
    
    func checkIfEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            
            switch CLLocationManager.authorizationStatus() {
            case .restricted, .denied:
                denied()
            case .authorizedAlways, .authorizedWhenInUse:
                goHome()
                
            case .notDetermined:
                                denied()

            @unknown default:
                break
            }
        } else {
            denied()
        }
    }
    
    func goHome() {
        userDefaults.setValue("Home", forKey: "vc")
        deniedLbl.isHidden = true
        lbl.text = "Setup Complete"
        pmButton.isHidden = true
        print("ACCEPTED")
        performSegue(withIdentifier: "ob", sender: self)
    }
    
}
