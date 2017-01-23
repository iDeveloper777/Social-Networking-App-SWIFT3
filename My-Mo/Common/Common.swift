//
//  Common.swift
//  My-Mo
//
//  Created by Andrei Irascu on 10/11/16.
//  Copyright © 2016 Andrei Irascu. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Common: NSObject, UIAlertViewDelegate {
    
    func methodForAlert (titleString:String, messageString:String, OKButton:String, CancelButton:String, viewController: UIViewController){
        
//        let alertView = UIAlertView()
//        
//        alertView.title = titleString
//        alertView.message = messageString
//        if (OKButton != ""){
//            alertView.addButton(withTitle: OKButton)
//        }
//        if (CancelButton != ""){
//            alertView.addButton(withTitle: CancelButton)
//        }
//        alertView.show()
        
        let alertController = UIAlertController(title: titleString, message: messageString, preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: CancelButton, style: UIAlertActionStyle.cancel) {
            (result : UIAlertAction) -> Void in
//            print("Cancel")
        }
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
//            print("OK")
        }
        
        if (CancelButton != ""){
            alertController.addAction(cancelAction)
        }
        
        alertController.addAction(okAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    func X(view: UIView) -> CGFloat{
        return view.frame.origin.x
    }
    
    func Y(view: UIView) -> CGFloat{
        return view.frame.origin.y
    }
    
    func WIDTH(view: UIView) -> CGFloat{
        return view.bounds.size.width
    }
    
    func HEIGHT(view: UIView) -> CGFloat{
        return view.bounds.size.height
    }
    
    func methodIsValidEmailAddress(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        if emailTest.evaluate(with: email) != true {
            return false
        }
        else {
            return true
        }
    }
    
    func convertTimestamp(aTimeStamp: String) -> String{
        let date = Date(timeIntervalSince1970: Double(aTimeStamp)!)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let formattedDateString = dateFormatter.string(from: date)
        return formattedDateString
    }
    
    
}

class ImageProcessing: NSObject{
    
    func makeRoundedImage(image: UIImage, radius: Float) -> UIImage {
        let imageLayer = CALayer()
        imageLayer.backgroundColor = UIColor.clear.cgColor
        imageLayer.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        imageLayer.contents = (image.cgImage! as Any)
        imageLayer.masksToBounds = true
//        imageLayer.cornerRadius = CGFloat(radius)
        imageLayer.cornerRadius = image.size.width / 2
        UIGraphicsBeginImageContext(image.size)
        imageLayer.render(in: UIGraphicsGetCurrentContext()!)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return roundedImage
    }
    
    func makeMergeImage(bottomImage: UIImage, topImage: UIImage) -> UIImage{
        let size = CGSize(width: 40, height: 54)
        UIGraphicsBeginImageContext(size)
        
        let areaSize00 = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let areaSize01 = CGRect(x: 2, y: 2, width: 36, height: 36)
        bottomImage.draw(in: areaSize00)
        topImage.draw(in: areaSize01, blendMode: .normal, alpha: 1)
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return newImage
    }

}

class Station: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var latitude: Double
    var longitude:Double
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}


class ImageViewWithGradient: UIImageView
{
    let myGradientLayer: CAGradientLayer
    
    override init(frame: CGRect)
    {
        myGradientLayer = CAGradientLayer()
        super.init(frame: frame)
        self.setup()
    }
    
    required init(coder aDecoder: NSCoder)
    {
        myGradientLayer = CAGradientLayer()
        super.init(coder: aDecoder)!
        self.setup()
    }
    
    func setup()
    {
        myGradientLayer.startPoint = CGPoint(x: 0, y: 0)
        myGradientLayer.endPoint = CGPoint(x: 1, y: 1)
        let colors: [CGColor] = [
            UIColor.clear.cgColor,
            UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor,
            UIColor(red: 1, green: 1, blue: 1, alpha: 0.5).cgColor,
            UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor,
            UIColor.clear.cgColor ]
        myGradientLayer.colors = colors
        myGradientLayer.isOpaque = false
        myGradientLayer.locations = [0.0,  0.3, 0.5, 0.7, 1.0]
        self.layer.addSublayer(myGradientLayer)
    }
    
    override func layoutSubviews()
    {
        myGradientLayer.frame = self.layer.bounds
    }
}

