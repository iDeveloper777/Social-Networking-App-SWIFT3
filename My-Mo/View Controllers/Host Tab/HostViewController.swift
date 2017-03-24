//
//  HostViewController.swift
//  My-Mo
//
//  Created by iDeveloper on 11/5/16.
//  Copyright © 2016 iDeveloper. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import CoreLocation

import Firebase

class HostViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, CropImageDelegate, CLLocationManagerDelegate{
    
    @IBOutlet weak var view_Navigation: UIView!
    @IBOutlet weak var view_Main: UIView!
    
    @IBOutlet weak var txt_Title: UITextField!
    @IBOutlet weak var txtView_Info: UITextView!
    @IBOutlet weak var swi_MapSearch: UISwitch!
    
    @IBOutlet weak var lbl_Characters: UILabel!
    @IBOutlet weak var slider_Duration: UISlider!
    @IBOutlet weak var lbl_Duration: UILabel!
    @IBOutlet weak var img_SliderButton: UIImageView!

    @IBOutlet weak var img_animatedLogo: FLAnimatedImageView!
    
    //Local Variables
    var loadingNotification:MBProgressHUD? = nil
    var host: Host = Host()

    var preSlidingValue:Float = 0.0
    var alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
    var img_Public_Checked = UIImageView(image: UIImage(named: "Host_img_Checked.png"))
    var img_Friends_Checked = UIImageView(image: UIImage(named: "Host_img_Checked.png"))
    var img_Custom_Checked = UIImageView(image: UIImage(named: "Host_img_Checked.png"))
    
    var geocoder: CLGeocoder!
    var locationManager: CLLocationManager!
    var placemark: CLPlacemark!
    
    var nDuration: Int = 0
    
    var nShareOption: Int = 0
    var strCurrentLocation: String = ""
    var strShareWith: String = ""
    var strFewFriendsArray: String = ""
    
    var isVideo: Int = 0
    var data_Upload_Image: Data? = nil
    var data_Upload_Video: Data? = nil
    var data_Thumbnail_Image: Data? = nil
    var isCamera: Bool = false
    
    var str_Image_URL: String = ""
    var img_Thumbnail_Image: UIImage? = nil
    var str_Video_URL: String = ""
    
    //Firebase
    let storage = FIRStorage.storage()
        
    //MARK: - Life Cycle Event
    override func viewDidLoad() {
        super.viewDidLoad()
        
        host = Host()
        
        appDelegate.array_Host_Friends = []
        nDuration = 0
        
        nShareOption = 0
        strCurrentLocation = ""
        strShareWith = ""
        strFewFriendsArray = ""
        
        data_Upload_Image = nil
        data_Upload_Video = nil
        data_Thumbnail_Image = nil
        
        setLayout()
        setGesture()
        setLayoutShareMenu()
        
//        setLoadingImageViewLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        geocoder = CLGeocoder()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
    }
    
    func setLayout(){
        lbl_Duration.isHidden = true
        
        img_SliderButton.center = CGPoint(x: slider_Duration.frame.origin.x+9, y: slider_Duration.center.y)
    }

    func setLoadingImageViewLayout(){
//        let url: URL = URL(string: Bundle.main.path(forResource: "loading", ofType: "gif")!)!
        
        if let path =  Bundle.main.path(forResource: "loading", ofType: "gif") {
            if let data = NSData(contentsOfFile: path) {
                let gif = FLAnimatedImage(animatedGIFData: data as Data!)
                self.img_animatedLogo.animatedImage = gif
            }
        }
        self.img_animatedLogo.alpha = 0
    }
    
    func setGesture(){

    }
    
    func sliderTapped(sender: UITapGestureRecognizer) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Buttons' Event
    @IBAction func click_btn_Back(_ sender: AnyObject) {
    }
    
    @IBAction func click_btn_Upload(_ sender: AnyObject) {
        showCameraMenu()
    }

    @IBAction func click_btn_Share(_ sender: AnyObject) {
        self.present(alertController, animated: true, completion: nil)
    }

    @IBAction func click_btn_Launch(_ sender: AnyObject) {
        if (txt_Title.text == ""){
            COMMON.methodForAlert(titleString: kAppName, messageString: "Please Enter Title", OKButton: kOkButton, CancelButton: "", viewController: self)
            return
        }
        
        if (txtView_Info.text == ""){
            COMMON.methodForAlert(titleString: kAppName, messageString: "Please Enter Description", OKButton: kOkButton, CancelButton: "", viewController: self)
            return
        }
        
        if (nDuration == 0){
            COMMON.methodForAlert(titleString: kAppName, messageString: "Please Select Duration", OKButton: kOkButton, CancelButton: "", viewController: self)
            return
        }
        
        if (data_Upload_Video == nil && data_Upload_Image == nil){
            COMMON.methodForAlert(titleString: kAppName, messageString: "Please Select Image Or Video", OKButton: kOkButton, CancelButton: "", viewController: self)
            return
        }
        
        if (nShareOption == 0){
            COMMON.methodForAlert(titleString: kAppName, messageString: "Please Select ShareOption", OKButton: kOkButton, CancelButton: "", viewController: self)
            return
        }
        
        if (nShareOption == 3 && appDelegate.array_Host_Friends.count == 0){
            COMMON.methodForAlert(titleString: kAppName, messageString: "Please Choose Friends", OKButton: kOkButton, CancelButton: "", viewController: self)
            return
        }
        
//        uploadMotiffToServer()
        
        initHostData()
    }
    
    
    //MARK: - Slider's Event
    @IBAction func change_slid_Duration(_ sender: AnyObject) {
        let slider:UISlider = sender as! UISlider
        let value = roundf(slider.value)
        
        slider.value = value
        nDuration = Int(value)
        if (preSlidingValue == value){
            
        }else{
            preSlidingValue = value
            if (value > 0){
                lbl_Duration.isHidden = false
            }else{
                lbl_Duration.isHidden = true
            }

            lbl_Duration.text = String(Int(value)) + "hr"

            lbl_Duration.center = CGPoint(x: CGFloat(Float(slider_Duration.frame.origin.x) + (Float(slider_Duration.bounds.size.width - 18)/12*value + 6)), y: lbl_Duration.center.y)
            
            img_SliderButton.center = CGPoint(x: CGFloat(Float(slider_Duration.frame.origin.x) + (Float(slider_Duration.bounds.size.width - 18)/12 * value + 9)), y: slider_Duration.center.y)
        }
    }
    
    //MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        //        animateViewMoving(true, moveValue: 167)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        //        animateViewMoving(false, moveValue: 167)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let str_Title: String = txt_Title.text!
        
        if (str_Title.characters.count + 1 + (string.characters.count - range.length) <= 17){
            return true
        }else{
            return false
        }

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.txtView_Info.resignFirstResponder()
        self.txt_Title.resignFirstResponder()
    }

    //MARK: - UITextViewDelegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (txtView_Info.text == "Enter Text"){
            txtView_Info.text = ""
        }
        txtView_Info.becomeFirstResponder()
        txtView_Info.textColor = UIColor.black
    }
    
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if (txtView_Info.text == "Enter Text"){
            txtView_Info.text = ""
        }
        
        if (range.length == 1 && range.location == 0){
            txtView_Info.text = "Enter Text"
            txtView_Info.textColor = UIColor.lightGray
            return false
        }
        
        let str_Info: String = txtView_Info.text
        lbl_Characters.text = String(str_Info.characters.count + 1) + "/60"
        
        if (str_Info.characters.count + 1 + (text.characters.count - range.length) <= 60){
            return true
        }else{
            return false
        }
    }
    
    //MARK: - Image Processing
    func showCameraMenu(){
        let alertController = UIAlertController(title: "Import !", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
            print("Cancel")
        }
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            print("Camera")
            
            self.importFromCamera()
        }
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            print("Photo Library")
            
            self.imporFromPhotoLibrary()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibraryAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func importFromCamera(){
        if (!UIImagePickerController.isSourceTypeAvailable(.camera)){
            imporFromPhotoLibrary()
        }
        
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.videoMaximumDuration = 60.0
        picker.allowsEditing = false
        picker.delegate = self
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)!
        
        self.present(picker, animated: false, completion: nil)
    }
    
    func imporFromPhotoLibrary(){
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        
        self.present(picker, animated: false, completion: nil)
    }
    
    //MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if (String(describing: info[UIImagePickerControllerMediaType]) == "Optional(public.movie)") {
            isVideo = 1
            data_Upload_Image = nil
            data_Thumbnail_Image = nil
            
//            let str_Video_Path = info["UIImagePickerControllerMediaURL"]
            var str_Video_Data = Data()
            do{
                try str_Video_Data = Data(contentsOf: info["UIImagePickerControllerMediaURL"] as! URL)
                
                img_Thumbnail_Image = IMAGEPROCESSING.thumbnailForVideoAtURL(url: info["UIImagePickerControllerMediaURL"] as! NSURL)
                data_Thumbnail_Image = UIImageJPEGRepresentation(img_Thumbnail_Image!, 0.15)!
                
                let image: UIImage = img_Thumbnail_Image!
                host.content_width = String(describing: image.size.width)
                host.content_height = String(describing: image.size.height)
            }catch{
                abort()
            }
            
            data_Upload_Video = str_Video_Data
            picker.dismiss(animated: true, completion: nil)
            
        }else{
            
            isVideo = 0
            data_Upload_Video = nil
            
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
//                if (picker.sourceType == .camera){
//                    let imageCrop = ImageCropViewController()
//                    imageCrop.delegate = self
//                    imageCrop.image = image
//                    imageCrop.present(animated: true)
//                }else{
                    data_Upload_Image = UIImageJPEGRepresentation(image, 0.15)!
                    data_Thumbnail_Image = UIImageJPEGRepresentation(image, 0.15)!
                    
                    host.content_width = String(describing: image.size.width)
                    host.content_height = String(describing: image.size.height)
//                }
            }else{
                print("Something went wrong")
            }
            
            picker.dismiss(animated: true, completion: nil)
        }
        
        
    }
    
    func imageCropFinished(_ image: UIImage!) {
        data_Upload_Image = UIImageJPEGRepresentation(image, 0.15)!
        data_Thumbnail_Image = UIImageJPEGRepresentation(image, 0.15)!
        
        host.content_width = String(describing: image.size.width)
        host.content_height = String(describing: image.size.height)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - setLayoutShareMenu
    func setLayoutShareMenu(){
        let publicAction = UIAlertAction(title: " ", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            print("public")
        }
        
        let friendsAction = UIAlertAction(title: " ", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            print("friends")
        }
        
        let customAction = UIAlertAction(title: " ", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            print("custom")
        }
        
        //Public
        let rect = CGRect(x: 0, y: 0, width: alertController.view.bounds.size.width - 20, height: 56)
        let publicView = UIView(frame: rect)
        publicView.backgroundColor = .clear
        
        let img_Public = UIImageView(frame: CGRect(x: 20, y: 4, width: 48, height: 48))
        img_Public.image = UIImage(named: "Host_img_Public.png")
        publicView.addSubview(img_Public)
        
        img_Public_Checked.frame = CGRect(x: publicView.bounds.size.width - 46, y: 22, width: 26, height: 19)
        publicView.addSubview(img_Public_Checked)
        img_Public_Checked.isHidden = true
        
        let btn_Public = UIButton(frame: CGRect(x: 0, y: 0, width: publicView.bounds.size.width, height: publicView.bounds.size.height))
        btn_Public.setTitle("Public", for: .normal)
        btn_Public.setTitleColor(UIColor.black, for: .normal)
        btn_Public.titleLabel?.font = UIFont(name: "Helvetica", size: 20)
        btn_Public.addTarget(self, action: #selector(pressed_Public), for: .touchUpInside)
        publicView.addSubview(btn_Public)
        
        
        //Friends
        let rect01 = CGRect(x: 0, y: 58, width: alertController.view.bounds.size.width - 20, height: 56)
        let friendsView = UIView(frame: rect01)
        friendsView.backgroundColor = .clear
        
        let img_Friends = UIImageView(frame: CGRect(x: 20, y: 4, width: 48, height: 48))
        img_Friends.image = UIImage(named: "Host_img_Friends.png")
        friendsView.addSubview(img_Friends)
        
        img_Friends_Checked.frame = CGRect(x: friendsView.bounds.size.width - 46, y: 22, width: 26, height: 19)
        friendsView.addSubview(img_Friends_Checked)
        img_Friends_Checked.isHidden = true
        
        let btn_Friends = UIButton(frame: CGRect(x: 0, y: 0, width: friendsView.bounds.size.width, height: friendsView.bounds.size.height))
        btn_Friends.setTitle("Friends", for: .normal)
        btn_Friends.setTitleColor(UIColor.black, for: .normal)
        btn_Friends.titleLabel?.font = UIFont(name: "Helvetica", size: 20)
        btn_Friends.addTarget(self, action: #selector(pressed_Friends), for: .touchUpInside)
        friendsView.addSubview(btn_Friends)
        
        //Custom
        let rect02 = CGRect(x: 0, y: 118, width: alertController.view.bounds.size.width - 20, height: 56)
        let customView = UIView(frame: rect02)
        customView.backgroundColor = .clear
        
        let img_Custom = UIImageView(frame: CGRect(x: 20, y: 4, width: 48, height: 48))
        img_Custom.image = UIImage(named: "Host_img_Custom.png")
        customView.addSubview(img_Custom)
        
        img_Custom_Checked.frame = CGRect(x: friendsView.bounds.size.width - 46, y: 22, width: 26, height: 19)
        customView.addSubview(img_Custom_Checked)
        img_Custom_Checked.isHidden = true
        
        
        let btn_Custom = UIButton(frame: CGRect(x: 0, y: 0, width: customView.bounds.size.width, height: customView.bounds.size.height))
        btn_Custom.setTitle("Custom", for: .normal)
        btn_Custom.setTitleColor(UIColor.black, for: .normal)
        btn_Custom.titleLabel?.font = UIFont(name: "Helvetica", size: 20)
        btn_Custom.addTarget(self, action: #selector(pressed_Custom), for: .touchUpInside)
        customView.addSubview(btn_Custom)
        
        alertController.view.addSubview(publicView)
        alertController.view.addSubview(friendsView)
        alertController.view.addSubview(customView)
        
        alertController.addAction(publicAction)
        alertController.addAction(friendsAction)
        alertController.addAction(customAction)
    }
    
    func pressed_Public(sender: UIButton!){
        nShareOption = 1
        strShareWith = "public"
        img_Public_Checked.isHidden = false
        img_Friends_Checked.isHidden = true
        img_Custom_Checked.isHidden = true
        
        alertController.dismiss(animated: true, completion: nil)
    }
    
    func pressed_Friends(sender: UIButton!){
        nShareOption = 2
        strShareWith = "followers"
        img_Public_Checked.isHidden = true
        img_Friends_Checked.isHidden = false
        img_Custom_Checked.isHidden = true
        
        alertController.dismiss(animated: true, completion: nil)
    }
    
    func pressed_Custom(sender: UIButton!){
        nShareOption = 3
        strShareWith = "few"
        img_Public_Checked.isHidden = true
        img_Friends_Checked.isHidden = true
        img_Custom_Checked.isHidden = false
        
        alertController.dismiss(animated: true, completion: nil)
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ShareHostsView") as! ShareHostsViewController
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //MARK: - Loading View show & hide
    func showLoadingView(){
        UIView.animate(withDuration: 0.3, animations: {
            self.img_animatedLogo.alpha = 1.0
        })
    }
    
    func hideLoadingview(){
        UIView.animate(withDuration: 0.2, animations: {
            self.img_animatedLogo.alpha = 0.0
        })
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
        
        host.location_latitude = currentLat
        host.location_longitude = currentLong
        
//        host.location_latitude = "51.497970"
//        host.location_longitude = "-0.101727"
 
//        print("curretn lat \(currentLat) long \(currentLong)")
        
        // Reverse Geocoding
//        print("Resolving the Address")
        geocoder.reverseGeocodeLocation(currentLocation, completionHandler: {(placemarks, error) -> Void in
            if error == nil && (placemarks?.count)! > 0 {
                self.placemark = placemarks?.last
//                let Address = self.placemark.subThoroughfare! + " " + self.placemark.thoroughfare! + " " + self.placemark.postalCode!
//                print("Addres \(Address)")
//                self.strCurrentLocation = currentLat + ", " + currentLong + ", " + Address
                //Address;
            }
            else {
                print("Your \(error.debugDescription)")
            }
         })
    }
    
    //MARK: - init Host Data
    func initHostData(){
        host.id = USER.id + " " + COMMON.get_Current_UTC_Date_Time()
        host.user_id = USER.id
        host.title = txt_Title.text!
        host.Description = txtView_Info.text
        host.duration = nDuration
        host.share_with = kShare_With[nShareOption]
        host.creation_date = COMMON.get_Current_UTC_Date()
        host.creation_time = COMMON.get_Current_UTC_Time()
        
        if (swi_MapSearch.isOn == true) {
            host.mapsearch = 1
            
            if (host.location_latitude == "" && host.location_longitude == ""){
                COMMON.methodForAlert(titleString: "Error", messageString: "There was an error retrieving your location", OKButton: kOkButton, CancelButton: "", viewController: self)
                locationManager.requestLocation()
                return
            }
        }else{
            host.mapsearch = 0
        }
        
        initShareArray()
        
        
    }
    
    func initShareArray(){
        if (appDelegate.array_Host_Friends.count > 0){
            var arr:[Any] = []
            for i in (0..<appDelegate.array_Host_Friends.count){
                let dict: [String : String] = ["id": appDelegate.array_Host_Friends[i]]
                arr.append(dict)
            }
            
            host.share_array = arr
        }
        
        uploadContentToFirebase()
    }
    
    
 
    //MARK: - Firebase
    func uploadContentToFirebase(){
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification?.mode = MBProgressHUDMode.indeterminate
        loadingNotification?.mode = MBProgressHUDMode.determinateHorizontalBar
        loadingNotification?.label.text = "Uploading..."
//        showLoadingView()
        
        let storageRef = storage.reference()
        
        if (isVideo == 0){
            let riverRef = storageRef.child("motiff_images/" + host.id + ".jpg")
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpg"

            let uploadTask = riverRef.put(data_Upload_Image!, metadata: metaData) { (metadata, error) in
                guard let metadata = metadata else {
                    self.loadingNotification?.hide(animated: true)
//                    self.hideLoadingview()
                    return
                }
                // Metadata contains file metadata such as size, content-type, and download URL.
                let downloadURL = metadata.downloadURL
                
                self.host.isVideo = self.isVideo
                self.host.content_url = (downloadURL()?.absoluteString)!
                self.host.thumbnail_url = (downloadURL()?.absoluteString)!
                
                self.UploadMotiffToFirebase()
            }
            
            _ = uploadTask.observe(.progress) { snapshot in

//                print(Float((snapshot.progress?.completedUnitCount)!) / Float((snapshot.progress?.totalUnitCount)!))
                self.loadingNotification?.progress = Float((snapshot.progress?.completedUnitCount)!) / Float((snapshot.progress?.totalUnitCount)!)
            }
        }else{
            let riverRef = storageRef.child("motiff_videos/" + host.id + ".mov")
            let metaData = FIRStorageMetadata()
            metaData.contentType = "video/mov"
            
            let uploadTask = riverRef.put(data_Upload_Video!, metadata: metaData) { (metadata, error) in
                guard let metadata = metadata else {
                    self.loadingNotification?.hide(animated: true)
//                    self.hideLoadingview()
                    return
                }
                // Metadata contains file metadata such as size, content-type, and download URL.
                let downloadURL = metadata.downloadURL
                
                self.host.isVideo = self.isVideo
                self.host.content_url = (downloadURL()?.absoluteString)!
                
                
                if (self.data_Thumbnail_Image == nil){
                    self.host.thumbnail_url = ""
                    
                    self.UploadMotiffToFirebase()
                }else{
                    let riverRef01 = storageRef.child("motiff_thumbnails/" + self.host.id + ".jpg")
                    let metaData01 = FIRStorageMetadata()
                    metaData01.contentType = "image/jpg"
                    
                    _ = riverRef01.put(self.data_Thumbnail_Image!, metadata: metaData01) { (metadata, error) in
                        guard let metadata = metadata else {
                            self.loadingNotification?.hide(animated: true)
//                            self.hideLoadingview()
                            return
                        }
                        // Metadata contains file metadata such as size, content-type, and download URL.
                        let downloadURL = metadata.downloadURL
                        self.host.thumbnail_url = (downloadURL()?.absoluteString)!
                        
                        self.UploadMotiffToFirebase()
                    }
                }
            }
            
            _ = uploadTask.observe(.progress) { snapshot in
                
//                print(Float((snapshot.progress?.completedUnitCount)!) / Float((snapshot.progress?.totalUnitCount)!))
                self.loadingNotification?.progress = Float((snapshot.progress?.completedUnitCount)!) / Float((snapshot.progress?.totalUnitCount)!)
            }

        }
    }
    
    func UploadMotiffToFirebase(){
        FirebaseModule.shareInstance.upload_Motiff(host: host){
            (response: String?, error: Error?) in
            
            if (error == nil && response == "success"){
                self.loadingNotification?.hide(animated: true)
//                self.hideLoadingview()
                
                appDelegate.latest_Host = self.host
                
                appDelegate.array_Host_Friends = []
                self.nDuration = 0
                self.nShareOption = 0
                self.strCurrentLocation = ""
                self.strShareWith = ""
                self.strFewFriendsArray = ""
                
                self.txt_Title.text = ""
                self.slider_Duration.setValue(0, animated: true)
                self.lbl_Duration.text = ""
                self.img_SliderButton.center = CGPoint(x: self.slider_Duration.frame.origin.x+9, y: self.slider_Duration.center.y)
                
                self.img_Public_Checked.isHidden = true
                self.img_Friends_Checked.isHidden = true
                self.img_Custom_Checked.isHidden = true
                self.swi_MapSearch.isOn = false
                
                self.txtView_Info.text = "Enter Text"
                self.txtView_Info.textColor = UIColor.lightGray
                
                self.data_Upload_Image = nil
                self.data_Upload_Video = nil
                self.host = Host()
                
                self.tabBarController?.selectedIndex = 4
                
                NotificationCenter.default.post(name: Notification.Name(kNoti_Refresh_Host_History), object: nil)
            }else{
                self.loadingNotification?.hide(animated: true)
//                self.hideLoadingview()
                COMMON.methodForAlert(titleString: kAppName, messageString: (error?.localizedDescription)!, OKButton: kOkButton, CancelButton: "", viewController: self)
            }
        }
    }
    
    /*
    //MARK: - API
    func uploadMotiffToServer(){
        
        //        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        //        loadingNotification?.mode = MBProgressHUDMode.indeterminate
        //        loadingNotification?.label.text = "Sending..."
        
        getFollowersToString()
        
        let strTitle: String = txt_Title.text!
        var parameters: [String : Any] = [:]
        if (isVideo == 1){
            parameters = ["user_id":USER.id,
                          "ext":"",
                          "img":"",
                          "vext":"mov",
                          "vdo":str_Upload_Video,
                          "title": strTitle,
                          "description": txtView_Info.text,
                          "location": strCurrentLocation,
                          "share_with": strShareWith,
                          "few_array": strFewFriendsArray] as [String : Any]
            
        }else{
            parameters = ["user_id":USER.id,
                          "ext":"jpeg",
                          "img":str_Upload_Image,
                          "vext":"",
                          "vdo":"",
                          "title": strTitle,
                          "description": txtView_Info.text,
                          "location": strCurrentLocation,
                          "share_with": strShareWith,
                          "few_array": strFewFriendsArray] as [String : Any]
        }
        
        Alamofire.request(kApi_HostMotive, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil) .responseJSON { response in
            
            //            self.loadingNotification?.hide(animated: true)
            
            switch response.result {
            case .success(_):
                let jsonObject = JSON(response.result.value!)
                let status: String = jsonObject["status"].stringValue
                if (status == "success"){
                    appDelegate.array_Host_Friends = []
                    self.nDuration = 0
                    self.nShareOption = 0
                    self.strCurrentLocation = ""
                    self.strShareWith = ""
                    self.strFewFriendsArray = ""
                    
                    self.txt_Title.text = ""
                    self.slider_Duration.setValue(0, animated: true)
                    self.lbl_Duration.text = ""
                    self.img_SliderButton.center = CGPoint(x: self.slider_Duration.frame.origin.x+9, y: self.slider_Duration.center.y)
                    
                    self.img_Public_Checked.isHidden = true
                    self.img_Friends_Checked.isHidden = true
                    self.img_Custom_Checked.isHidden = true
                    
                    self.txtView_Info.text = "Enter Text"
                    self.txtView_Info.textColor = UIColor.lightGray
                    
                    self.str_Upload_Image = nil
                    self.str_Upload_Video = nil
                    
                    self.tabBarController?.selectedIndex = 4
                    
                    NotificationCenter.default.post(name: Notification.Name(kNoti_Refresh_Host_History), object: nil)
                    
                }else{
                    COMMON.methodForAlert(titleString: kAppName, messageString: kErrorComment, OKButton: kOkButton, CancelButton: "", viewController: self)
                }
                break
            case .failure(let error):
                print(error)
                COMMON.methodForAlert(titleString: kAppName, messageString: kNetworksNotAvailvle, OKButton: kOkButton, CancelButton: "", viewController: self)
                break
            }
            
        }
    }
    
    func getFollowersToString(){
        if (appDelegate.array_Host_Friends.count == 0){
            return
        }
        
        strFewFriendsArray = String(appDelegate.array_Host_Friends[0])
        for i in (1..<appDelegate.array_Host_Friends.count){
            strFewFriendsArray = strFewFriendsArray + "," + String(appDelegate.array_Host_Friends[i])
        }
    }
 
    */
}
