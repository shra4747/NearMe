//
//  TestViewController.swift
//  NearMe
//
//  Created by Shravan Prasanth on 5/20/20.
//  Copyright © 2020 Shravan Prasanth. All rights reserved.
//

import UIKit
import Foundation


class DetailViewController: UIViewController {
    
    
    let userDefaluts = UserDefaults()
   
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var ratingIMga: UIButton!
    
    var theimage = UIImage()
    var ratemage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        setObjects()
        
        
    }
    
    func setObjects() {
        guard let namey = userDefaluts.value(forKey: "placeP") else {
            name.text = "Error Displaying Name"
            return
        }
        
        guard let addressy = userDefaluts.value(forKey: "placeA") else {
            address.text = "Error Displaying Address"
            return
        }
        
        image.image = theimage
        image.contentMode = .scaleAspectFill
        
        ratingIMga.setImage(ratemage, for: .normal)
        
        name.text = namey as? String
        address.text = addressy as? String
        
        
        //        image.image = UIImage(data: imageData as! Data)
    }
    
    
    
    @IBAction func oam(_ sender: Any) {
        let plusstr = (address.text?.replacingOccurrences(of: " ", with: "+"))! +  "+" + (name.text?.replacingOccurrences(of: " ", with: "+"))!
        if UIApplication.shared.canOpenURL(NSURL(string: "comgooglemaps://?saddr=&daddr=\(String(describing: plusstr))&directionsmode=driving")! as URL) {
            UIApplication.shared.open(NSURL(string: "comgooglemaps://?saddr=&daddr=\(String(describing: plusstr))&directionsmode=driving")! as URL)
        }
        else {
            showAlert()
        }
        
    }
    
    
    
    
    
    @IBAction func ogm(_ sender: Any) {
        let plusstr = (address.text?.replacingOccurrences(of: " ", with: "+"))!
        if UIApplication.shared.canOpenURL(NSURL(string: "http://maps.apple.com/?address=\(plusstr))&dirflg=d&t=h")! as URL) {
            UIApplication.shared.open(NSURL(string: "http://maps.apple.com/?address=\(plusstr))&dirflg=d&t=h")! as URL)
        }
        else {
            showAlert()
        }
    }
    
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func showAlert() {
        let alert = UIAlertController(title: "Error", message: "You might not have Google or Apple Maps installed, or there was some error.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))

        self.present(alert, animated: true)
    }
    
    
    
    
   

}
