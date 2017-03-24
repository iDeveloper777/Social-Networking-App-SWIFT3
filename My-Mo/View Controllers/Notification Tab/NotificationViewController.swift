//
//  NotificationViewController.swift
//  My-Mo
//
//  Created by iDeveloper on 11/7/16.
//  Copyright © 2016 iDeveloper. All rights reserved.
//

import UIKit

import Alamofire
import SwiftyJSON
import MBProgressHUD

class NotificationViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource, FollowTBCellDelegate{

    @IBOutlet weak var view_Navigation: UIView!
    
    @IBOutlet weak var view_Main: UIView!
    @IBOutlet weak var view_Segments: UIView!
    @IBOutlet weak var lbl_SegNumber01: UILabel!
    @IBOutlet weak var lbl_SegTitle01: UILabel!
    @IBOutlet weak var lbl_SegUnderLine01: UILabel!
    @IBOutlet weak var lbl_SegNumber02: UILabel!
    @IBOutlet weak var lbl_SegTitle02: UILabel!
    @IBOutlet weak var lbl_SegUnderLine02: UILabel!
    @IBOutlet weak var lbl_SegNumber03: UILabel!
    @IBOutlet weak var lbl_SegTitle03: UILabel!
    @IBOutlet weak var lbl_SegUnderLine03: UILabel!
    
    @IBOutlet weak var lbl_Table: UIView!
    @IBOutlet weak var tbl_List: UITableView!
    
//    var loadingNotification:MBProgressHUD? = nil
//    var loadingNotification01:MBProgressHUD? = nil
    let refreshControl: UIRefreshControl = UIRefreshControl()
//    let refreshControl: PetRefreshControl = PetRefreshControl()
    var refresh_Flag: Int = 0
    
    var nSegIndex:Int = 0
    var selected_Color = UIColor(red: 245/255, green: 116/255, blue: 44/255, alpha: 1)
    var deselected_Color = UIColor.black
    
    // MARK: - Life Cycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        setSegmentLayout(nIndex: nSegIndex)
        
        appDelegate.array_Following_Users = []
        appDelegate.array_Follower_Users = []

        setLayout()
    }

    func setLayout(){
        refreshControl.addTarget(self, action: #selector(refreshAllDatas), for: .valueChanged)
        tbl_List.addSubview(refreshControl)
        
//        refreshControl.tintColor = UIColor.clear
//        refreshControl.addTarget(self, action: #selector(refreshAllDatas), for: .valueChanged)
//        tbl_List.addSubview(refreshControl)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        if (appDelegate.array_Following_Users.count == 0){
//            tbl_List.reloadData()
//            loadFollowingUsersFromServer()
//        }
//        
//        if (appDelegate.array_Follower_Users.count == 0){
//            loadFollowerUsersFromServer()
//        }
        
        self.lbl_SegNumber01.text = String(appDelegate.array_Following_Users.count)
        self.lbl_SegNumber02.text = String(appDelegate.array_Follower_Users.count)
        
        tbl_List.reloadData()
        loadSearchUsersFromFirebase()
    }
    
    // MARK: - Buttons' Event
    @IBAction func click_btn_Back(_ sender: AnyObject) {
    }
    
    @IBAction func click_btn_Search(_ sender: AnyObject) {
    }

    @IBAction func click_btn_Segment01(_ sender: AnyObject) {
        nSegIndex = 0
        setSegmentLayout(nIndex: nSegIndex)
        tbl_List.reloadData()
    }
    
    @IBAction func click_btn_Segment02(_ sender: AnyObject) {
        nSegIndex = 1
        setSegmentLayout(nIndex: nSegIndex)
        tbl_List.reloadData()
    }
    
    @IBAction func click_btn_Segment03(_ sender: AnyObject) {
        nSegIndex = 2
        setSegmentLayout(nIndex: nSegIndex)
        tbl_List.reloadData()
    }
    
    //MARK: - UITableView delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (nSegIndex == 0 || nSegIndex == 1){
            return 60
        }else{
            if (indexPath.row == 0 || indexPath.row == 1){
                return 60
            }else if (indexPath.row == 2){
                return 180
            }else{
                return 180
            }
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (nSegIndex == 0){
            return appDelegate.array_Following_Users.count
        }else if (nSegIndex == 1){
            return appDelegate.array_Follower_Users.count
        }else{
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tbl_List.dequeueReusableCell(withIdentifier: "cell02")! as UITableViewCell
        
        if (nSegIndex == 0 || nSegIndex == 1){
            let cell01 = self.tbl_List.dequeueReusableCell(withIdentifier: "FollowTBCell")! as! FollowTBCell
            
            var follow_user: Follow_User = Follow_User()
            if (nSegIndex == 0){
                follow_user = appDelegate.array_Following_Users[indexPath.row]
            }else{
                follow_user = appDelegate.array_Follower_Users[indexPath.row]
            }
            
            cell01.img_Avatar.sd_setImage(with: URL(string: follow_user.avatar), placeholderImage: UIImage(named: "Placeholder_Avatar.png"))
            cell01.lbl_Name.text = follow_user.username
            cell01.lbl_Followers.text = String(follow_user.followers) + "  FOLLOWERS"
            cell01.cellDelegate = self
            
            return cell01
        }else{
            if (indexPath.row == 0){
                cell = self.tbl_List.dequeueReusableCell(withIdentifier: "cell02")! as UITableViewCell
                cell.backgroundColor = UIColor.clear
                cell.selectionStyle = UITableViewCellSelectionStyle.none
            }else if (indexPath.row == 1){
                cell = self.tbl_List.dequeueReusableCell(withIdentifier: "cell03")! as UITableViewCell
                cell.backgroundColor = UIColor.clear
                cell.selectionStyle = UITableViewCellSelectionStyle.none
            }else{
                cell = self.tbl_List.dequeueReusableCell(withIdentifier: "cell04")! as UITableViewCell
                cell.backgroundColor = UIColor.clear
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                
                let lbl_User = cell.viewWithTag(100) as? UILabel
                let lbl_Description = cell.viewWithTag(200) as? UILabel
                
                if (indexPath.row == 2){
                    lbl_User?.text = "Dug2Guns"
                    lbl_Description?.text = "Linked you to a motiff at 12:30"
                }else if (indexPath.row == 3){
                    lbl_User?.text = "Gavyin1Up"
                    lbl_Description?.text = "Shared you post in Twitter at 13:00"
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    //MARK: - FollowTBCellDelegate
    func select_btn_UnFollow(cell: FollowTBCell) {
        let indexPath: IndexPath = self.tbl_List.indexPath(for: cell)!
        
        if (nSegIndex == 0){
            methodUnfollowFollowingsWithFirebase(index: indexPath.row)
        }else{
//            methodUnfollowUsers(index: indexPath.row)
        }
    }
    
    // MARK: - setSegmentLayout
    func setSegmentLayout(nIndex: Int){
        if (nIndex == 0){
            lbl_SegTitle01.textColor = selected_Color
            lbl_SegNumber01.textColor = selected_Color
            lbl_SegUnderLine01.backgroundColor = selected_Color
        }else{
            lbl_SegTitle01.textColor = deselected_Color
            lbl_SegNumber01.textColor = deselected_Color
            lbl_SegUnderLine01.backgroundColor = UIColor.clear
        }
        
        if (nIndex == 1){
            lbl_SegTitle02.textColor = selected_Color
            lbl_SegNumber02.textColor = selected_Color
            lbl_SegUnderLine02.backgroundColor = selected_Color
        }else{
            lbl_SegTitle02.textColor = deselected_Color
            lbl_SegNumber02.textColor = deselected_Color
            lbl_SegUnderLine02.backgroundColor = UIColor.clear
        }
        
        if (nIndex == 2){
            lbl_SegTitle03.textColor = selected_Color
            lbl_SegNumber03.textColor = selected_Color
            lbl_SegUnderLine03.backgroundColor = selected_Color
        }else{
            lbl_SegTitle03.textColor = deselected_Color
            lbl_SegNumber03.textColor = deselected_Color
            lbl_SegUnderLine03.backgroundColor = UIColor.clear
        }
    }
    
    //MARK: - refreshAllDatas
    func refreshAllDatas(){
        refresh_Flag = 1
//        refreshControl.beginRefreshing()
        
//        if (nSegIndex == 0){
//            loadFollowingUsersFromServer()
//        }else if (nSegIndex == 1){
//            loadFollowerUsersFromServer()
//        }
        
        loadSearchUsersFromFirebase()
    }
    
    // MARK: - Firebase
    func loadSearchUsersFromFirebase(){
//        appDelegate.array_All_Users = []
//        appDelegate.array_Following_Users = []
//        appDelegate.array_Follower_Users = []
//        appDelegate.array_All_Followings = []
        
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
                    
                    self.lbl_SegNumber01.text = String(appDelegate.array_Following_Users.count)
                    self.lbl_SegNumber02.text = String(appDelegate.array_Follower_Users.count)
                    self.tbl_List.reloadData()
                    
                    self.refresh_Flag = 0
                    self.refreshControl.endRefreshing()
                    
                }else{
                    self.refresh_Flag = 0
                    self.refreshControl.endRefreshing()
                    
                    COMMON.methodForAlert(titleString: kAppName, messageString: (error?.localizedDescription)!, OKButton: kOkButton, CancelButton: "", viewController: self)
                }
        }
    }
    
    func methodUnfollowFollowingsWithFirebase(index: Int){
        let follow_user: Follow_User = appDelegate.array_Following_Users[index]
        
        FirebaseModule.shareInstance.UnFollowingUser(id: USER.id, following_id: follow_user.id){
            (response: String?, error: Error?) in
            
            if (error == nil && response == "success"){
                for i in (0..<appDelegate.array_All_Users.count){
                    let user: User = appDelegate.array_All_Users[i]
                    if (user.id == follow_user.id && user.followers > 0){
                        user.followers = user.followers - 1
                    }
                }
                
                for i in (0..<appDelegate.array_Follower_Users.count){
                    let user: Follow_User = appDelegate.array_Follower_Users[i]
                    if (user.id == follow_user.id && user.followers > 0){
                        user.followers = user.followers - 1
                    }
                }
                
                appDelegate.array_Following_Users.remove(at: index)
                self.lbl_SegNumber01.text = String(appDelegate.array_Following_Users.count)
                self.lbl_SegNumber02.text = String(appDelegate.array_Follower_Users.count)
                self.tbl_List.reloadData()
            }else{
                COMMON.methodForAlert(titleString: kAppName, messageString: (error?.localizedDescription)!, OKButton: kOkButton, CancelButton: "", viewController: self)
            }
        }
        
        FirebaseModule.shareInstance.DecreaseUserFollowings(id: USER.id, following_id: follow_user.id){ (response: String?, error: Error?) in
            
            if (error == nil && response == "success"){
                
            }else{
                COMMON.methodForAlert(titleString: kAppName, messageString: (error?.localizedDescription)!, OKButton: kOkButton, CancelButton: "", viewController: self)
            }
        }
        
        
    }
    
    // MARK: - API Calls
    func loadFollowingUsersFromServer(){
        if (refresh_Flag == 0){
//            loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
//            loadingNotification?.mode = MBProgressHUDMode.indeterminate
//            loadingNotification?.label.text = "Loading..."
        }
        
        let parameters = ["user_id": USER.id]
        Alamofire.request(kApi_Following, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil) .responseJSON { response in
            
            if (self.refresh_Flag == 0){
//                self.loadingNotification?.hide(animated: true)
            }else{
                self.refreshControl.endRefreshing()
                self.refresh_Flag = 0
            }
            
            switch response.result {
            case .success(_):
                let jsonObject = JSON(response.result.value!)
                let status: String = jsonObject["status"].stringValue
                if (status == "success"){
                    self.fetchFollowingUserDataFromJSON(json: jsonObject["data"])
                    
                }else{
                    appDelegate.array_Following_Users = []
                    self.lbl_SegNumber01.text = String(appDelegate.array_Following_Users.count)
                    self.tbl_List.reloadData()
                    
                    //                    COMMON.methodForAlert(titleString: kAppName, messageString: "Login Failed", OKButton: kOkButton, CancelButton: "", viewController: self)
                }
                break
            case .failure(let error):
                print(error)
                COMMON.methodForAlert(titleString: kAppName, messageString: kNetworksNotAvailvle, OKButton: kOkButton, CancelButton: "", viewController: self)
                break
            }
            
        }
    }
    
    func fetchFollowingUserDataFromJSON(json: SwiftyJSON.JSON){
        appDelegate.array_Following_Users = []
        
        for i in (0..<json.count) {
            let follow_user = Follow_User()
            
            follow_user.initFollowUserDataWithJSON(json: json[i])
            appDelegate.array_Following_Users.append(follow_user)
        }
        
        lbl_SegNumber01.text = String(appDelegate.array_Following_Users.count)

        if (nSegIndex == 0){
            tbl_List.reloadData()
        }
    }

    func loadFollowerUsersFromServer(){
        if (refresh_Flag == 0){
//            loadingNotification01 = MBProgressHUD.showAdded(to: self.view, animated: true)
//            loadingNotification01?.mode = MBProgressHUDMode.indeterminate
//            loadingNotification01?.label.text = "Loading..."
        }
        
        let parameters = ["user_id": USER.id]
        Alamofire.request(kApi_Followers, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil) .responseJSON { response in
            
            if (self.refresh_Flag == 0){
//                self.loadingNotification01?.hide(animated: true)
            }else{
                self.refreshControl.endRefreshing()
                self.refresh_Flag = 0
            }
            
            switch response.result {
            case .success(_):
                let jsonObject = JSON(response.result.value!)
                let status: String = jsonObject["status"].stringValue
                if (status == "success"){
                    self.fetchFollowerUserDataFromJSON(json: jsonObject["data"])
                }else{
                    appDelegate.array_Follower_Users = []
                    self.lbl_SegNumber02.text = String(appDelegate.array_Follower_Users.count)
                    self.tbl_List.reloadData()
                    
                    //                    COMMON.methodForAlert(titleString: kAppName, messageString: "Login Failed", OKButton: kOkButton, CancelButton: "", viewController: self)
                }
                break
            case .failure(let error):
                print(error)
                COMMON.methodForAlert(titleString: kAppName, messageString: kNetworksNotAvailvle, OKButton: kOkButton, CancelButton: "", viewController: self)
                break
            }
            
        }
    }
    
    func fetchFollowerUserDataFromJSON(json: SwiftyJSON.JSON){
        appDelegate.array_Follower_Users = []
        
        for i in (0..<json.count) {
            let follow_user = Follow_User()
            
            follow_user.initFollowUserDataWithJSON(json: json[i])
            appDelegate.array_Follower_Users.append(follow_user)
        }
        
        self.lbl_SegNumber02.text = String(appDelegate.array_Follower_Users.count)
        
        if (nSegIndex == 1){
            tbl_List.reloadData()
        }
    }
    
    func methodUnfollowFollowings(index: Int){
        let follow_user: Follow_User = appDelegate.array_Following_Users[index]
        
//        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
//        loadingNotification?.mode = MBProgressHUDMode.indeterminate
//        loadingNotification?.label.text = "Loading..."
        
        let parameters = ["user_id": USER.id, "followee": follow_user.id] as [String : Any]
        Alamofire.request(kApi_UnFollowFollowings, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil) .responseJSON { response in
            
//            self.loadingNotification?.hide(animated: true)
            
            switch response.result {
            case .success(_):
                let jsonObject = JSON(response.result.value!)
                let status: String = jsonObject["status"].stringValue
                if (status == "success"){
                    appDelegate.array_Following_Users.remove(at: index)
                    self.lbl_SegNumber01.text = String(appDelegate.array_Following_Users.count)
                    self.tbl_List.reloadData()
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
    
    func methodUnfollowUsers(index: Int){
        let follow_user: Follow_User = appDelegate.array_Follower_Users[index]
        
//        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
//        loadingNotification?.mode = MBProgressHUDMode.indeterminate
//        loadingNotification?.label.text = "Loading..."
        
        let parameters = ["user_id": USER.id, "followee": follow_user.id] as [String : Any]
        Alamofire.request(kApi_Unfollow, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil) .responseJSON { response in
            
//            self.loadingNotification?.hide(animated: true)
            
            switch response.result {
            case .success(_):
                let jsonObject = JSON(response.result.value!)
                let status: String = jsonObject["status"].stringValue
                if (status == "success"){
                    appDelegate.array_Follower_Users.remove(at: index)
                    self.lbl_SegNumber02.text = String(appDelegate.array_Follower_Users.count)
                    self.tbl_List.reloadData()
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
    
    
}
