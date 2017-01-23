//
//  SearchMapViewController.swift
//  My-Mo
//
//  Created by iDeveloper on 11/14/16.
//  Copyright © 2016 iDeveloper. All rights reserved.
//

import UIKit
import MapKit

class SearchMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    @IBOutlet weak var view_Title: UIView!
    @IBOutlet weak var view_Gradient: UIView!
    @IBOutlet weak var img_Gradient: UIImageView!
    
    @IBOutlet weak var img_Avatar: UIImageView!

    @IBOutlet weak var view_Map: UIView!
    @IBOutlet weak var mapView: MKMapView!
    
    var objLocationManager: CLLocationManager = CLLocationManager()
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var latitudes: [Double] = [51.497970, 51.498033, 51.494356]
    var longitudes: [Double] = [-0.101727, -0.107269, -0.104549]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setLayout()
        setGradientLayout()
        setMapLayout()
        initLocations()
    }
    
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
//        objLocationManager.startUpdatingLocation()
        
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
        
        mapView.setRegion(region, animated: true)

        let annotations = getMapAnnotations()
        // Add mappoints to Map
        mapView.addAnnotations(annotations)
    }
    
    func getMapAnnotations() -> [Station] {
        var annotations:Array = [Station]()
        for i in (0..<latitudes.count) {
            let annotation = Station(latitude: latitudes[i], longitude: longitudes[i])
            annotation.title = "User"
            annotations.append(annotation)
        }
        return annotations

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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations[0]
        latitude = newLocation.coordinate.latitude
        longitude = newLocation.coordinate.longitude
        objLocationManager.stopUpdatingLocation()
//        self.loadMapView()

    }

    func mapViewDidFailLoadingMap(_ mapView: MKMapView, withError error: Error) {
        objLocationManager.stopUpdatingLocation()
    }
    
    func loadMapView(){
        var objCoor2D = CLLocationCoordinate2D()
        objCoor2D.latitude = latitude
        objCoor2D.longitude = longitude
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
        
        //Try to get an unused annotation, similar to uitableviewcells
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: parkingAnnotationIdentifier)
        //If one isn't available, create a new one
        if (annotationView == nil) {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: parkingAnnotationIdentifier)
            annotationView?.image = UIImage(named: "Search_img_Annotation.png")!
            
        }
        
        
        let bottomImage = UIImage(named: "Search_img_Annotation.png")
        let topImage = IMAGEPROCESSING.makeRoundedImage(image: UIImage(named: "Search_img_Sample01.png")!, radius: 20)
        let newImage:UIImage = IMAGEPROCESSING.makeMergeImage(bottomImage: bottomImage!, topImage: topImage)

        annotationView?.image = newImage

        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

