//
//  SettingViewController.swift
//  My-Mo
//
//  Created by iDeveloper on 11/8/16.
//  Copyright © 2016 iDeveloper. All rights reserved.
//



import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import CoreLocation
import Firebase

class SettingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, CropImageDelegate, SettingTBCell01Delegate, SettingTBCell02Delegate, SettingTBCell03Delegate, kDropDownListViewDelegate, UIScrollViewDelegate, CLLocationManagerDelegate{

    @IBOutlet weak var view_Navigation: UIView!
    @IBOutlet weak var view_Main: UIView!
    @IBOutlet weak var view_Avatar: UIView!
    @IBOutlet weak var img_Avatar: UIImageView!
    @IBOutlet weak var lbl_Name: UILabel!
    
    @IBOutlet weak var view_Table: UIView!
    @IBOutlet weak var tbl_List: UITableView!

    //----------
//    var loadingNotification:MBProgressHUD? = nil
    
    var workingIndexPath: IndexPath? = nil
    var strTileArray: [String] = []
    var strCaptionArray: [String] = []
    var strConversationArray: [String] = ["", "3 days", "5 days", "1 week", ""]
        
    var keyboardHeight: CGFloat = 216
    var rect_Table: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    var txtField: UITextField? = nil
    var lblCaption: UILabel? = nil
    
    var selectDropobj: DropDownListView? = nil
    var dropdownHeight: [CGFloat] = [178, 178, 265, 0, 0, 265]
    
    var str_Temp_TextField: String = ""
    
    //Location Variables
    var strCurrentLocation: String = ""
    var geocoder: CLGeocoder!
    var locationManager: CLLocationManager!
    var placemark: CLPlacemark!
    //--------
    
    //MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        initTableTitle()
        setLayout()
        loadUserData()
        setKeyboardLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        geocoder = CLGeocoder()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
        
        tbl_List.reloadData()
    }
 
    func initTableTitle(){
        strTileArray = ["USERNAME", "PHONE NUMBER", "EMAIL", "PASSWORD", "WHO CAN VIEW MY LOCATION", "WHO CAN SEND A DIRECT MESSAGE", "CLEAR CONVERSATION", "PHONEBOOK SEARCH", "CHANGE LOCATION", "HOST HISTORY", "", "", ""]
        strCaptionArray = ["Mike", "07946402921", "mymo@hotmail.com", "********", "PUBLIC", "PUBLIC", "NONE", "Allow people to find me", "England/North London", "CLEAR HOST HISTORY", "NOTIFICATIONS", "BLOCK CONTACT", ""]
    }
    
    func setLayout(){
        img_Avatar.frame = CGRect(x: (Main_Screen_Width - COMMON.WIDTH(view: img_Avatar))/2, y: COMMON.Y(view: img_Avatar), width: COMMON.WIDTH(view: img_Avatar), height: COMMON.WIDTH(view: img_Avatar))
        img_Avatar?.layer.cornerRadius = (img_Avatar?.frame.size.height)! / 2
        img_Avatar?.layer.masksToBounds = true
        img_Avatar?.layer.borderWidth = 0.5
        img_Avatar?.layer.borderColor = UIColor.gray.cgColor
        
        rect_Table = tbl_List.frame
    }
    
    func loadUserData(){
        if (USER.avatar_image !=  nil){
            img_Avatar.image = UIImage(data: USER.avatar_image as! Data, scale: 1.0)
        }else{
            img_Avatar.sd_setImage(with: URL(string: USER.avatar), placeholderImage: UIImage(named: "Placeholder_Avatar.png"))
            
            while(img_Avatar.image == nil){
                
            }
        }

        lbl_Name.text = USER.username
    }
    
    func setKeyboardLayout(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Buttons' Events
    @IBAction func click_btn_Back(_ sender: AnyObject) {
        hideKeyboard()
        _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func click_btn_LOGOUT(_ sender: AnyObject) {
        hideKeyboard()
        
        DATAKEEPER.updateUserName(username: "")
        DATAKEEPER.updatePassword(password: "")
        DATAKEEPER.updateLogined(logined: "no")
        
        appDelegate.array_Host_Friends = []
        appDelegate.array_HostUsers = []
        appDelegate.array_BlockUsers = []
        appDelegate.array_Hosts = []
        appDelegate.array_Motiff_Likes = []
        appDelegate.array_Following_Users = []
        appDelegate.array_Follower_Users = []
        appDelegate.array_Search_Users = []
        appDelegate.array_All_Users = []
        appDelegate.array_All_Followings = []
        appDelegate.latest_Host = nil
        
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "LogInView") as! LogInViewController
            viewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewController, animated: true)
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
            
        
//        let navi = self.navigationController! as UINavigationController
//        _ = navi.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func click_btn_Terms(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "InformationView") as! InformationViewController
        viewController.strTitle = "TERMS OF SERVICES"
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func click_btn_Policy(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "InformationView") as! InformationViewController
        viewController.strTitle = "PRIVACY POLICY"
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func click_btn_Support(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "InformationView") as! InformationViewController
        viewController.strTitle = "SUPPORT"
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    @IBAction func click_btn_Contact(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "InformationView") as! InformationViewController
        viewController.strTitle = "CONTACT"
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func click_btn_Avatar(_ sender: AnyObject) {
        hideKeyboard()
        showCameraMenu()
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
        picker.delegate = self

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
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        picker.dismiss(animated: true, completion: nil)
        
        let imageCrop = ImageCropViewController()
        imageCrop.delegate = self
        imageCrop.image = image
        imageCrop.present(animated: true)
        
    }
    
    func imageCropFinished(_ image: UIImage!) {
        img_Avatar.image = image
        updateProfilePicture(image: image)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func updateProfilePicture(image: UIImage) {
        let imageData:Data = UIImageJPEGRepresentation(image, 0.3)!
        let base64: String = imageData.base64EncodedString(options: .lineLength64Characters)
        
//        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
//        loadingNotification?.mode = MBProgressHUDMode.indeterminate
//        loadingNotification?.label.text = "Sending..."
        
        let parameters = ["user_id":USER.id, "ext":"jpeg", "avatar":base64] as [String : Any]
        Alamofire.request(kApi_UpdateProfilePic, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil) .responseJSON { response in
            
//            self.loadingNotification?.hide(animated: true)
            
            switch response.result {
            case .success(_):
                let jsonObject = JSON(response.result.value!)
                let status: String = jsonObject["status"].stringValue
                if (status == "success"){
                    let imageData: NSData = UIImagePNGRepresentation(self.img_Avatar.image!)! as NSData
                    
                    USER.avatar_image = imageData
                    USER.updateUserDataWithUserDefault()
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
    
    //MARK: - UITableView delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 12){
            return 85
        }else if (indexPath.row == 13){
            return 45
        }else{
            return 70
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 14
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tbl_List.dequeueReusableCell(withIdentifier: "cell01")! as UITableViewCell
        
        if (indexPath.row < 4){
            let cell01:SettingTBCell01 = self.tbl_List.dequeueReusableCell(withIdentifier: "cell01") as! SettingTBCell01
            
            cell01.lbl_Title?.text = strTileArray[indexPath.row]
            cell01.cellDelegate = self
            
            if (indexPath.row == 0){
                cell01.txt_Caption?.text = USER.name
                cell01.nType = "name"
            }else if (indexPath.row == 1){
                cell01.txt_Caption?.text = USER.mobile
                cell01.nType = "mobile"
            }else if (indexPath.row == 2){
                cell01.txt_Caption?.text = USER.email
                cell01.txt_Caption.keyboardType = .emailAddress
                cell01.nType = "email"
            }else if (indexPath.row == 3){
                cell01.txt_Caption?.text = USER.password
                cell01.txt_Caption.isSecureTextEntry = true
                cell01.nType = "password"
            }
            
            return cell01

        }else if (indexPath.row >= 4 && indexPath.row < 10 && indexPath.row != 7){
            let cell02:SettingTBCell02 = self.tbl_List.dequeueReusableCell(withIdentifier: "cell02") as! SettingTBCell02
            
            cell02.lbl_Title?.text = strTileArray[indexPath.row]
            cell02.cellDelegate = self
            
            if (indexPath.row == 4){
                cell02.lbl_Caption?.text = USER.who_can
            }else if (indexPath.row == 5){
                cell02.lbl_Caption?.text = USER.who_can_send_dm
            }else if (indexPath.row == 6){
                if (USER.clear_text_conversation == ""){
                    cell02.lbl_Caption?.text = kSettingClearConversation[0]
                }else{
                    cell02.lbl_Caption?.text = USER.clear_text_conversation
                }
            }else if (indexPath.row == 8){
                cell02.lbl_Caption?.text = USER.country + "/" + USER.city
            }else if (indexPath.row == 9){
                cell02.lbl_Caption?.text = kSettingClearHostHistory[USER.host_history]
            }
            
            return cell02
        }else if (indexPath.row == 10 || indexPath.row == 7){
            let cell03:SettingTBCell03 = self.tbl_List.dequeueReusableCell(withIdentifier: "cell03") as! SettingTBCell03
            
            cell03.lbl_Title?.text = strTileArray[indexPath.row]
            cell03.lbl_Caption?.text = strCaptionArray[indexPath.row]
            cell03.cellDelegate = self
            
            if (indexPath.row == 7){
                if (USER.allow_friend_to_search == 0){
                    cell03.sw_Selector?.setOn(false, animated: true)
                }else{
                    cell03.sw_Selector?.setOn(true, animated: true)
                }
            }else{
                if (USER.notification == 0){
                    cell03.sw_Selector?.setOn(false, animated: true)
                }else{
                    cell03.sw_Selector?.setOn(true, animated: true)
                }
                
                cell03.lbl_Title?.isHidden = true
            }
            
            return cell03
            
        }else if (indexPath.row == 11){
            cell = self.tbl_List.dequeueReusableCell(withIdentifier: "cell04")! as UITableViewCell
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            let lbl_Caption = cell.viewWithTag(200) as? UILabel
            lbl_Caption?.text = strCaptionArray[indexPath.row]
            
            let lbl_Numbers = cell.viewWithTag(400) as? UILabel
            if (USER.blocked_users == 0){
                lbl_Numbers?.text = "NONE"
            }else{
                lbl_Numbers?.text = String(USER.blocked_users)
            }
            

        }else if (indexPath.row == 12){
            cell = self.tbl_List.dequeueReusableCell(withIdentifier: "cell05")! as UITableViewCell
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = UITableViewCellSelectionStyle.none

        }else{
            cell = self.tbl_List.dequeueReusableCell(withIdentifier: "cell06")! as UITableViewCell
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = UITableViewCellSelectionStyle.none

        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Block List
        if (indexPath.row == 11){
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "BlockListView") as! BlockListViewController
            
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @IBAction func click_Go_BlockContact(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "BlockListView") as! BlockListViewController
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //MARK: - SettingTBCell01Delegate
    func edit_Caption(cell: SettingTBCell01) {
        let indexPath: IndexPath = self.tbl_List.indexPath(for: cell)!
        txtField = cell.txt_Caption
        str_Temp_TextField = (txtField?.text)!
        
        if (workingIndexPath == nil){
            workingIndexPath = indexPath
        }
        
        if (workingIndexPath != indexPath){
            reloadTBCell(indexPath: workingIndexPath!)
            workingIndexPath = indexPath
        }
    }
    
    func reloadTBCell(indexPath: IndexPath){
        let indexPathArray:[IndexPath] = [workingIndexPath!]
        
        self.tbl_List.beginUpdates()
        self.tbl_List.reloadRows(at: indexPathArray, with: .none)
        self.tbl_List.endUpdates()

    }
    
    func ended_Editing_Caption(cell: SettingTBCell01) {
        let indexPath: IndexPath = self.tbl_List.indexPath(for: cell)!
        
        if (indexPath.row == 1 && cell.txt_Caption.text == ""){
            COMMON.methodForAlert(titleString: kAppName, messageString: kEnterMobile, OKButton: kOkButton, CancelButton: "", viewController: self)
        }else if (indexPath.row == 2 && cell.txt_Caption.text == ""){
            COMMON.methodForAlert(titleString: kAppName, messageString: kEnterEmail, OKButton: kOkButton, CancelButton: "", viewController: self)
        }else if (indexPath.row == 3 && cell.txt_Caption.text == ""){
            COMMON.methodForAlert(titleString: kAppName, messageString: kEnterPassword, OKButton: kOkButton, CancelButton: "", viewController: self)
        }else if (indexPath.row == 2 && !COMMON.methodIsValidEmailAddress(email: cell.txt_Caption.text!)){
            COMMON.methodForAlert(titleString: kAppName, messageString: kEnterValidEmail, OKButton: kOkButton, CancelButton: "", viewController: self)
        }else if (str_Temp_TextField == cell.txt_Caption.text){
            
        }else{
            updateProfileText(row: indexPath.row, value: cell.txt_Caption.text!)
        }
    }
    
    func updateProfileText(row: Int, value: String) {
//        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
//        loadingNotification?.mode = MBProgressHUDMode.indeterminate
//        loadingNotification?.label.text = "Sending..."
        
        var strAPI_URL:String = kApi_UpdateProfile
        
        var parameters: [String : Any] = [:]
        if (row == 0){
            parameters = ["user_id":USER.id, "update":"name", "value":value]
        }else if (row == 1){
            parameters = ["user_id":USER.id, "update":"mobile", "value":value]
        }else if (row == 2){
            parameters = ["user_id":USER.id, "update":"email", "value":value]
        }else if (row == 3){
            parameters = ["user_id":USER.id, "update":"password", "value":value]
        }else if (row == 10){
            parameters = ["user_id":USER.id, "update":"notification", "value":value]
        }else if (row == 4){
            parameters = ["user_id":USER.id, "who_can":value]
            strAPI_URL = kApi_WhoCan
        }else if (row == 5){ //who_can_send_dm
            parameters = ["user_id":USER.id, "update":"who_can_send_dm", "allow_search": USER.allow_friend_to_search, "value":value]
        }else if (row == 7){// allow_friend_to_search
            parameters = ["user_id":USER.id, "update":"who_can_send_dm", "allow_search": value, "value":USER.who_can_send_dm]
        }else if (row == 6){
            parameters = ["user_id":USER.id, "update":"clear_text_conversation", "allow_search": USER.allow_friend_to_search, "value":value]
        }else if (row  == 9){
             parameters = ["user_id":USER.id, "update":"host_history", "allow_search": USER.allow_friend_to_search, "value":value]
        }
        
        Alamofire.request(strAPI_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil) .responseJSON { response in
            
//            self.loadingNotification?.hide(animated: true)
            
            switch response.result {
            case .success(_):
                let jsonObject = JSON(response.result.value!)
                let status: String = jsonObject["status"].stringValue
                if (status == "success"){
                    if (row == 0){
                        USER.name = value
                    }else if (row == 1){
                        USER.mobile = value
                    }else if (row == 2){
                        USER.email = value
                    }else if (row == 3){
                        USER.password = value
                    }else if (row == 10){
                        USER.notification = Int(value)!
                    }else if (row == 4){
                        USER.who_can = value
                    }else if (row == 5){
                        USER.who_can_send_dm = value
                    }else if (row == 7){
                        USER.allow_friend_to_search = Int(value)!
                    }else if (row == 6){
                        USER.clear_text_conversation = value
                    }else if (row == 9){
                        USER.host_history = Int(value)!
                    }
                    
                    USER.updateUserDataWithUserDefault()
                    
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
    
    //MARK: - SettingTBCell02Delegate
    func select_Caption(cell: SettingTBCell02) {
        let indexPath: IndexPath = self.tbl_List.indexPath(for: cell)!
        
        if (workingIndexPath == nil){
            workingIndexPath = indexPath
        }
        
        if (workingIndexPath != indexPath){
            reloadTBCell(indexPath: workingIndexPath!)
            workingIndexPath = indexPath
        }
        
        lblCaption = cell.lbl_Caption
        
        if (indexPath.row > 6 && indexPath.row != 9){
            hideDorpDownMenu()
            loadCurrentLocation(cell: cell)
            return
        }
        
        let rect: CGRect = tbl_List.rectForRow(at: indexPath)
        let rect_Current: CGRect = tbl_List.convert(rect, to: tbl_List.superview)
        var point: CGPoint = CGPoint(x: rect_Current.origin.x, y: rect_Current.origin.y)
        let size: CGSize = CGSize(width: rect_Current.width, height: dropdownHeight[indexPath.row - 4])
        
        if (point.y > (COMMON.HEIGHT(view: self.view_Table) - dropdownHeight[indexPath.row - 4] - 48)){
            tbl_List.contentOffset = CGPoint(x: 0,
                                             y: rect.origin.y - COMMON.HEIGHT(view: self.view_Table) + dropdownHeight[indexPath.row - 4] + 48)
            
            point = CGPoint(x: point.x, y: COMMON.HEIGHT(view: self.view_Table) - dropdownHeight[indexPath.row - 4] - 48 + 25)
        }else{
            point = CGPoint(x: rect_Current.origin.x, y: rect_Current.origin.y + 25)
        }
        
        selectDropobj?.fadeOut()
        
        if (indexPath.row == 6){
            self.showPopUp(withTitle: "", withOption: kSettingClearConversation, xy: point, size: size, isMultiple: false)
        }else if (indexPath.row == 9){
            self.showPopUp(withTitle: "", withOption: kSettingClearHostHistory, xy: point, size: size, isMultiple: false)
        }else{
            self.showPopUp(withTitle: "", withOption: kSettingLocation, xy: point, size: size, isMultiple: false)
        }
    }
    
    func loadCurrentLocation(cell: SettingTBCell02){
        cell.lbl_Caption.text = strCurrentLocation
    }
    
    //MARK: - SettingTBCell03Delegate
    func change_Selector(cell: SettingTBCell03) {
        let indexPath: IndexPath = self.tbl_List.indexPath(for: cell)!
        hideKeyboard()
        
        if (indexPath.row == 10){
            var strValue = ""
            if (cell.sw_Selector.isOn){
                strValue = "1"
            }else{
                strValue = "0"
            }
            updateProfileText(row: indexPath.row, value: strValue)
        }else if (indexPath.row == 7){// Allow people to find me
            var strValue = ""
            if (cell.sw_Selector.isOn){
                strValue = "1"
            }else{
                strValue = "0"
            }
            updateProfileText(row: indexPath.row, value: strValue)
        }
    }
    
    //MARK: - Show and Hide Keyboard
    func keyboardWillShow(notification:NSNotification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle:CGRect = keyboardFrame.cgRectValue
        keyboardHeight = keyboardRectangle.height
        keyboardHeight = keyboardHeight - 48
        
        showKeyboard()
    }
    
    func keyboardWillHide(notification:NSNotification){
        hideKeyboard()
    }    
    
    func showKeyboard(){
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .transitionCrossDissolve, animations: {() -> Void in
            UIApplication.shared.sendAction(#selector(self.becomeFirstResponder), to: nil, from: nil, for: nil)
        
            self.tbl_List.frame = CGRect(x: self.rect_Table.origin.x,
                                         y: self.rect_Table.origin.y,
                                         width: self.rect_Table.size.width,
                                         height: self.rect_Table.size.height - self.keyboardHeight)
            
            }, completion: {(finished: Bool) -> Void in
                
        })
    }
    
    func hideKeyboard(){
        hideDorpDownMenu()
        
        if (txtField != nil){
            txtField?.resignFirstResponder()
        }
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .transitionCrossDissolve, animations: {() -> Void in
            self.tbl_List.frame = self.rect_Table
            
            UIApplication.shared.sendAction(#selector(self.resignFirstResponder), to: nil, from: nil, for: nil)
            
            }, completion: {(finished: Bool) -> Void in
                
                
        })
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hideKeyboard()
    }

    //MARK: - DropDownMenu Delegate
    func showPopUp(withTitle popupTitle: String, withOption arrOptions: [Any], xy point: CGPoint, size: CGSize, isMultiple: Bool) {
        selectDropobj = DropDownListView(title: popupTitle, options: arrOptions, xy: point, size: size, isMultiple: isMultiple)
        
        selectDropobj?.delegate = self
        selectDropobj?.show(in: self.view_Table, animated: true)
        selectDropobj?.setBackGroundDropDwon_R(255, g: 255, b: 255, alpha: 0.1)
    }
    
    func dropDownListView(_ dropdownListView: DropDownListView!, didSelectedIndex anIndex: Int) {
        if (lblCaption != nil){
            if (workingIndexPath?.row == 6 && strConversationArray[anIndex] != USER.clear_text_conversation){// clear_text_conversation
                if (anIndex == 4){
                    return
                }
                
                lblCaption?.text = kSettingClearConversation[anIndex]
                updateProfileText(row: (workingIndexPath?.row)!, value: strConversationArray[anIndex])
            }else if (workingIndexPath?.row == 9 && anIndex != USER.host_history){
                if (anIndex == 4){
                    return
                }

                lblCaption?.text = kSettingClearHostHistory[anIndex]
                
                var strValue: String = "0"
                if (anIndex == 1){
                    strValue = "3"
                }else if (anIndex == 2){
                    strValue = "5"
                }else if (anIndex == 3){
                    strValue = "7"
                }else{
                    strValue = "0"
                }
                
                updateProfileText(row: (workingIndexPath?.row)!, value: strValue)
            }else if (workingIndexPath?.row == 4 && kSettingLocation[anIndex] != USER.who_can){
                lblCaption?.text = kSettingLocation[anIndex]
                updateProfileText(row: (workingIndexPath?.row)!, value: kSettingLocation[anIndex])
            }else if (workingIndexPath?.row == 5 && kSettingLocation[anIndex] != USER.who_can_send_dm){
                lblCaption?.text = kSettingLocation[anIndex]
                updateProfileText(row: (workingIndexPath?.row)!, value: kSettingLocation[anIndex])
            }
            
        }
    }
    
    func dropDownListView(_ dropdownListView: DropDownListView!, datalist ArryData: NSMutableArray!) {
        
    }
    
    func dropDownListViewDidCancel() {
        
    }
    
    func hideDorpDownMenu(){
        if (selectDropobj != nil){
            selectDropobj?.fadeOut_inMain()
        }
    }
    
    
    
    //MARK: - UIScrollViewDelegate
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        hideKeyboard()
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
        print("curretn lat \(currentLat) long \(currentLong)")
        
        // Reverse Geocoding
        print("Resolving the Address")
        geocoder.reverseGeocodeLocation(currentLocation, completionHandler: {(placemarks, error) -> Void in
            if error == nil && (placemarks?.count)! > 0 {
                self.placemark = placemarks?.last

                let city: String = self.placemark.addressDictionary!["City"] as! String
                let country: String = self.placemark.addressDictionary!["Country"] as! String
                
                let Address = country + " / " + city
                
                print("Addres \(Address)")
                self.strCurrentLocation = Address
                //Address;
            }
            else {
                print("Your \(error.debugDescription)")
            }
        })
    }

}
