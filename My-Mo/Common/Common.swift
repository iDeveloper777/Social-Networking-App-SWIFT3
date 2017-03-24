//
//  Common.swift
//  My-Mo
//
//  Created by iDeveloper on 10/11/16.
//  Copyright © 2016 iDeveloper. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import ImageIO
import AVFoundation

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
    
    func get_Current_UTC_Date() -> String{
        let date = Date()
        let dateformattor = DateFormatter()
        dateformattor.dateFormat = "yyyy-MM-dd"
        dateformattor.timeZone = NSTimeZone.init(abbreviation: "UTC") as TimeZone!
        return dateformattor.string(from: date)
    }
    
    func get_Current_UTC_Time() -> String{
        let date = Date()
        let dateformattor = DateFormatter()
        dateformattor.dateFormat = "HH:mm:ss"
        dateformattor.timeZone = NSTimeZone.init(abbreviation: "UTC") as TimeZone!
        return dateformattor.string(from: date)
    }
    
    func get_Current_UTC_Date_Time() -> String{
        let date = Date()
        let dateformattor = DateFormatter()
        dateformattor.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateformattor.timeZone = NSTimeZone.init(abbreviation: "UTC") as TimeZone!
        return dateformattor.string(from: date)
    }
    
    func get_Real_Current_UTC_Date_Time() -> Date{
        let date = Date()
        let dateformattor = DateFormatter()
        dateformattor.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateformattor.timeZone = NSTimeZone.init(abbreviation: "UTC") as TimeZone!
        return dateformattor.date(from: dateformattor.string(from: date))!
    }
    
    func get_Date_time_from_UTC_time(string : String) -> String {
        
        let dateformattor = DateFormatter()
        dateformattor.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateformattor.timeZone = NSTimeZone.init(abbreviation: "UTC") as TimeZone!
        let dt = string
        let dt1 = dateformattor.date(from: dt as String)
        dateformattor.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateformattor.timeZone = NSTimeZone.local
        return dateformattor.string(from: dt1!)
    }
    
    func get_Date_from_UTC_time(string : String) -> String {
        
        let dateformattor = DateFormatter()
        dateformattor.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateformattor.timeZone = NSTimeZone.init(abbreviation: "UTC") as TimeZone!
        let dt = string
        let dt1 = dateformattor.date(from: dt as String)
        dateformattor.dateFormat = "yyyy-MM-dd"
        dateformattor.timeZone = NSTimeZone.local
        return dateformattor.string(from: dt1!)
    }
    
    func get_Time_from_UTC_time(string : String) -> String {
        
        let dateformattor = DateFormatter()
        dateformattor.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateformattor.timeZone = NSTimeZone.init(abbreviation: "UTC") as TimeZone!
        let dt = string
        let dt1 = dateformattor.date(from: dt as String)
        dateformattor.dateFormat = "HH:mm:ss"
        dateformattor.timeZone = NSTimeZone.local
        return dateformattor.string(from: dt1!)
    }
    
    func get_Duration_Hours_from_UTC_Date_Time(string: String, duration: Int) -> Date{
        let current_UTC_Date: String = get_Current_UTC_Date()
        let current_UTC_Time: String = get_Current_UTC_Time()
        
        let dateformattor0 = DateFormatter()
        dateformattor0.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateformattor0.timeZone = NSTimeZone.init(abbreviation: "UTC") as TimeZone!
        let dt0 = current_UTC_Date + " " + current_UTC_Time
        let current_date = dateformattor0.date(from: dt0 as String)
        
        let dateformattor = DateFormatter()
        dateformattor.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateformattor.timeZone = NSTimeZone.init(abbreviation: "UTC") as TimeZone!
        let dt = string
        let post_date = dateformattor.date(from: dt as String)
        
        let earlyDate: Date? = Calendar.current.date(byAdding: .hour, value: duration, to: post_date!)
        
        return earlyDate!
    }

    func getLabelSize(text: NSString, size: CGSize) -> CGSize{
        let cellFont: UIFont = UIFont.systemFont(ofSize: 12)
        let constraintSize: CGSize = CGSize(width: size.width, height: CGFloat(MAXFLOAT))
        let r: CGRect = text.boundingRect(with: constraintSize, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: cellFont], context: nil)

        return CGSize(width: r.size.width, height: r.size.height)
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
    
    func imageSize(with url: NSURL) -> CGSize {
        
        var size: CGSize = .zero
        let source = CGImageSourceCreateWithURL(url, nil)!
        let options = [kCGImageSourceShouldCache as String: false]
        if let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, options as CFDictionary?)  {
            
            if let properties = properties as? [String: Any],
                let width = properties[kCGImagePropertyPixelWidth as String] as? Int,
                let height = properties[kCGImagePropertyPixelHeight as String] as? Int {
                size = CGSize(width: width, height: height)
            }
        }
        
        return size
    }
    
    func thumbnailForVideoAtURL(url: NSURL) -> UIImage? {
        
        let asset = AVAsset(url: url as URL)
        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
        assetImageGenerator.appliesPreferredTrackTransform = true
        
        var time = asset.duration
        time.value = min(time.value, 2)
        
        do {
            let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: imageRef)
        } catch {
            print("error")
            return nil
        }
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

extension Date {
    /// Returns the amount of years from another date
    func years(from_date: Date, end_date:Date) -> Int {
        return Calendar.current.dateComponents([.year], from: from_date, to: end_date).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from_date: Date, end_date:Date) -> Int {
        return Calendar.current.dateComponents([.month], from: from_date, to: end_date).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from_date: Date, end_date:Date) -> Int {
        return Calendar.current.dateComponents([.weekOfYear], from: from_date, to: end_date).weekOfYear ?? 0
    }
    /// Returns the amount of days from another date
    func days(from_date: Date, end_date:Date) -> Int {
        return Calendar.current.dateComponents([.day], from: from_date, to: end_date).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from_date: Date, end_date:Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: from_date, to: end_date).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from_date: Date, end_date:Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: from_date, to: end_date).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from_date: Date, end_date:Date) -> Int {
        return Calendar.current.dateComponents([.second], from: from_date, to: end_date).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
//        if years(from: date)   > 0 { return "\(years(from: date))y"   }
//        if months(from: date)  > 0 { return "\(months(from: date))M"  }
//        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
//        if days(from: date)    > 0 { return "\(days(from: date))d"    }
//        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
//        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
//        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}

