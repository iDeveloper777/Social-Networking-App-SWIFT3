//
//  HomeViewController.swift
//  My-Mo
//
//  Created by iDeveloper on 11/3/16.
//  Copyright © 2016 iDeveloper. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import MediaPlayer
import AVKit
import ROThumbnailGenerator
import CoreLocation
import Firebase

class HomeViewController: UIViewController ,UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, HomeTBCellDelegate, CLLocationManagerDelegate, UIWebViewDelegate{

    @IBOutlet weak var view_Navigation: UIView!
    
    @IBOutlet weak var view_Search: UIView!
    @IBOutlet weak var txt_Search: UITextField!
    
    @IBOutlet weak var view_Guide: UIView!
    
    @IBOutlet weak var view_Table: UIView!
    @IBOutlet weak var tbl_List: UITableView!
    @IBOutlet weak var img_bg_Tableview: UIImageView!
    
    @IBOutlet weak var view_Blank: UIView!
    @IBOutlet weak var view_Swipe: UIView!
    @IBOutlet weak var scr_Media: UIScrollView!
    @IBOutlet weak var pg_Media: UIPageControl!
    @IBOutlet weak var img_UserAvatar: UIImageView!
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_Time: UILabel!

    @IBOutlet weak var img_Swipe01: UIImageView!
    @IBOutlet weak var img_Swipe02: UIImageView!
    
    @IBOutlet weak var btn_Play_Video01: UIButton!
    @IBOutlet weak var btn_Play_Video02: UIButton!
    
    @IBOutlet weak var btn_Like: UIButton!
    @IBOutlet weak var btn_Location: UIButton!
    @IBOutlet weak var btn_Share: UIButton!
    
    @IBOutlet weak var lbl_Swipe_Information: UILabel!
    
    @IBOutlet weak var view_Blank01: UIView!
    @IBOutlet weak var view_Profile: UIView!
    
    @IBOutlet weak var img_Profile_Photo: UIImageView!
    @IBOutlet weak var lbl_Profile_Name: UILabel!
    @IBOutlet weak var lbl_Profile_Username: UILabel!
    @IBOutlet weak var lbl_Profile_Location: UILabel!
    @IBOutlet weak var lbl_Profile_Followers: UILabel!
    @IBOutlet weak var lbl_Profile_Title: UILabel!
    @IBOutlet weak var lbl_Profile_Information: UILabel!
    
    
    @IBOutlet weak var view_Location: UIView!
    @IBOutlet weak var web_Location: UIWebView!
    @IBOutlet weak var btn_Location_Cancel: UIButton!
    
    
    //Local Variables
//    var loadingNotification:MBProgressHUD? = nil
    let refreshControl: UIRefreshControl = UIRefreshControl()
    var nPageIndex : Int = 0
    var nNotifications: String = "";
    var array_HomeUsers: [Motiff_User] = []
    var array_Temp_HomeUsers: [Motiff_User] = []
    
    var selected_index: Int = 0
    var current_PageIndex: Int = 0
    var refresh_Flag: Int = 0
    
    var array_Video_Images:[Int: UIImage] = [:]
    var array_Live_Motiffs: [Host] = []
    
    var locationManager: CLLocationManager!
    var str_Longitude: String = ""
    var str_Latitude: String = ""
    
    //MARK: - Life cycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        array_HomeUsers = []
        array_Temp_HomeUsers = []
        array_Video_Images = [:]
        
//        DATAKEEPER.getMotiffLikes()
        
        setLayout()
        setTapGestureInDetailImage()
        setProfileLayout()
        
//        loadMotiffDataFromServer()
        loadAllUsersFromFirebase()
        hideBadgeNumber()
        
        let notificationName = Notification.Name(kNoti_Show_Home_BadgeNumber)
        NotificationCenter.default.addObserver(self, selector: #selector(showBadgeNumber), name: notificationName, object: nil)
        
        let notificationName0 = Notification.Name(kNoti_Hide_Home_BadgeNumber)
        NotificationCenter.default.addObserver(self, selector: #selector(hideBadgeNumber), name: notificationName0, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
//        locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - setLayout
    func setLayout(){
        view_Blank.isHidden = true
        view_Blank.alpha = 0
        
        view_Location.isHidden = true
        view_Location.alpha = 0
        
        view_Swipe.frame = CGRect(x: Main_Screen_Width, y: COMMON.Y(view: view_Swipe), width: COMMON.WIDTH(view: view_Swipe), height: COMMON.HEIGHT(view: view_Swipe))
        
        
        scr_Media.frame = CGRect(x: COMMON.X(view: scr_Media), y: COMMON.Y(view: scr_Media), width: COMMON.WIDTH(view: scr_Media)/2, height: COMMON.HEIGHT(view: scr_Media))
        scr_Media.contentSize = CGSize(width: COMMON.WIDTH(view: scr_Media) * 2, height: COMMON.HEIGHT(view: scr_Media))
        img_Swipe01.frame = CGRect(x: 0, y: 0, width: COMMON.WIDTH(view: scr_Media), height: COMMON.HEIGHT(view: scr_Media))
        img_Swipe02.frame = CGRect(x: COMMON.WIDTH(view: scr_Media), y: 0, width: COMMON.WIDTH(view: scr_Media), height: COMMON.HEIGHT(view: scr_Media))
        initPage()
        
        img_UserAvatar?.layer.cornerRadius = (img_UserAvatar?.frame.size.height)! / 2
        img_UserAvatar?.layer.masksToBounds = true
        
        //Geture
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeHomeScreen))
        swipeGesture.direction = .right
        view_Swipe.addGestureRecognizer(swipeGesture)
        
        tbl_List.separatorStyle = .none
        
        refreshControl.addTarget(self, action: #selector(refreshAllDatas), for: .valueChanged)
        tbl_List.addSubview(refreshControl)
        
//        txt_Search.addTarget(self, action: #selector(beginEditingTextbox), for: .editingDidEnd)
//        txt_Search.addTarget(self, action: #selector(beginEditingTextbox), for: .editingChanged)
        
        btn_Play_Video01.center = img_Swipe01.center
        btn_Play_Video02.center = img_Swipe02.center
    }
    
    func setTapGestureInDetailImage(){
        let tapGestureRecognizer01 = UITapGestureRecognizer(target:self, action: #selector(imageTapped))
        tapGestureRecognizer01.numberOfTapsRequired = 2
        img_Swipe01.addGestureRecognizer(tapGestureRecognizer01)
        img_Swipe01.isUserInteractionEnabled = true
        
        let tapGestureRecognizer02 = UITapGestureRecognizer(target:self, action: #selector(imageTapped))
        tapGestureRecognizer02.numberOfTapsRequired = 2
        img_Swipe02.addGestureRecognizer(tapGestureRecognizer02)
        img_Swipe02.isUserInteractionEnabled = true
    }
    
    func imageTapped(gestureRecognizer: UITapGestureRecognizer) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeDetailView") as! HomeDetailViewController
        
        let selected_User: Motiff_User = array_Temp_HomeUsers[selected_index]
        let motiff: Home_Motiff = selected_User.motiffs[current_PageIndex]
        let host: Host = getHostWithHostID(id: motiff.motiff_id)!
        
        viewController.motiff = motiff
        viewController.host = host
        
//        if (array_Video_Images[motiff.motiff_id] != nil){
//            viewController.thumbnail_image = array_Video_Images[motiff.motiff_id]
//        }
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //MARK: - setProfileLayout
    func setProfileLayout(){
        view_Blank01.isHidden = true
        view_Blank01.alpha = 0
        
        view_Profile.isHidden = true
        view_Profile.alpha = 0
        
        if (COMMON.WIDTH(view: img_Profile_Photo) <= COMMON.HEIGHT(view: img_Profile_Photo)){
            img_Profile_Photo.frame = CGRect(x: COMMON.X(view: img_Profile_Photo), y: COMMON.Y(view: img_Profile_Photo), width: COMMON.WIDTH(view: img_Profile_Photo), height: COMMON.WIDTH(view: img_Profile_Photo))
        }else{
            img_Profile_Photo.frame = CGRect(x: COMMON.X(view: img_Profile_Photo), y: COMMON.Y(view: img_Profile_Photo), width: COMMON.HEIGHT(view: img_Profile_Photo), height: COMMON.HEIGHT(view: img_Profile_Photo))
        }
        
        img_Profile_Photo?.layer.cornerRadius = (img_Profile_Photo?.frame.size.height)! / 2
        img_Profile_Photo?.layer.masksToBounds = true
        img_Profile_Photo.layer.borderWidth = 1
        img_Profile_Photo.layer.borderColor = UIColor.lightGray.cgColor
        
        view_Profile?.layer.cornerRadius = 20
        view_Profile?.layer.masksToBounds = true
        view_Profile.layer.borderWidth = 1
        view_Profile.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    //MARK: - refreshAllDatas
    func refreshAllDatas(){
        refresh_Flag = 1
//        loadMotiffDataFromServer()
        loadAllUsersFromFirebase()
    }
    
    
    //MARK: - Show and Hide BadgeNumber
    func showBadgeNumber(){
        var num: Int = 0
        
        for i in (0..<array_HomeUsers.count){
            let motiff_user: Motiff_User = array_HomeUsers[i]
            
            if (motiff_user.motiffs.count == 1){
                let motiff: Home_Motiff = motiff_user.motiffs[0]
                
                if (motiff.read == 0){
                    num = num + 1
                }
            }else if (motiff_user.motiffs.count > 1){
                let motiff0: Home_Motiff = motiff_user.motiffs[0]
                let motiff1: Home_Motiff = motiff_user.motiffs[1]
                
                let nRead: Int = motiff0.read + motiff1.read
                
                if (nRead != 2){
                    num = num + 1
                }
            }
        }
        
        let tabArray = self.tabBarController?.tabBar.items as NSArray!
        let tabItem = tabArray?.object(at: 0) as! UITabBarItem
        
        if (num == 0){
            tabItem.badgeValue = nil
        }else {
            tabItem.badgeValue = " "
        }
        
        
        //Badge Position
        for badgeView in (self.tabBarController?.tabBar.subviews[1].subviews)!{
            if NSStringFromClass(badgeView.classForCoder) == "_UIBadgeView" {
                badgeView.layer.transform = CATransform3DIdentity
                badgeView.layer.transform = CATransform3DMakeTranslation(0.0, 1.8, 1.0)
            }
            
        }
    }
    
    func hideBadgeNumber(){
        let tabArray = self.tabBarController?.tabBar.items as NSArray!
        let tabItem = tabArray?.object(at: 0) as! UITabBarItem
        tabItem.badgeValue = nil
        
        //Badge Position
        for badgeView in (self.tabBarController?.tabBar.subviews[1].subviews)!{
            if NSStringFromClass(badgeView.classForCoder) == "_UIBadgeView" {
                badgeView.layer.transform = CATransform3DIdentity
                badgeView.layer.transform = CATransform3DMakeTranslation(0.0, 1.8, 1.0)
            }
            
        }
    }
    
    //MARK: - Buttons' Events
    @IBAction func click_btn_Back(_ sender: AnyObject) {
    }
    
    @IBAction func click_btn_Message(_ sender: AnyObject) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MessageView") as! MessageViewController
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func click_btn_PlayVideo01(_ sender: Any) {
        let selected_User: Motiff_User = array_HomeUsers[selected_index]
        let motiff: Home_Motiff = selected_User.motiffs[nPageIndex]
        let host: Host = getHostWithHostID(id: motiff.motiff_id)!
        
        let videoURL = URL(string: host.content_url)
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    @IBAction func click_btn_PlayVideo02(_ sender: Any) {
        let selected_User: Motiff_User = array_HomeUsers[selected_index]
        let motiff: Home_Motiff = selected_User.motiffs[nPageIndex]
        let host: Host = getHostWithHostID(id: motiff.motiff_id)!
        
        let videoURL = URL(string: host.content_url)
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    @IBAction func click_btn_Like(_ sender: Any) {
//        updateMotiffLike()
        updateMotiffLikeWithFirebase()
    }
    
    @IBAction func click_btn_Location(_ sender: Any) {
//        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
//        loadingNotification?.mode = MBProgressHUDMode.indeterminate
//        loadingNotification?.label.text = "Loading..."
        
//        showLocationView()
        
        let selected_User: Motiff_User = array_HomeUsers[selected_index]
        let motiff: Home_Motiff = selected_User.motiffs[nPageIndex]
        
        var arr_Location: [String] = []
        arr_Location = motiff.location.components(separatedBy: ",")
        
        var str_URL: String = ""
        if (str_Latitude == "" || str_Longitude == ""){
            locationManager.requestLocation()
            if (arr_Location.count == 0 || arr_Location[0] == ""){
                str_URL = "http://maps.apple.com/maps"
            }else{
                str_URL = "http://maps.apple.com/maps?daddr=" + arr_Location[0] +
                    "," + arr_Location[1]
            }
        }else{
            if (arr_Location.count == 0 || arr_Location[0] == ""){
                str_URL = "http://maps.apple.com/maps?saddr=" + str_Latitude + "," + str_Longitude
            }else{
                str_URL = "http://maps.apple.com/maps?daddr=" + arr_Location[0] +
                    "," + arr_Location[1] + "&saddr=" + str_Latitude + "," + str_Longitude
            }
        }
        
        let str_Escaped = str_URL.addingPercentEscapes(using: .utf8)
        let url = URL(string: str_Escaped!)
        let urlRequest = URLRequest(url: url!)
        web_Location.loadRequest(urlRequest)
    }
    
    @IBAction func click_btn_LocationCancel(_ sender: Any) {
        hideLocationView()
    }
    
    @IBAction func click_btn_Share(_ sender: Any) {
        let selected_User: Motiff_User = array_Temp_HomeUsers[selected_index]
        let motiff: Home_Motiff = selected_User.motiffs[nPageIndex]
        let host: Host = getHostWithHostID(id: motiff.motiff_id)!

        let textToShare: String = host.title + " " + host.Description
        let myWebsite : URL? = URL(string: "https://www.mymo.com")
        var objectsToShare: [Any] = []
        objectsToShare.append(textToShare)
        
        if (myWebsite != nil){
            objectsToShare.append(myWebsite)
        }
        
        let controller = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

        controller.excludedActivityTypes = []
        controller.popoverPresentationController?.sourceView = self.view
        
        self.present(controller, animated: true, completion: nil)
    }
    
    
    //MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.txt_Search.resignFirstResponder()
        hideProfilePage()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        refreshTableViewWithSearch()
    }
    
    @IBAction func changedEditingTextbox(_ sender: Any) {
        refreshTableViewWithSearch()
    }
    
    func refreshTableViewWithSearch() {
        array_Temp_HomeUsers = []
        
        for i in (0..<array_HomeUsers.count) {
            let homeuser: Motiff_User = array_HomeUsers[i]
            
            array_Temp_HomeUsers.append(homeuser)
        }

        if (txt_Search.text == ""){
            tbl_List.reloadData()
            return
        }
        
        var k: Int = 0
        while(k < array_Temp_HomeUsers.count){
            let homeuser: Motiff_User = array_Temp_HomeUsers[k]
            
            let name: String = homeuser.name
            let lowerString: String = name.lowercased()
            let compareLowerString: String = (txt_Search.text?.lowercased())!
            
            if (lowerString.range(of: compareLowerString) == nil){
                array_Temp_HomeUsers.remove(at: k)
            }else{
                k += 1
            }
        }
        
        tbl_List.reloadData()
    }
    
    //MARK: - UITableView delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array_Temp_HomeUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var str_Locaiton: String = ""
        
        let cell:HomeTBCell = self.tbl_List.dequeueReusableCell(withIdentifier: "cell") as! HomeTBCell
        cell.cellDelegate = self
        
        let motiff_user: Motiff_User = array_Temp_HomeUsers[indexPath.row]
        
        cell.img_Avatar.sd_setImage(with: URL(string: motiff_user.avatar), placeholderImage: UIImage(named: "Placeholder_Avatar.png"))
        cell.lbl_UserName.text = motiff_user.name
        
        if (motiff_user.motiffs.count == 1){
            let motiff: Home_Motiff = motiff_user.motiffs[0]
            
            if (motiff.read == 0){
                cell.setBadgeNumber(badgeNumber: 1)
            }else{
                cell.setBadgeNumber(badgeNumber: 0)
            }
        }else if (motiff_user.motiffs.count > 1){
            let motiff0: Home_Motiff = motiff_user.motiffs[0]
            let motiff1: Home_Motiff = motiff_user.motiffs[1]
            
            let nRead: Int = motiff0.read + motiff1.read
            
            if (nRead == 0 || nRead == 1){
                cell.setBadgeNumber(badgeNumber: 1)
            }else{
                cell.setBadgeNumber(badgeNumber: 0)
            }
        }
//        cell.setBadgeNumber(badgeNumber: motiff_user.live_motiffs)
        
        if (motiff_user.country != "0"){
            str_Locaiton = motiff_user.country + " - "
        }
        
        if (motiff_user.city != "0"){
            str_Locaiton = str_Locaiton + motiff_user.city
        }
        cell.lbl_Location.text = str_Locaiton
        
        //SwipeGesture
        cell.tag = indexPath.row
        if (motiff_user.motiffs.count != 0){
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeTableViewCell))
            swipeGesture.direction = .left
            cell.addGestureRecognizer(swipeGesture)
        }
        
        
        //TapGesture
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileTapGesture))
//        cell.img_Avatar?.addGestureRecognizer(tapGesture)
//        cell.img_Avatar?.isUserInteractionEnabled = true
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    //MARK: - Getures
    func swipeTableViewCell(sender: UISwipeGestureRecognizer) {
        pg_Media.currentPage = 0
        current_PageIndex = 0
        
        let tbCell: HomeTBCell = sender.view as! HomeTBCell
        let indexPath: IndexPath = self.tbl_List.indexPath(for: tbCell)!
        selected_index = indexPath.row
        
        let selected_User: Motiff_User = array_Temp_HomeUsers[indexPath.row]
        
        lbl_UserName.text = selected_User.name
        img_UserAvatar.sd_setImage(with: URL(string: selected_User.avatar), placeholderImage: UIImage(named: "Placeholder_Avatar.png"))
        
        let latest_motiff: Home_Motiff = selected_User.motiffs[0]
        
        if (selected_User.motiffs.count == 1){
            scr_Media.contentSize = CGSize(width: COMMON.WIDTH(view: scr_Media), height: COMMON.HEIGHT(view: scr_Media))
            
            pg_Media.numberOfPages = 1
            
            lbl_Swipe_Information.text = latest_motiff.Description
            img_Swipe01.image = nil
            
            if (latest_motiff.isVideo == 1){
                btn_Play_Video01.isHidden = false
                img_Swipe01.image = UIImage(named: "Video_PlaceHolder.png")
                
                img_Swipe01.sd_setImage(with: URL(string: latest_motiff.thumbnail), placeholderImage: UIImage(named: "Placeholder_Motiff.png"))
                
            }else{
                btn_Play_Video01.isHidden = true
                img_Swipe01.sd_setImage(with: URL(string: latest_motiff.thumbnail), placeholderImage: UIImage(named: "Placeholder_Motiff.png"))
            }
            
            
            lbl_Title.text = latest_motiff.title
            lbl_Time.text = latest_motiff.time
        }else if (selected_User.motiffs.count > 1){
            
            scr_Media.contentSize = CGSize(width: COMMON.WIDTH(view: scr_Media) * 2, height: COMMON.HEIGHT(view: scr_Media))
            pg_Media.numberOfPages = 2
            
            lbl_Swipe_Information.text = latest_motiff.Description
            img_Swipe01.image = nil
            
            if (latest_motiff.isVideo == 1){
                btn_Play_Video01.isHidden = false
                img_Swipe01.image = UIImage(named: "Video_PlaceHolder.png")
                
                img_Swipe01.sd_setImage(with: URL(string: latest_motiff.thumbnail), placeholderImage: UIImage(named: "Placeholder_Motiff.png"))
            }else{
                btn_Play_Video01.isHidden = true
                img_Swipe01.sd_setImage(with: URL(string: latest_motiff.thumbnail), placeholderImage: UIImage(named: "Placeholder_Motiff.png"))
            }
            
            lbl_Title.text = latest_motiff.title
            lbl_Time.text = latest_motiff.time
            
            let second_motiff: Home_Motiff = selected_User.motiffs[1]
            img_Swipe02.image = nil
            
            if (second_motiff.isVideo == 1){
                btn_Play_Video02.isHidden = false
                img_Swipe02.image = UIImage(named: "Video_PlaceHolder.png")
                
                img_Swipe02.sd_setImage(with: URL(string: latest_motiff.thumbnail), placeholderImage: UIImage(named: "Placeholder_Motiff.png"))

            }else{
                btn_Play_Video02.isHidden = true
                img_Swipe02.sd_setImage(with: URL(string: second_motiff.thumbnail), placeholderImage: UIImage(named: "Placeholder_Motiff.png"))
            }
            
        }
        
        //is Like?
        if (latest_motiff.like == 1){
            btn_Like.setBackgroundImage(UIImage(named: "Home_btn_Like.png"), for: .normal)
        }else{
            btn_Like.setBackgroundImage(UIImage(named: "Home_btn_Star.png"), for: .normal)
        }
        
        //Who_Can
        if (selected_User.who_can == "Nobody"){
            btn_Location.isHidden = true
        }else if (selected_User.who_can == "Friends"){
            if (selected_User.friend == "yes"){
                btn_Location.isHidden = false
            }else{
                btn_Location.isHidden = true
            }
        }else{
            btn_Location.isHidden = false
        }
        
        showSwipeView()
        
//        updateMarkAsRead(index_row: indexPath.row, num: 0)
        updateMarkAsReadWithFirebase(index_row: indexPath.row, num: 0)
    }
    
    func swipeHomeScreen(sender: UISwipeGestureRecognizer) {
//        let selected_User: Motiff_User = array_HomeUsers[selected_index]
//        var bFlag: Bool = false
//        
//        if (selected_User.motiffs.count == 1){
//            let motiff: Home_Motiff = selected_User.motiffs[0]
//            if (motiff.read == 0){
//                bFlag = true
//            }
//        }else if (selected_User.motiffs.count > 1){
//            for i in (0..<1){
//                let motiff: Home_Motiff = selected_User.motiffs[i]
//                if (motiff.read == 0){
//                    bFlag = true
//                }
//            }
//        }
//        
//        if (bFlag == false){
//            selected_User.live_motiffs = 0
//            array_HomeUsers.remove(at: selected_index)
//            array_HomeUsers.insert(selected_User, at: selected_index)
//            
//            for i in (0..<self.array_Temp_HomeUsers.count){
//                let temp_user: Motiff_User = self.array_Temp_HomeUsers[i]
//                if (temp_user.id == selected_User.id){
//                    self.array_Temp_HomeUsers.remove(at: i)
//                    self.array_Temp_HomeUsers.insert(selected_User, at: i)
//                }
//            }
//        }
//        
//        tbl_List.reloadData()
        
        hideSwipeView()
    }
    
    func initPage(){
        nPageIndex = 0
        pg_Media.currentPage = 0
    }
    
    //MARK: - Show & Hide Swipe View
    func showSwipeView(){
        initPage()
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view_Blank.isHidden = false
            self.view_Blank.alpha = 0.95
            self.view_Swipe.frame = CGRect(x: Main_Screen_Width - COMMON.WIDTH(view: self.view_Swipe), y: COMMON.Y(view: self.view_Swipe), width: COMMON.WIDTH(view: self.view_Swipe), height: COMMON.HEIGHT(view: self.view_Swipe))
        })
    }
    
    func hideSwipeView(){
        initPage()
        
        UIView.animate(withDuration: 0.5, animations: {
//            self.view_Blank.isHidden = true
            self.view_Blank.alpha = 0
            self.view_Swipe.frame = CGRect(x: Main_Screen_Width, y: COMMON.Y(view: self.view_Swipe), width: COMMON.WIDTH(view: self.view_Swipe), height: COMMON.HEIGHT(view: self.view_Swipe))
        })
    }
    
    //MARK: - HomeTBCellDelegate
    func select_ProfileImage(cell: HomeTBCell) {
        let indexPath: IndexPath = self.tbl_List.indexPath(for: cell)!
        let selected_User: Motiff_User = array_Temp_HomeUsers[indexPath.row]
        let latest_motiff: Home_Motiff = selected_User.motiffs[0]
        
        img_Profile_Photo.sd_setImage(with: URL(string: selected_User.avatar), placeholderImage: UIImage(named: "Placeholder_Avatar.png"))
        lbl_Profile_Name.text = selected_User.name
        lbl_Profile_Username.text = selected_User.username
        lbl_Profile_Location.text = selected_User.country + " / " + selected_User.city
        lbl_Profile_Followers.text = String(selected_User.followers)
        lbl_Profile_Title.text = latest_motiff.title
        lbl_Profile_Information.text = latest_motiff.Description
        
        showProfilePage()
    }
    
    //MARK: - Profile View show & Hide
    func profileTapGesture(sender: UITapGestureRecognizer){
//        selected_Profile_Index =
        showProfilePage()
    }
    
    func showProfilePage(){
        UIView.animate(withDuration: 0.3, animations: {
            self.view_Blank01.isHidden = false
            self.view_Blank01.alpha = 0.2
        })
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view_Profile.isHidden = false
            self.view_Profile.alpha = 1
        })
    }
    
    func hideProfilePage(){
        UIView.animate(withDuration: 0.3, animations: {
//            self.view_Blank01.isHidden = false
            self.view_Blank01.alpha = 0
//            self.view_Profile.isHidden = false
            self.view_Profile.alpha = 0
        })
    }

    //MARK: - Show And Hide Location View
    func showLocationView(){
        UIView.animate(withDuration: 0.3, animations: {
            self.view_Location.isHidden = false
            self.view_Location.alpha = 1
        })
    }
    
    func hideLocationView(){
        UIView.animate(withDuration: 0.3, animations: {
            self.view_Location.isHidden = false
            self.view_Location.alpha = 0
        })
    }
    
    //MARK: - UIScrollViewDelegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetX = scrollView.contentOffset.x
        
        nPageIndex = Int(contentOffsetX / COMMON.WIDTH(view: scrollView))
        pg_Media.currentPage = nPageIndex
        current_PageIndex = nPageIndex
        
        if array_HomeUsers.count == 0 {
            return
        }
        
        let selected_User: Motiff_User = array_HomeUsers[selected_index]
        
        if (selected_User.motiffs.count > 1){
            if (nPageIndex == 0){
                let latest_motiff: Home_Motiff = selected_User.motiffs[0]
                lbl_Swipe_Information.text = latest_motiff.Description
                lbl_Title.text = latest_motiff.title
                lbl_Time.text = latest_motiff.time
            }else{
                let second_motiff: Home_Motiff = selected_User.motiffs[1]
                lbl_Swipe_Information.text = second_motiff.Description
                lbl_Title.text = second_motiff.title
                lbl_Time.text = second_motiff.time
            }
            
            //is Like?
            let motiff: Home_Motiff = selected_User.motiffs[nPageIndex]
            if (motiff.like == 1){
                btn_Like.setBackgroundImage(UIImage(named: "Home_btn_Like.png"), for: .normal)
            }else{
                btn_Like.setBackgroundImage(UIImage(named: "Home_btn_Star.png"), for: .normal)
            }
        }

//        updateMarkAsRead(index_row: selected_index, num: nPageIndex)
        updateMarkAsReadWithFirebase(index_row: selected_index, num: nPageIndex)
    }
    
    //MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        COMMON.methodForAlert(titleString: "Error", messageString: "There was an error retrieving your location", OKButton: kOkButton, CancelButton: "", viewController: self)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Assigning the last object as the current location of the device
        let currentLocation = locations.last!
        str_Latitude = String(format: "%.8f", currentLocation.coordinate.latitude)
        str_Longitude = String(format: "%.8f", currentLocation.coordinate.longitude)
    }

    //MARK: - UIWebViewDelegate
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
//        self.loadingNotification?.hide(animated: true)
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
//        self.loadingNotification?.hide(animated: true)
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    
    // MARK: - Firebase
    func updateMarkAsReadWithFirebase(index_row: Int, num: Int){
        let selected_User: Motiff_User = array_Temp_HomeUsers[index_row]
        let motiff: Home_Motiff = selected_User.motiffs[num]
        let host: Host = getHostWithHostID(id: motiff.motiff_id)!
        
        if (motiff.read == 1){
            return
        }
        
        FirebaseModule.shareInstance.upload_Read(user_id: USER.id, host: host)
        {(response: String?, error: Error?) in
            
            if (error == nil && response == "success"){
                motiff.read = 1
                
                selected_User.motiffs.remove(at: num)
                selected_User.motiffs.insert(motiff, at: num)
                
                self.array_Temp_HomeUsers.remove(at: index_row)
                self.array_Temp_HomeUsers.insert(selected_User, at: index_row)
                
                for i in (0..<self.array_HomeUsers.count){
                    let temp_user: Motiff_User = self.array_HomeUsers[i]
                    if (temp_user.id == selected_User.id){
                        self.array_HomeUsers.remove(at: i)
                        self.array_HomeUsers.insert(selected_User, at: i)
                    }
                }
                
                self.tbl_List.reloadData()
            }else{
                COMMON.methodForAlert(titleString: kAppName, messageString: (error?.localizedDescription)!, OKButton: kOkButton, CancelButton: "", viewController: self)
            }
        }
    }
    
    func updateMotiffLikeWithFirebase(){
        let selected_User: Motiff_User = array_Temp_HomeUsers[selected_index]
        let motiff: Home_Motiff = selected_User.motiffs[nPageIndex]
        let host: Host = getHostWithHostID(id: motiff.motiff_id)!
        
        //is Like?
        if (motiff.like == 0){
            FirebaseModule.shareInstance.upload_Like(user: USER, host: host)
            {(response: String?, error: Error?) in
                
                if (error == nil && response == "success"){
                    motiff.like = 1
                    
                    selected_User.motiffs.remove(at: self.nPageIndex)
                    selected_User.motiffs.insert(motiff, at: self.nPageIndex)
                    
                    self.array_Temp_HomeUsers.remove(at: self.selected_index)
                    self.array_Temp_HomeUsers.insert(selected_User, at: self.selected_index)
                    
                    for i in (0..<self.array_HomeUsers.count){
                        let temp_user: Motiff_User = self.array_HomeUsers[i]
                        if (temp_user.id == selected_User.id){
                            self.array_HomeUsers.remove(at: i)
                            self.array_HomeUsers.insert(selected_User, at: i)
                        }
                    }
                    
                    self.btn_Like.setBackgroundImage(UIImage(named: "Home_btn_Like.png"), for: .normal)
                }else{
                    COMMON.methodForAlert(titleString: kAppName, messageString: (error?.localizedDescription)!, OKButton: kOkButton, CancelButton: "", viewController: self)
                }
            }
        }else{
            FirebaseModule.shareInstance.delete_Like(user: USER, host: host)
            {(response: String?, error: Error?) in
                
                if (error == nil && response == "success"){
                    motiff.like = 0
                    
                    selected_User.motiffs.remove(at: self.nPageIndex)
                    selected_User.motiffs.insert(motiff, at: self.nPageIndex)
                    
                    self.array_Temp_HomeUsers.remove(at: self.selected_index)
                    self.array_Temp_HomeUsers.insert(selected_User, at: self.selected_index)
                    
                    for i in (0..<self.array_HomeUsers.count){
                        let temp_user: Motiff_User = self.array_HomeUsers[i]
                        if (temp_user.id == selected_User.id){
                            self.array_HomeUsers.remove(at: i)
                            self.array_HomeUsers.insert(selected_User, at: i)
                        }
                    }
                    
                    self.btn_Like.setBackgroundImage(UIImage(named: "Home_btn_Star.png"), for: .normal)
                }else{
                    COMMON.methodForAlert(titleString: kAppName, messageString: (error?.localizedDescription)!, OKButton: kOkButton, CancelButton: "", viewController: self)
                }
            }

        }
    }
    
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
                    self.refresh_Flag = 0
                    self.refreshControl.endRefreshing()
                    
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
                    self.refresh_Flag = 0
                    self.refreshControl.endRefreshing()
                    
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
                    
                    self.refresh_Flag = 0
                    self.refreshControl.endRefreshing()
                }else{
                    self.refresh_Flag = 0
                    self.refreshControl.endRefreshing()
                    
                    COMMON.methodForAlert(titleString: kAppName, messageString: (error?.localizedDescription)!, OKButton: kOkButton, CancelButton: "", viewController: self)
                }
        }
    }

    // MARK: - User Defined functions
    func getAvailableLiveMotiffs(){
        var i: Int = 0
        
        while(i < array_Live_Motiffs.count){
            if (isValidMotiff(index: i) == true){
                i = i + 1
            }else{
                array_Live_Motiffs.remove(at: i)
            }
        }
        
        fetchHomeUserData()
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
    
    func fetchHomeUserData(){
        array_HomeUsers = []
        array_Temp_HomeUsers = []
        array_Video_Images = [:]
        
        for i in (0..<array_Live_Motiffs.count){
            let host: Host  = array_Live_Motiffs[i]
            let index: Int = getMotiffUserIndexWithUserID(user_id: host.user_id)
            if(index == -1){
                let motiff_user: Motiff_User = Motiff_User()
                let user: User = getUserWithUserID(id: host.user_id)!
                
                motiff_user.initUserDataWithUser(user: user)
                
                let home_motiff: Home_Motiff = Home_Motiff()
                home_motiff.initMotiffDataWithHost(host: host)
                home_motiff.read = isReadMotiff(array: host.markasread_array)
                home_motiff.like = isLikeMotiff(array: host.likes_array)
                home_motiff.likes_count = host.likes_count
                
                motiff_user.motiffs.append(home_motiff)
                array_HomeUsers.append(motiff_user)
            }else{
                let motiff_user: Motiff_User = array_HomeUsers[index]
                
                let home_motiff: Home_Motiff = Home_Motiff()
                home_motiff.initMotiffDataWithHost(host: host)
                home_motiff.read = isReadMotiff(array: host.markasread_array)
                home_motiff.like = isLikeMotiff(array: host.likes_array)
                home_motiff.likes_count = host.likes_count
                
                motiff_user.motiffs.append(home_motiff)
            }
        }
        
        if (self.array_HomeUsers.count > 0){
            self.img_bg_Tableview.isHidden = true
        }else{
            self.img_bg_Tableview.isHidden = false
        }
        
        for i in (0..<array_HomeUsers.count){
            let home_motiff: Motiff_User = array_HomeUsers[i]
            array_Temp_HomeUsers.append(home_motiff)
        }
        
        tbl_List.reloadData()
    }
    
    func getMotiffUserIndexWithUserID(user_id: String) -> Int{
        for i in (0..<array_HomeUsers.count){
            let motiff_user: Motiff_User = array_HomeUsers[i]
            if (motiff_user.id == user_id){ return i}
        }
        
        return -1
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
    
    func isReadMotiff(array: [Any]) -> Int{
        for i in (0..<array.count){
            let dic_read: [String: String] = array[i] as! [String : String]
            
            if (dic_read["id"] == USER.id){
                return 1
            }
        }
        
        return 0
    }
    
    func isLikeMotiff(array: [Any]) -> Int{
        for i in (0..<array.count){
            let like_user: Like_User = array[i] as! Like_User
            
            if (like_user.user_id == USER.id){
                return 1
            }
        }
        
        return 0
    }

    
    //MARK: - API Calls
    //MARK: - loadMotiffDataFromServer
    func loadMotiffDataFromServer(){
        if (refresh_Flag == 0){
//            loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
//            loadingNotification?.mode = MBProgressHUDMode.indeterminate
//            loadingNotification?.label.text = "Loading..."
        }
        
        let parameters = ["user_id":USER.id]
        Alamofire.request(KApi_LatestMotiffs, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil) .responseJSON { response in
            
            if (self.refresh_Flag == 0){
//                self.loadingNotification?.hide(animated: true)
            }else{
                self.refreshControl.endRefreshing()
            }
            
            switch response.result {
            case .success(_):
                let jsonObject = JSON(response.result.value!)
                let status: String = jsonObject["status"].stringValue
                if (status == "success"){
                    self.fetchHomeUsersDataFromJSON(json: jsonObject["data"])
                    
                    if (self.array_HomeUsers.count > 0){
                        self.img_bg_Tableview.isHidden = true
                    }else{
                        self.img_bg_Tableview.isHidden = false
                    }
                    
                    self.tbl_List.reloadData()
                }else{
                    COMMON.methodForAlert(titleString: kAppName, messageString: "Login Failed", OKButton: kOkButton, CancelButton: "", viewController: self)
                }
                break
            case .failure(let error):
                print(error)
                COMMON.methodForAlert(titleString: kAppName, messageString: kNetworksNotAvailvle, OKButton: kOkButton, CancelButton: "", viewController: self)
                break
            }
            
        }
    }
    
    func fetchHomeUsersDataFromJSON(json: SwiftyJSON.JSON){
        array_HomeUsers = []
        array_Temp_HomeUsers = []
        array_Video_Images = [:]
        
        for i in (0..<json.count) {
            let homeuser = Motiff_User()
            
//            homeuser.initMotiffUserDataWithJSON(json: json[i])
            array_HomeUsers.append(homeuser)
            array_Temp_HomeUsers.append(homeuser)
            
            for j in (0..<homeuser.motiffs.count){
                let motiff: Home_Motiff = homeuser.motiffs[j]
                
                if (motiff.thumbnail.contains("mov")){
//                    array_Video_Images[motiff.motiff_id] = ROThumbnail.sharedInstance.getThumbnail(URL(string: motiff.thumbnail)!)
                }
            }
        }
    }
    
    func updateMarkAsRead(index_row: Int, num: Int){
        let selected_User: Motiff_User = array_HomeUsers[index_row]
        let motiff: Home_Motiff = selected_User.motiffs[num]
        
        if (motiff.read == 1){
            return
        }
        
        let parameters = ["user_id":USER.id, "motiff_id": motiff.motiff_id] as [String : Any]
        Alamofire.request(kApi_MarkAsRead, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil) .responseJSON { response in
            
            switch response.result {
            case .success(_):
                let jsonObject = JSON(response.result.value!)
                let status: String = jsonObject["status"].stringValue
                if (status == "success"){
                    motiff.read = 1
                    
                    selected_User.motiffs.remove(at: num)
                    selected_User.motiffs.insert(motiff, at: num)
                    
                    self.array_HomeUsers.remove(at: index_row)
                    self.array_HomeUsers.insert(selected_User, at: index_row)
                    
                    for i in (0..<self.array_Temp_HomeUsers.count){
                        let temp_user: Motiff_User = self.array_Temp_HomeUsers[i]
                        if (temp_user.id == selected_User.id){
                            self.array_Temp_HomeUsers.remove(at: i)
                            self.array_Temp_HomeUsers.insert(selected_User, at: i)
                        }
                    }
                    
                    self.tbl_List.reloadData()
                }else{
                    COMMON.methodForAlert(titleString: kAppName, messageString: "MarkAsRead Failed", OKButton: kOkButton, CancelButton: "", viewController: self)
                }
                break
            case .failure(let error):
                print(error)
                COMMON.methodForAlert(titleString: kAppName, messageString: kNetworksNotAvailvle, OKButton: kOkButton, CancelButton: "", viewController: self)
                break
            }
            
        }
    }
    
    func updateMotiffLike(){
        let selected_User: Motiff_User = array_HomeUsers[selected_index]
        let motiff: Home_Motiff = selected_User.motiffs[nPageIndex]
        var parameters: [String : Any] = [:]
        
        //is Like?
        if (appDelegate.array_Motiff_Likes.contains(String(motiff.motiff_id))){ // Like
            parameters = ["user_id":USER.id, "motiff_id": motiff.motiff_id, "like_or_not":0]
            btn_Like.setBackgroundImage(UIImage(named: "Home_btn_Star.png"), for: .normal)
        }else{ //DisLike
            parameters = ["user_id":USER.id, "motiff_id": motiff.motiff_id, "like_or_not":1]
            btn_Like.setBackgroundImage(UIImage(named: "Home_btn_Like.png"), for: .normal)
        }
        
        Alamofire.request(kApi_LikeUnlikeMotiff, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil) .responseJSON { response in
            
            switch response.result {
            case .success(_):
                let jsonObject = JSON(response.result.value!)
                let status: String = jsonObject["status"].stringValue
                if (status == "success"){
                    //is Like?
                    if (appDelegate.array_Motiff_Likes.contains(String(motiff.motiff_id))){
                        var nIndex: Int = -1
                        for i in (0..<appDelegate.array_Motiff_Likes.count){
                            if (String(motiff.motiff_id) == appDelegate.array_Motiff_Likes[i]){
                                nIndex = i
                            }
                        }
                        
                        if (nIndex != -1){
                            appDelegate.array_Motiff_Likes.remove(at: nIndex)
                        }
                        
                        self.btn_Like.setBackgroundImage(UIImage(named: "Home_btn_Star.png"), for: .normal)
                    }else{
                        appDelegate.array_Motiff_Likes.append(String(motiff.motiff_id))
                        self.btn_Like.setBackgroundImage(UIImage(named: "Home_btn_Like.png"), for: .normal)
                    }
                    
                    DATAKEEPER.updateMotiffLikes(arr: appDelegate.array_Motiff_Likes)
                }else{
                    COMMON.methodForAlert(titleString: kAppName, messageString: "Like Failed", OKButton: kOkButton, CancelButton: "", viewController: self)
                }
                break
            case .failure(let error):
                print(error)
                COMMON.methodForAlert(titleString: kAppName, messageString: kNetworksNotAvailvle, OKButton: kOkButton, CancelButton: "", viewController: self)
                break
            }
            
        }
    }

}
