//
//  ViewController.swift
//  Near Me
//
//  Created by Shravan Prasanth on 5/18/20.
//  Copyright © 2020 Shravan Prasanth. All rights reserved.
//

import UIKit
import BLTNBoard
import CoreLocation
import Lottie

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var changingIMAGE = UIImage()
    var q = String()
    
    private lazy var boardManager: BLTNItemManager = {
        
        let item = BLTNPageItem(title: "Add New Place?")
        item.image = UIImage(named: "new")
        item.actionButtonTitle = "Yes!"
        item.alternativeButtonTitle = "No thanks."
        item.descriptionText = "Would you like to create custom paces? YOu never have to searc"
        
        item.actionHandler = { _ in
            self.addNew(query: self.q)
        }
        item.alternativeHandler = { _ in
            self.nope()
        }
        
        return BLTNItemManager(rootItem: item)
    }()
    
    
    // https://www.flaticon.com/free-icon/maps-and-flags_447031?term=location&page=1&position=1
    @IBOutlet weak var textFIeld: UITextField!
    
    @IBOutlet weak var loader: UILabel!
    var utah = UIImage()
    @IBOutlet weak var tblList: UITableView!
    
    
    @IBOutlet weak var theview: UIView!
    let animationView = AnimationView()
    
    
    
    
    
    var places = [String]()
    var addresses = [String]()
    var images = [UIImage]()
    
    struct Items {
        var place:String
        var address:String
        var image:UIImage
    }
    
    var items = [Items]()
    
    
    
    
    
    
    let userDefaults = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblList.delegate = self
        textFIeld.delegate = self
        tblList.dataSource = self
        tblList.tableFooterView = UIView.init(frame: .zero)
        overrideUserInterfaceStyle = .light
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        yourPlaceCheck()
    }
    
    func setupAnimation() {
        tblList.isHidden = true
        animationView.isHidden = false
        animationView.frame = theview.bounds
        animationView.animation = Animation.named("globe")
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1.2
        animationView.loopMode = .loop
        animationView.play()
        theview.addSubview(animationView)
    }
    
    func endAnimation() {
        animationView.isHidden = true
        animationView.stop()
        tblList.isHidden = false
    }
    
    @objc func DismissKeyboard() {
        view.endEditing(true)
    }
    
    func link(link: String) {
        guard let url = URL(string: link) else {
            print("SOmethign Went Wrong")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            if error != nil {
                print("THere Was an Error")
            }
            
            let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
            
            let arr = jsonObject?.value(forKey: "results") as? NSArray
            let status = jsonObject?.value(forKey: "status") as? String
            
            if status == "ZERO_RESULTS" {
                print("No Results")
            }
            
            self.formatted(array: arr!)
        }
        task.resume()
        
    }
    
    
    @IBAction func gs(_ sender: Any) {
        setupAnimation()
        deleteAll()
        loader.isHidden = false
        link(link: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=40.4872922,-74.6041664&rankby=distance&keyword=gas%20station&key=AIzaSyC9WK1VVaBAbdR2_31y1OcEhzrzuXRkzyE")
        reloadAllData()
        endAnimation()
        
    }
    
    @IBAction func mkt(_ sender: Any) {
        setupAnimation()
        deleteAll()
        loader.isHidden = false
        
        link(link: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=40.487289,-74.601982&radius=5500&type=market&keyword=market&key=AIzaSyC9WK1VVaBAbdR2_31y1OcEhzrzuXRkzyE")
        reloadAllData()
        endAnimation()
    }
    
    @IBAction func str(_ sender: Any) {
        setupAnimation()
        deleteAll()
        loader.isHidden = false
        
        link(link: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=40.4872922,-74.6041664&rankby=distance&keyword=supermarket&key=AIzaSyC9WK1VVaBAbdR2_31y1OcEhzrzuXRkzyE")
        reloadAllData()
        endAnimation()
    }
    
    @IBAction func testau(_ sender: Any) {
        setupAnimation()
        deleteAll()
        loader.isHidden = false
        
        link(link: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=40.4872922,-74.6041664&rankby=distance&keyword=indian&20restaurant&key=AIzaSyC9WK1VVaBAbdR2_31y1OcEhzrzuXRkzyE")
        reloadAllData()
        endAnimation()
    }
    
    func formatted(array: NSArray) {
        for object in array {
            let dict = object as? NSDictionary
            let name = dict?.value(forKey: "name") as! String
            let address = dict?.value(forKey: "vicinity") as! String
            
            //            guard let rating = dict?.value(forKey: "rating") else {
            //                return print("Errorr")
            //            }
            //
            
            if dict?.value(forKey: "photos") as? NSArray != nil {
                print("YES BRO")
                print(name)
                print("HEY")
                let insname = name
                let insaddress = address
                
                
                let photostest = dict?.value(forKey: "photos") as! NSArray
                
                let sg = photostest.value(forKey: "photo_reference") as! NSArray
                
                let photoref = sg[0] as! String
                
                let url = URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(photoref)&key=AIzaSyC9WK1VVaBAbdR2_31y1OcEhzrzuXRkzyE")!
                
                let taske = URLSession.shared.dataTask(with: url) {(data, response, error) in
                    guard let data = data, let image = UIImage(data: data) else { return }
                    DispatchQueue.main.async {
                        
                        
                        let insimage = image
                        
                        print(name)
                        
                        
                        self.items.append(Items(place: insname, address: insaddress, image: insimage))
                        self.tblList.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
                        self.tblList.reloadData()
                        self.tblList.reloadInputViews()
                        
                    }
                    
                }
                taske.resume()
                
                
                
                
            }
            
        }
    }
    
    
    
    @IBAction func t(_ sender: Any) {
        DispatchQueue.main.async {
        }
    }
    
    
    func addToView(str: String) {
        DispatchQueue.main.async {
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if let place = cell?.contentView.viewWithTag(101) as? UILabel {
            place.text = items[indexPath.row].place
        }
        
        if let address = cell?.contentView.viewWithTag(102) as? UILabel {
            address.text = items[indexPath.row].address
        }
        if let image = cell?.contentView.viewWithTag(103) as? UIButton {
            image.setImage(items[indexPath.row].image, for: .normal)
            image.contentMode = .scaleAspectFit
            image.layer.cornerRadius = 20
            image.layer.masksToBounds = true
        }
        
        if let goto = cell?.contentView.viewWithTag(1010) as? UIButton {
            goto.addTarget(self, action: #selector(goToPlace), for: .touchUpInside)
        }
        
        cell?.isHidden = true
        cell?.isHidden = false
        
        return cell!
    }
    
    @objc func goToPlace(_ sender: UIButton) {
        print("GOING")
        let point = sender.convert(CGPoint.zero, to: tblList)
        guard let indexPath = tblList.indexPathForRow(at: point) else {
            return
        }
        userDefaults.setValue(items[indexPath.row].place, forKey: "placeP")
        userDefaults.setValue(items[indexPath.row].address, forKey: "placeA")
        let imgdata = items[indexPath.row].image.jpegData(compressionQuality: 1)
        userDefaults.setValue(imgdata, forKey: "placeD")
        
        
        //        let imageData = images[indexPath.row].jpegData(compressionQuality: 1.0)
        //        userDefaults.set(imageData, forKey: "userDefaultsWallpaperKey")
        performSegue(withIdentifier: "detail", sender: self)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 370.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tblList.deselectRow(at: indexPath, animated: true)
        changingIMAGE = items[indexPath.row].image 
        //        userDefaults.setValue(places[indexPath.row], forKey: "placeP")
        //        userDefaults.setValue(addresses[indexPath.row], forKey: "placeA")
        //        userDefaults.setValue(images[indexPath.row], forKey: "placeI")
        performSegue(withIdentifier: "detail", sender: self)
        
    }
    
    func deleteAll() {
        DispatchQueue.main.async {
            for _ in self.items {
                self.items.removeFirst()
                self.tblList.deleteRows(at: [IndexPath(row: 0, section: 0)], with: .none)
            }
        }
    }
    
    
    @IBAction func serachforCUstom(_ sender: Any) {
        setupAnimation()
        DismissKeyboard()
        deleteAll()
        let searchQuery = textFIeld.text
        q = textFIeld.text!
        userDefaults.setValue(searchQuery, forKey: "s")
        let stringQuery = searchQuery?.replacingOccurrences(of: " ", with: "%20")
        textFIeld.text = ""
        link(link: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=40.4872922,-74.6041664&rankby=distance&keyword=\(stringQuery!)&key=AIzaSyC9WK1VVaBAbdR2_31y1OcEhzrzuXRkzyE")
//        boardManager.showBulletin(above: self)
        endAnimation()
    }
    
    
    
    
    func reloadAllData() {
        DispatchQueue.main.async {
            self.tblList.reloadData()
            var count = self.places.count
            for _ in self.places {
                self.tblList.reloadRows(at: [IndexPath(row: count-1, section: 0)], with: .fade)
                count += 1
            }
        }
    }
    
    func yourPlaceCheck() {
        if userDefaults.value(forKey: "up") != nil {
            let searchQuery = userDefaults.value(forKey: "up") as! String
            let stringQuery = (searchQuery).replacingOccurrences(of: " ", with: "%20")
            link(link: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=40.4872922,-74.6041664&rankby=distance&keyword=\(stringQuery)&key=AIzaSyC9WK1VVaBAbdR2_31y1OcEhzrzuXRkzyE")
            userDefaults.setValue(nil, forKey: "up")
        }
    }
    
    
    func addNew(query: String) {
        if userDefaults.value(forKey: "uarray") != nil {
            var arr = userDefaults.value(forKey: "uarray") as! Array<Any>
            arr.insert(query, at: 0)
            userDefaults.setValue(arr, forKey: "uarray")
        }
        
        
        
        
        
        boardManager.dismissBulletin(animated: true)
    }
    
    func nope() {
        boardManager.dismissBulletin(animated: true)
    }
    
    
}
