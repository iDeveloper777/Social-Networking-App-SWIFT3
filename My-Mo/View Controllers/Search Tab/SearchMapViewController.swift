//
//  SearchMapViewController.swift
//  My-Mo
//
//  Created by iDeveloper on 11/14/16.
//  Copyright © 2016 iDeveloper. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SearchMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    @IBOutlet weak var view_Title: UIView!
    @IBOutlet weak var view_Gradient: UIView!
    @IBOutlet weak var img_Gradient: UIImageView!
    
    @IBOutlet weak var img_Avatar: UIImageView!
    @IBOutlet weak var img_Avatar_BG: UIImageView!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var img_CountryCity: UIImageView!
    @IBOutlet weak var lbl_CountryCity: UILabel!
    @IBOutlet weak var lbl_Followers: UILabel!
    @IBOutlet weak var lbl_Description: UILabel!
    

    @IBOutlet weak var view_Map: UIView!
    @IBOutlet weak var mapView: MKMapView!
    
    
    
    var array_Live_Motiffs: [Host] = []
    var objLocationManager: CLLocationManager = CLLocationManager()
    var current_Latitude: Double = 0.0
    var current_Longitude: Double = 0.0
    
    // MARK: - Life Cycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        setLayout()
        setGradientLayout()
        setMapLayout()
        initLocations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        let allAnnotations = self.mapView.annotations
//        self.mapView.removeAnnotations(allAnnotations)
    }
    
    // MARK: - setLayout
    func setLayout(){
        img_Avatar.frame = CGRect(x: COMMON.X(view: img_Avatar),
                                    y: COMMON.Y(view: img_Avatar),
                                    width: COMMON.WIDTH(view: img_Avatar),
                                    height: COMMON.WIDTH(view: img_Avatar))
        img_Avatar?.layer.cornerRadius = (img_Avatar?.frame.size.width)! / 2
        img_Avatar?.layer.masksToBounds = true
        img_Avatar?.layer.borderWidth = 0
        img_Avatar?.layer.borderColor = UIColor.gray.cgColor
    }
    
    func setGradientLayout(){
        img_Gradient.frame = CGRect(x: 0,
                                    y: (COMMON.HEIGHT(view: view_Gradient) - Main_Screen_Width) / 2,
                                    width: Main_Screen_Width,
                                    height: Main_Screen_Width)
        
        var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        
        if #available(iOS 10.0, *) {
            blurEffect = UIBlurEffect(style: UIBlurEffectStyle.regular)
        } else {
            // Fallback on earlier versions
        }
        //        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        let blurEffectView = UIVisualEffectView(effect: vibrancyEffect)
        blurEffectView.frame = view_Gradient.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        view_Gradient.addSubview(blurEffectView)

    }

    func initLocations(){
        
    }
    
    func setMapLayout(){
        objLocationManager = CLLocationManager()
        objLocationManager.delegate = self
        objLocationManager.distanceFilter = 10
        objLocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
//        if objLocationManager.responds(to: #selector(self.requestAlwaysAuthorization)) {
//            objLocationManager.requestAlwaysAuthorization()
//        }
        objLocationManager.requestAlwaysAuthorization()
        objLocationManager.startUpdatingLocation()
        
//        let coordinate = objLocationManager.location?.coordinate
//        let extentsRegion = MKCoordinateRegionMakeWithDistance(coordinate!, 800, 800)
//        mapView.setRegion(extentsRegion, animated: true)

        
        let location = CLLocationCoordinate2D(latitude: 51.497970, longitude: -0.101727)
//        var span = MKCoordinateSpan()
//        span.latitudeDelta = 0.005
//        span.longitudeDelta = 0.005
        
//        var region = MKCoordinateRegion()
        let region = MKCoordinateRegionMakeWithDistance(location, 800.0, 800.0)
//        region.span = span
//        region.center = location
        
//        mapView.setRegion(region, animated: true)
    }
    
    // MARK: - map View
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        var region = MKCoordinateRegion()
        var span = MKCoordinateSpan()
        span.latitudeDelta = 0.005
        span.longitudeDelta = 0.005
        var location = CLLocationCoordinate2D()
        location.latitude = userLocation.coordinate.latitude
        location.longitude = userLocation.coordinate.longitude
        region.span = span
        region.center = location
        mapView.setRegion(region, animated: true)
    }
    
    func loadUserLocation(){
        objLocationManager = CLLocationManager()
        objLocationManager.delegate = self
        objLocationManager.distanceFilter = 10
        objLocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
//        if objLocationManager.responds(to: #selector(self.requestAlwaysAuthorization)) {
            objLocationManager.requestAlwaysAuthorization()
//        }
        objLocationManager.startUpdatingLocation()

    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let newLocation = locations[0]
//        latitude = newLocation.coordinate.latitude
//        longitude = newLocation.coordinate.longitude
//        objLocationManager.stopUpdatingLocation()
////        self.loadMapView()
//
//    }

    func mapViewDidFailLoadingMap(_ mapView: MKMapView, withError error: Error) {
        objLocationManager.stopUpdatingLocation()
    }
    
    func loadMapView(){
        var objCoor2D = CLLocationCoordinate2D()
        objCoor2D.latitude = current_Latitude
        objCoor2D.longitude = current_Longitude
        var objCoorSpan = MKCoordinateSpan()
        objCoorSpan.latitudeDelta = 0.005
        objCoorSpan.longitudeDelta = 0.005
        let objMapRegion: MKCoordinateRegion = MKCoordinateRegion(center: objCoor2D, span: objCoorSpan)
        
        mapView.region = objMapRegion

    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let parkingAnnotationIdentifier = "ParkingAnnotationIdentifier"
        if (annotation is MKUserLocation) {
            return nil
        }
        
//        if (isDisplayedAnnotation(title: annotation.title!!) == true){
//            return nil
//        }
        
        let host: Host? = getHostWithHostID(id: annotation.title!!)
        let index: Int = getIndexWithHostID(id: annotation.title!!)
        let user: User? = getUserWithUserID(id: (host?.user_id)!)
        
        //Try to get an unused annotation, similar to uitableviewcells
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: parkingAnnotationIdentifier)
        //If one isn't available, create a new one
        if (annotationView == nil) {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: parkingAnnotationIdentifier)
            annotationView?.image = UIImage(named: "Search_img_Annotation.png")!
            
            let bottomImage = UIImage(named: "Search_img_Annotation.png")
            let topImage = IMAGEPROCESSING.makeRoundedImage(image: UIImage(named: "Search_img_Avatar_BG.png")!, radius: 20)
            let newImage:UIImage = IMAGEPROCESSING.makeMergeImage(bottomImage: bottomImage!, topImage: topImage)
            
            annotationView?.image = newImage
            annotationView?.tag = index
        }
        
        //Async Image
        if (user == nil){
            return annotationView
        }else {
            if (user?.avatar == ""){
                return annotationView
            }
        }
        
        if (annotation.title == nil){
            return annotationView
        }
        
//        let catPictureURL = URL(string: (user?.avatar)!)!
        
        ImageLoader.sharedLoader.imageForUrl(urlString: (user?.avatar)!, completionHandler:{(image: UIImage?, url: String) in
            
            print("Avatar Image Downloaed")
            
            let bottomImage = UIImage(named: "Search_img_Annotation.png")
            let topImage = IMAGEPROCESSING.makeRoundedImage(image: image!, radius: 20)
            let newImage:UIImage = IMAGEPROCESSING.makeMergeImage(bottomImage: bottomImage!, topImage: topImage)
            
            annotationView?.image = newImage
            annotationView?.tag = index
        })
        
        
        
//        let session = URLSession(configuration: .default)
//
//        // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
//        let downloadPicTask = session.dataTask(with: catPictureURL) { (data, response, error) in
//            
//            // The download has finished.
//            if let e = error {
//                print("Error downloading cat picture: \(e)")
//            } else {
//                // No errors found.
//                // It would be weird if we didn't have a response, so check for that too.
//                if (response as? HTTPURLResponse) != nil {
////                    print("Downloaded cat picture with response code \(res.statusCode)")
//                    if let imageData = data {
//                        // Finally convert that Data into an image and do what you wish with it.
//                        var image = UIImage(data: imageData)
//                        
//                        print("Avatar Image Downloaed")
//                        
////                        image = UIImage(named: "Search_img_Sample.png")
//                        
//                        self.img_Avatar.image = image
//                        
//                        let bottomImage = UIImage(named: "Search_img_Annotation.png")
//                        let topImage = IMAGEPROCESSING.makeRoundedImage(image: image!, radius: 20)
//                        let newImage:UIImage = IMAGEPROCESSING.makeMergeImage(bottomImage: bottomImage!, topImage: topImage)
//                        
//                        annotationView?.image = newImage
//                        annotationView?.tag = index
//                        
//                        // Do something with your image.
//                    } else {
//                        print("Couldn't get image: Image is nil")
//                    }
//                } else {
//                    print("Couldn't get response code for some reason")
//                }
//            }
//        }
//        
//        downloadPicTask.resume()
        
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let host: Host = array_Live_Motiffs[view.tag]
        let user: User = getUserWithUserID(id: host.user_id)!
        
        img_Avatar.sd_setImage(with: URL(string: user.avatar), placeholderImage: UIImage(named: "Placeholder_Avatar.png"))
        img_Avatar_BG.sd_setImage(with: URL(string: user.avatar), placeholderImage: UIImage(named: "Placeholder_Avatar.png"))
        lbl_Title.text = host.title
        lbl_Name.text = user.name
        img_CountryCity.isHidden = false
        lbl_CountryCity.text = user.country + "/" + user.city
        lbl_Followers.text = "Followers: " + String(user.followers)
        lbl_Description.text = "Description: " + host.Description
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        COMMON.methodForAlert(titleString: "Error", messageString: "There was an error retrieving your location", OKButton: kOkButton, CancelButton: "", viewController: self)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Assigning the last object as the current location of the device
        let currentLocation = locations.last!
        let currentLat = String(format: "%.8f", currentLocation.coordinate.latitude)
        let currentLong = String(format: "%.8f", currentLocation.coordinate.longitude)
        
        if (current_Latitude == 0 && current_Longitude == 0){
            print(currentLong)
            print(currentLat)
            
            let location = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
            let region = MKCoordinateRegionMakeWithDistance(location, 800.0, 800.0)
            mapView.setRegion(region, animated: true)
            
            loadAllUsersFromFirebase()
        }
        
        current_Latitude = Double(currentLat)!
        current_Longitude = Double(currentLong)!
        
        //        host.location_latitude = "51.497970"
        //        host.location_longitude = "-0.101727"
        
        //        print("curretn lat \(currentLat) long \(currentLong)")
        
        // Reverse Geocoding
        //        print("Resolving the Address")
//        geocoder.reverseGeocodeLocation(currentLocation, completionHandler: {(placemarks, error) -> Void in
//            if error == nil && (placemarks?.count)! > 0 {
//                self.placemark = placemarks?.last
//                //                let Address = self.placemark.subThoroughfare! + " " + self.placemark.thoroughfare! + " " + self.placemark.postalCode!
//                //                print("Addres \(Address)")
//                //                self.strCurrentLocation = currentLat + ", " + currentLong + ", " + Address
//                //Address;
//            }
//            else {
//                print("Your \(error.debugDescription)")
//            }
//        })
    }
    
    // MARK: - Firebase
    func loadAllUsersFromFirebase(){
        var arr_temp: [User] = []
        
        FirebaseModule.shareInstance.getAllUsers()
            { (response: NSArray?, error: Error?) in
                if (error == nil){
                    for user_in in response!{
                        let user: User = User()
                        let dict = user_in as! NSDictionary
                        user.initUserDataWithDictionary(value: dict)
                        arr_temp.append(user)
                    }
                    appDelegate.array_All_Users = arr_temp
                    self.loadFollowingsFromFirebase()
                    
                }else{
                    COMMON.methodForAlert(titleString: kAppName, messageString: (error?.localizedDescription)!, OKButton: kOkButton, CancelButton: "", viewController: self)
                }
        }
    }
    
    func loadFollowingsFromFirebase(){
        var arr_temp: [Following] = []
        
        FirebaseModule.shareInstance.getAllFollowings()
            { (response: NSArray?, error: Error?) in
                if (error == nil){
                    for following_in in response!{
                        let following: Following = Following()
                        let dict = following_in as! NSDictionary
                        following.initFollowingDataWithDictionary(value: dict)
                        arr_temp.append(following)
                    }
                    appDelegate.array_All_Followings = arr_temp
                    
                    appDelegate.array_Following_Users = []
                    appDelegate.array_Follower_Users = []
                    
                    for i in (0..<appDelegate.array_All_Users.count){
                        let user: User = appDelegate.array_All_Users[i]
                        
                        //                        if (user.id == USER.id){ continue}
                        
                        for j in (0..<appDelegate.array_All_Followings.count){
                            let follow_user: Follow_User = Follow_User()
                            let following: Following = appDelegate.array_All_Followings[j]
                            
                            if (following.id == USER.id && following.following_id == user.id){
                                follow_user.id = user.id
                                follow_user.name = user.name
                                follow_user.username = user.username
                                follow_user.avatar = user.avatar
                                follow_user.motives = user.motives
                                follow_user.followers = user.followers
                                
                                appDelegate.array_Following_Users.append(follow_user)
                            }
                            
                            let follower_user: Follow_User = Follow_User()
                            if (following.following_id == USER.id && following.id == user.id){
                                follower_user.id = user.id
                                follower_user.name = user.name
                                follower_user.username = user.username
                                follower_user.avatar = user.avatar
                                follower_user.motives = user.motives
                                follower_user.followers = user.followers
                                
                                appDelegate.array_Follower_Users.append(follower_user)
                            }
                        }
                    }
                    
                    //sort
                    if (appDelegate.array_Following_Users.count > 0){
                        for i in (0..<appDelegate.array_Following_Users.count-1){
                            var user: Follow_User = appDelegate.array_Following_Users[i]
                            for j in (i..<appDelegate.array_Following_Users.count){
                                let user_compare: Follow_User = appDelegate.array_Following_Users[j]
                                
                                if (user.username.compare(user_compare.username) == .orderedAscending){
                                    
                                }else if (user.username.compare(user_compare.username) == .orderedDescending){
                                    appDelegate.array_Following_Users.remove(at: i)
                                    appDelegate.array_Following_Users.insert(user_compare, at: i)
                                    
                                    appDelegate.array_Following_Users.remove(at: j)
                                    appDelegate.array_Following_Users.insert(user, at: j)
                                    
                                    user = user_compare
                                }
                            }
                        }
                    }
                    
                    if (appDelegate.array_Follower_Users.count > 0){
                        for i in (0..<appDelegate.array_Follower_Users.count-1){
                            var user: Follow_User = appDelegate.array_Follower_Users[i]
                            for j in (i..<appDelegate.array_Follower_Users.count){
                                let user_compare: Follow_User = appDelegate.array_Follower_Users[j]
                                
                                if (user.username.compare(user_compare.username) == .orderedAscending){
                                    
                                }else if (user.username.compare(user_compare.username) == .orderedDescending){
                                    appDelegate.array_Follower_Users.remove(at: i)
                                    appDelegate.array_Follower_Users.insert(user_compare, at: i)
                                    
                                    appDelegate.array_Follower_Users.remove(at: j)
                                    appDelegate.array_Follower_Users.insert(user, at: j)
                                    
                                    user = user_compare
                                }
                            }
                        }
                    }
                    
                    self.loadLiveMotiffsFromFirebase()
                    
                }else{
                    
                    COMMON.methodForAlert(titleString: kAppName, messageString: (error?.localizedDescription)!, OKButton: kOkButton, CancelButton: "", viewController: self)
                }
        }
    }

    func loadLiveMotiffsFromFirebase(){
        var arr_temp: [Host] = []
        
        FirebaseModule.shareInstance.get_All_Motiffs_Map_Live()
            { (response: NSArray?, error: Error?) in
                if (error == nil){
                    for host_in in response!{
                        let host: Host = host_in as! Host
                        arr_temp.append(host)
                    }
                    self.array_Live_Motiffs = arr_temp
                    
                    self.getAvailableLiveMotiffs()
                }else{
                    COMMON.methodForAlert(titleString: kAppName, messageString: (error?.localizedDescription)!, OKButton: kOkButton, CancelButton: "", viewController: self)
                }
        }
    }
    
    // MARK: - User Defined functions
    func getAvailableLiveMotiffs(){
        var i: Int = 0
        
        while(i < array_Live_Motiffs.count){
            if (isValidMotiff(index: i) == true && isIn2Miles(index: i) == true){
                i = i + 1
            }else{
                array_Live_Motiffs.remove(at: i)
            }
        }
        
        // Add mappoints to Map
        let annotations = getMapAnnotations()
        mapView.addAnnotations(annotations)
    }
    
    func getMapAnnotations() -> [Station] {
        var annotations:Array = [Station]()
        for i in (0..<array_Live_Motiffs.count) {
            let host: Host = array_Live_Motiffs[i]
            let annotation = Station(latitude: Double(host.location_latitude)!, longitude: Double(host.location_longitude)!)
            
            annotation.title = host.id
            annotations.append(annotation)
        }
        return annotations
    }
    
    func isValidMotiff(index: Int) -> Bool{
        let host: Host = array_Live_Motiffs[index]
        
        if (host.share_with == "Public" && host.user_id != USER.id){
            return true
        }
        
        if (host.share_with == "Friends"){
            for i in (0..<appDelegate.array_Follower_Users.count){
                let follow_user: Follow_User = appDelegate.array_Follower_Users[i]
                
                if (host.user_id == follow_user.id){
                    return true
                }
            }
        }
        
        if (host.share_with == "Custom"){
            let share_array: [Any] = host.share_array
            
            for i in (0..<share_array.count){
                let share_user: [String: String] = share_array[i] as! [String : String]
                if (USER.id == share_user["id"]){
                    return true
                }
            }
        }
        
        return false
    }
    
    func isIn2Miles(index: Int) -> Bool{
        let host: Host = array_Live_Motiffs[index]
        
        let coordinate0 = CLLocation(latitude: current_Latitude, longitude: current_Longitude)
        let coordinate1 = CLLocation(latitude: Double(host.location_latitude)!, longitude: Double(host.location_longitude)!)
        
        let distanceInMeters = coordinate0.distance(from: coordinate1)
        
        if (distanceInMeters <= 1609.34 * 2){
            return true
        }else{
            return false
        }
    }
    
    func getUserWithUserID(id: String) -> User?{
        for i in (0..<appDelegate.array_All_Users.count){
            let user: User? = appDelegate.array_All_Users[i]
            
            if (user?.id == id){
                return user
            }
        }
        
        return nil
    }
    
    func getHostWithHostID(id: String) -> Host?{
        for i in (0..<array_Live_Motiffs.count){
            let host: Host? = array_Live_Motiffs[i]
            
            if (host?.id == id){
                return host
            }
        }
        return nil
    }
    
    func getIndexWithHostID(id: String) -> Int{
        for i in (0..<array_Live_Motiffs.count){
            let host: Host? = array_Live_Motiffs[i]
            
            if (host?.id == id){
                return i
            }
        }
        return 0
    }
    
    func isDisplayedAnnotation(title: String) -> Bool{
        let allAnnotations = self.mapView.annotations
        
        for i in (0..<allAnnotations.count){
            let annotation: MKAnnotation = allAnnotations[i]
            
            if (title == annotation.title!){
                return true
            }
        }
        return false
    }
}

class ImageLoader {
    
    var cache = NSCache<AnyObject, AnyObject>()
    
    class var sharedLoader : ImageLoader {
        struct Static {
            static let instance : ImageLoader = ImageLoader()
        }
        return Static.instance
    }
    
    func imageForUrl(urlString: String, completionHandler:@escaping (_ image: UIImage?, _ url: String) -> ()) {
        DispatchQueue.global(qos: .background).async {
            let data: NSData? = self.cache.object(forKey: urlString as AnyObject) as? NSData
            
            if let goodData = data {
                let image = UIImage(data: goodData as Data)
//                dispatch_async(dispatch_get_main_queue(), {() in
//                    completionHandler(image: image, url: urlString)
//                })
//
                DispatchQueue.main.async(execute: {() in
                    completionHandler(image, urlString)
                })
                return
            }
            
            
            let session = URLSession(configuration: .default)
            let catPictureURL = URL(string: urlString)!
            
            // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
            let downloadPicTask = session.dataTask(with: catPictureURL) { (data, response, error) in
                
                if (error != nil) {
                    completionHandler(nil, urlString)
                    return
                }
                
                if data != nil {
                    let image = UIImage(data: data!)
                    self.cache.setObject(data as AnyObject, forKey: urlString as AnyObject)
                    DispatchQueue.main.async(execute: {() in
                        completionHandler(image, urlString)
                    })
                    return
                }
            }
            
            downloadPicTask.resume()
        }
    }
}

