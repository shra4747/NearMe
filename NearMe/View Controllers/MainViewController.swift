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

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    var timer = Timer()
    var changingIMAGE = UIImage()
    var q = String()
    var newplacestring = String()
    var ip = Int()
    
    private lazy var boardManager: BLTNItemManager = {
        let item = BLTNPageItem(title: "Add New Place?")
        item.image = UIImage(named: "new")
        item.appearance.titleTextColor = UIColor.lightGray
        item.appearance.descriptionTextColor = UIColor.black
        item.actionButtonTitle = "Yes!"
        item.alternativeButtonTitle = "No thanks."
        item.descriptionText = "By creating a custom place you will never have to repeat searches again. Click on Your Places to view all of your custom places!"
        
        item.actionHandler = { _ in
            self.addNew(query: self.q)
        }
        item.alternativeHandler = { _ in
            self.nope()
        }
        
        return BLTNItemManager(rootItem: item)
    }()
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    // https://www.flaticon.com/free-icon/maps-and-flags_447031?term=location&page=1&position=1
    @IBOutlet weak var textFIeld: UITextField!
    
    var utah = UIImage()
    @IBOutlet weak var tblList: UITableView!
    

    var places = [String]()
    var addresses = [String]()
    var images = [UIImage]()
    
    struct Items {
        var place:String
        var address:String
        var image:UIImage
        var rating:Int
    }
    
    var items = [Items]()
        
    var lat = String()
    var long = String()
    
    
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
        tblList.separatorStyle = .none
        getLocation()
        yourPlaceCheck()
        
        spinner.isHidden = true
    }
    
    func getLocation() {
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        else {
            noLocationFound()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else {
            noLocationFound()
            return
        }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        let locValueLat = locValue.latitude
        let locValueLojg = locValue.longitude
        lat = "\(locValueLat)"
        long = "\(locValueLojg)"
        
        print(lat + " " + long)
    }
    
    
    func noLocationFound() {
        let alertCOntroller = UIAlertController(title: "ERROR", message: "Sorry, you have not yet enabled the location services for this app. Please Go into Settings > Privacy > Location Services > and turn on location services for 'Near Me'.", preferredStyle: .alert)
        alertCOntroller.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alertCOntroller, animated: true, completion: nil)
    }
    
    @IBOutlet weak var animView: UIView!
    let animationview = AnimationView()

    func setupAnimation() {
        count = 0
        animView.alpha = 1
        animationview.alpha = 1
        animationview.frame = animView.bounds
        animationview.animation = Animation.named("theloader")
        animationview.contentMode = .scaleAspectFit
        animationview.animationSpeed = 1
        animationview.loopMode = .loop
        animationview.play()
        animView.addSubview(animationview)
        let timer1 = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        
        timer1.fire()
        print("FIRED ")
    }
    var count = 0
    
    @objc func fireTimer() {
        if count == 4 {
            
            self.tblList.alpha = 1
            animationview.stop()
            animView.alpha = 0
            count = 0
        }
        else {
            count += 1
        }
    }
    
    @objc func DismissKeyboard() {
        view.endEditing(true)
    }
    
    func link(link: String) {
        guard let url = URL(string: link) else {
            print("SOmethign Went Wrong")
            self.thereWasAnError()
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else {self.thereWasAnError(); return }
            if error != nil {
                self.thereWasAnError()
                print("THere Was an Error")
            }
            
            let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
            
            let arr = jsonObject?.value(forKey: "results") as? NSArray
            let status = jsonObject?.value(forKey: "status") as? String
            
            if status == "ZERO_RESULTS" {
                print("No Results")
                self.noResults()
            }
            else {
                self.formatted(array: arr!)
            }
            
        }
        task.resume()
        
    }
    func thereWasAnError() {
        DispatchQueue.main.async {
            self.boardManager.dismissBulletin(animated: false)
            let alert = UIAlertController(title: "Sorry!", message: "There was some error. Please try again or change your search query!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func noResults() {
        DispatchQueue.main.async {
            self.boardManager.dismissBulletin(animated: false)
            let alert = UIAlertController(title: "Sorry!", message: "No Results. Sorry! Search for something else!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func gs(_ sender: Any) {
        setupAnimation()
        deleteAll()
        link(link: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat),\(long)&rankby=distance&keyword=gas%20station&key=AIzaSyC9WK1VVaBAbdR2_31y1OcEhzrzuXRkzyE")
        reloadAllData()
    }
    
    @IBAction func hotel(_ sender: Any) {
        setupAnimation()
        deleteAll()
        link(link: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat),\(long)&rankby=distance&keyword=hotel&key=AIzaSyC9WK1VVaBAbdR2_31y1OcEhzrzuXRkzyE")
        reloadAllData()
    }
    
    
    @IBAction func str(_ sender: Any) {
        setupAnimation()
        deleteAll()
        link(link: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat),\(long)&rankby=distance&keyword=supermarket&key=AIzaSyC9WK1VVaBAbdR2_31y1OcEhzrzuXRkzyE")
        reloadAllData()
    }
    
    @IBAction func testau(_ sender: Any) {
        setupAnimation()
        deleteAll()
        link(link: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat),\(long)&rankby=distance&keyword=restaurant&key=AIzaSyC9WK1VVaBAbdR2_31y1OcEhzrzuXRkzyE")
        reloadAllData()
    }
    
    func formatted(array: NSArray) {
        var tIMage = UIImage()
        for object in array {
            let dict = object as? NSDictionary
            //            print(dict!)
            if dict?.value(forKey: "photos") as? NSArray != nil {
                
                
                let name = dict?.value(forKey: "name") as! String
                
                let address = dict?.value(forKey: "vicinity") as! String
                
                print(name + address)
                //                print(name)
                var rate = NSNumber()
                
                if let rating = dict?.value(forKey: "rating") {
                    rate = (rating as? NSNumber)!
                }
                else {
                    rate = 0
                }


                let photostest = dict?.value(forKey: "photos") as! NSArray

                let sg = photostest.value(forKey: "photo_reference") as! NSArray

                let photoref = sg[0] as! String

                let url = URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(photoref)&key=AIzaSyC9WK1VVaBAbdR2_31y1OcEhzrzuXRkzyE")!


                let taske = URLSession.shared.dataTask(with: url) {(data, response, error) in
                    guard let data = data, var image = UIImage(data: data) else {
                        return
                    }
                    DispatchQueue.main.async {
                        self.items.append(Items(place: name, address: address, image: image, rating: Int(truncating: rate)))

                        self.tblList.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
                        self.tblList.reloadData()
                        self.tblList.reloadInputViews()
                    }
                }
                taske.resume()
                

                
                
            }
            
            
        }
        
    }
    func add() {
       
    }
    
    
    
    func t(_ sender: Any) {
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
            image.contentMode = .scaleAspectFill
            image.layer.cornerRadius = 20
            image.layer.masksToBounds = true
        }
        
        if let ratemage = cell?.contentView.viewWithTag(222) as? UIButton {
            
            let zero = UIImage(named: "zero_rating")
            let one = UIImage(named: "one_rating")
            let two = UIImage(named: "two_rating")
            let three = UIImage(named: "three_rating")
            let four = UIImage(named: "four_rating")
            let five = UIImage(named: "five_rating")
            
            
            let rating = items[indexPath.row].rating
            
            if rating == 0 {
                ratemage.setImage(zero, for: .normal)
            }
            else if rating == 1 {
                ratemage.setImage(one, for: .normal)
            }
            else if rating == 2 {
               ratemage.setImage(two, for: .normal)
            }
            else if rating == 3 {
                ratemage.setImage(three, for: .normal)
            }
            else if rating == 4 {
                ratemage.setImage(four, for: .normal)
            }
            else if rating == 5 || rating > 5 {
                ratemage.setImage(five, for: .normal)
            }
            
            
            
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
            
        ip = indexPath.row
        
        userDefaults.setValue(indexPath.row, forKey: "indexPath")
        
        print(userDefaults.value(forKey: "placeP")!)

        print(userDefaults.value(forKey: "placeA")!)


        
        //        let imageData = images[indexPath.row].jpegData(compressionQuality: 1.0)
        //        userDefaults.set(imageData, forKey: "userDefaultsWallpaperKey")
        performSegue(withIdentifier: "detail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detail" {
            let vc = segue.destination as! DetailViewController;()
            vc.theimage = items[ip].image
            
            let rating = items[ip].rating
            
            if rating == 0 {
                vc.ratemage = UIImage(named: "zero_rating")!
            }
            else if rating == 1 {
                vc.ratemage = UIImage(named: "one_rating")!
            }
            else if rating == 2 {
               vc.ratemage = UIImage(named: "two_rating")!
            }
            else if rating == 3 {
                vc.ratemage = UIImage(named: "three_rating")!
            }
            else if rating == 4 {
                vc.ratemage = UIImage(named: "four_rating")!
            }
            else if rating == 5 || rating > 5 {
                vc.ratemage = UIImage(named: "five_rating")!
            }
        }
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
            self.items.removeAll()
            self.tblList.reloadData()
        }
    }
    
    
    @IBAction func serachforCUstom(_ sender: Any) {
        setupAnimation()
        DismissKeyboard()
        if !textFIeld.text!.isEmpty {
            deleteAll()
            let searchQuery = textFIeld.text
            newplacestring = searchQuery!
            q = textFIeld.text!
            userDefaults.setValue(searchQuery, forKey: "s")
            let stringQuery = searchQuery?.replacingOccurrences(of: " ", with: "%20")
            textFIeld.text = ""
            link(link: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat),\(long)&rankby=distance&keyword=\(stringQuery!)&key=AIzaSyC9WK1VVaBAbdR2_31y1OcEhzrzuXRkzyE")
            boardManager.backgroundColor = UIColor.white
                    boardManager.showBulletin(above: self)
            
        }
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        setupAnimation()
        DismissKeyboard()
        if !textField.text!.isEmpty {
            deleteAll()
            let searchQuery = textFIeld.text
            newplacestring = searchQuery!
            q = textFIeld.text!
            userDefaults.setValue(searchQuery, forKey: "s")
            let stringQuery = searchQuery?.replacingOccurrences(of: " ", with: "%20")
            textFIeld.text = ""
            link(link: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat),\(long)&rankby=distance&keyword=\(stringQuery!)&key=AIzaSyC9WK1VVaBAbdR2_31y1OcEhzrzuXRkzyE")
            boardManager.backgroundColor = UIColor.white
            boardManager.showBulletin(above: self)
        }
        
        
        
        return true
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
            link(link: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat),\(long)&rankby=distance&keyword=\(stringQuery)&key=AIzaSyC9WK1VVaBAbdR2_31y1OcEhzrzuXRkzyE")
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
