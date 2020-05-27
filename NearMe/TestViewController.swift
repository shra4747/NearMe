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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light  
        setObjects()
        image.image = ViewController().changingIMAGE
        
        
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
        
        guard let imagey = userDefaluts.object(forKey: "placeD") else {
            image.image = UIImage(named: "utah-440520_1920")
            return
        }
        
        name.text = namey as? String
        address.text = addressy as? String
        image.image = UIImage(data: imagey as! Data)
    }
    
    
    
    @IBAction func oam(_ sender: Any) {
        let plusstr = (address.text?.replacingOccurrences(of: " ", with: "+"))! +  "+" + (name.text?.replacingOccurrences(of: " ", with: "+"))!
        UIApplication.shared.open(NSURL(string: "comgooglemaps://?saddr=&daddr=\(String(describing: plusstr))&directionsmode=driving")! as URL)
        }
    
        
    
    
    
    
    @IBAction func ogm(_ sender: Any) {
        let plusstr = name.text?.replacingOccurrences(of: " ", with: "+")
        
        //http://maps.apple.com/?saddr=&daddr=\(String(describing: plusstr!))

        
        UIApplication.shared.open(NSURL(string: "comapplemaps://?saddr=&daddr=\(String(describing: plusstr!))&directionsmode=driving")! as URL)
    }
    
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
   

}
