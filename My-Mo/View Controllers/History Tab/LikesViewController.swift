//
//  LikesViewController.swift
//  My-Mo
//
//  Created by iDeveloper on 11/14/16.
//  Copyright © 2016 iDeveloper. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import Firebase

class LikesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, LikeUserTBCellDelegate{

    @IBOutlet weak var view_Navigation: UIView!
    @IBOutlet weak var view_Table: UIView!
    @IBOutlet weak var tbl_List: UITableView!
    
    var host: Host? = Host()
//    var loadingNotification:MBProgressHUD? = nil
    let refreshControl: UIRefreshControl = UIRefreshControl()
    let petRefreshControl: PetRefreshControl = PetRefreshControl()
    
    var refresh_Flag: Int = 0
    
    var swipeArray:[Int] = []
    var workingIndexPath: IndexPath? = nil
    
    // MARK: - Life Cycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        setLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        swipeArray = []
        
        for _ in (0..<(host?.likes_count)!){
            swipeArray.append(0)
        }
        
        tbl_List.reloadData()
        loadSearchUsersFromFirebase()
    }

    func setLayout(){
        refreshControl.addTarget(self, action: #selector(refreshAllDatas), for: .valueChanged)
        tbl_List.addSubview(refreshControl)

//        petRefreshControl.tintColor = UIColor.clear
//        petRefreshControl.addTarget(self, action: #selector(refreshAllDatas), for: .valueChanged)
//        tbl_List.addSubview(petRefreshControl)
        
    }
    
    // MARK: - Buttons' Events    
    @IBAction func click_btn_Back(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    //MARK: - UITableView delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (swipeArray.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:LikeUserTBCell = self.tbl_List.dequeueReusableCell(withIdentifier: "LikesCell")! as! LikeUserTBCell
        cell.cellDelegate = self
        
        let user: Like_User = (host?.likes_array[indexPath.row])!
        
        cell.img_Avatar.sd_setImage(with: URL(string: user.avatar), placeholderImage: UIImage(named: "Placeholder_Avatar.png"))
        cell.lbl_Name.text = user.username
        cell.lbl_Date.text = COMMON.get_Date_time_from_UTC_time(string: user.date + " " + user.time)
        
        if (isFollowingUser(Id: user.user_id) == false){
            //SwipeGesture
            cell.tag = indexPath.row
            let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeftCell))
            swipeLeftGesture.direction = .left
            cell.addGestureRecognizer(swipeLeftGesture)
            
            let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeRightCell))
            swipeRightGesture.direction = .right
            cell.addGestureRecognizer(swipeRightGesture)
            
            if (swipeArray[indexPath.row] == 0){
                cell.view_Swipe.frame = cell.contentView.frame
            }else{
                cell.view_Swipe.frame.origin.x = -60
            }
        }else {
            if (swipeArray[indexPath.row] == 0){
                cell.view_Swipe.frame = cell.contentView.frame
            }else{
                cell.view_Swipe.frame.origin.x = -60
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    func pressedLikesButton(sender: UIButton){
        print(sender.tag)
    }

    //MARK: - Swipe Getures
    func swipeLeftCell(sender: UISwipeGestureRecognizer) {
        let cell = sender.view as! LikeUserTBCell
        let indexPath: IndexPath = self.tbl_List.indexPath(for: cell)!
        
        let user: Like_User = (host?.likes_array[indexPath.row])!
        if (isFollowingUser(Id: user.user_id) == true){
            return
        }
        
        if (workingIndexPath != nil){
            
            if (swipeArray[(workingIndexPath?.row)!] == 1){
                swipeArray[(workingIndexPath?.row)!] = 0
                
                
                let preCell: LikeUserTBCell? = tbl_List.cellForRow(at: workingIndexPath!) as? LikeUserTBCell
                if (preCell != nil){
                    UIView.animate(withDuration: 0.5, animations: {
                        preCell?.view_Swipe.frame = (preCell?.contentView.frame)!
                    })
                }
            }
        }
        
        workingIndexPath = indexPath
        
        swipeArray[cell.tag] = 1
        
        if (swipeArray[cell.tag] == 1){
            UIView.animate(withDuration: 0.5, animations: {
                cell.view_Swipe.frame.origin.x = -60
            })
            
        }
    }
    
    
    func swipeRightCell(sender: UISwipeGestureRecognizer) {
        let cell = sender.view as! LikeUserTBCell
        let indexPath: IndexPath = self.tbl_List.indexPath(for: cell)!
        
        workingIndexPath = indexPath
        
        swipeArray[cell.tag] = 0
        
        if (swipeArray[cell.tag] == 0){
            UIView.animate(withDuration: 0.5, animations: {
                cell.view_Swipe.frame = cell.contentView.frame
            })
        }
    }
    
    //MARK: - isFollowingUser
    func isFollowingUser(Id: String) -> Bool {
        var flag: Bool = false
        
        for i in (0..<appDelegate.array_Following_Users.count){
            let user: Follow_User = appDelegate.array_Following_Users[i]
            
            if (user.id == Id){
                flag = true
                break
            }
        }
        return flag
    }
    
    //MARK: - LikeUserTBCellDelegate
    func select_btn_Follow(cell: LikeUserTBCell) {
        let indexPath: IndexPath = self.tbl_List.indexPath(for: cell)!
        let like_user: Like_User = (host?.likes_array[indexPath.row])!
        
        FirebaseModule.shareInstance.FollowingUser(id: USER.id, following_id: like_user.user_id){
            (response: String?, error: Error?) in
            
            if (error == nil && response == "success"){
                let follow_user: Follow_User = Follow_User()
                
                for i in (0..<appDelegate.array_All_Users.count){
                    let user : User = appDelegate.array_All_Users[i]
                    
                    if (user.id == like_user.user_id){
                        follow_user.id = user.id
                        follow_user.name = user.name
                        follow_user.username = user.username
                        follow_user.avatar = user.avatar
                        follow_user.motives = user.motives
                        follow_user.followers = user.followers
                        
                        self.swipeArray.remove(at: indexPath.row)
                        self.swipeArray.insert(0, at: indexPath.row)
                        
                        appDelegate.array_Following_Users.append(follow_user)
                        
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
                        
                        self.tbl_List.reloadData()
                        break
                    }
                }
            }else{
                COMMON.methodForAlert(titleString: kAppName, messageString: (error?.localizedDescription)!, OKButton: kOkButton, CancelButton: "", viewController: self)
            }
        }
        
        FirebaseModule.shareInstance.IncreaseUserFollowings(id: USER.id, following_id: like_user.user_id){ (response: String?, error: Error?) in
            
            if (error == nil && response == "success"){
                
            }else{
                COMMON.methodForAlert(titleString: kAppName, messageString: (error?.localizedDescription)!, OKButton: kOkButton, CancelButton: "", viewController: self)
            }
        }

//        sendFriendRequest(index: indexPath.row)
    }
    
    //MARK: - refreshAllDatas
    func refreshAllDatas(){
        refresh_Flag = 1
//        petRefreshControl.beginRefreshing()
        
//        loadFollowingUsersFromServer()
        loadSearchUsersFromFirebase()
    }
    
    // MARK: - Firebase 
    
    func loadSearchUsersFromFirebase(){
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
                    
                    self.swipeArray = []
                    
                    if (self.host?.likes_array.count != 0){
                        let count: Int = (self.host?.likes_array.count)!
                        for _ in (0..<count){
                            self.swipeArray.append(0)
                        }
                    }
                    
                    self.tbl_List.reloadData()
                    
                    self.refresh_Flag = 0
                    //                self.petRefreshControl.endRefreshing()
                    self.refreshControl.endRefreshing()

                }else{
                    COMMON.methodForAlert(titleString: kAppName, messageString: (error?.localizedDescription)!, OKButton: kOkButton, CancelButton: "", viewController: self)
                }
        }
    }
    
    
    
    /*
    // MARK: - API Calls
    func loadLikeUsersFromServer(){
        if (host?.id == ""){
            return
        }
        
        if (refresh_Flag == 0){
//            loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
//            loadingNotification?.mode = MBProgressHUDMode.indeterminate
//            loadingNotification?.label.text = "Loading..."
        }
        
        let parameters = ["user_id": USER.id, "motiff_id": host?.id] as [String : Any]
        Alamofire.request(kApi_GetLikes, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil) .responseJSON { response in
            
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
                    self.fetchLikeUserDataFromJSON(json: jsonObject["data"])
                    
                }else{
                    self.array_Like_Users = []
                    self.swipeArray = []
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
    
    func fetchLikeUserDataFromJSON(json: SwiftyJSON.JSON){
        array_Like_Users = []
        swipeArray = []
        
        for i in (0..<json.count) {
            let like_user = Like_User()
            
            like_user.initLikeUserDataWithJSON(json: json[i])
            array_Like_Users.append(like_user)
            swipeArray.append(0)
        }
        
        tbl_List.reloadData()
    }
    
    func sendFriendRequest(index: Int){
        let user: Like_User = array_Like_Users[index]
        
        if (refresh_Flag == 0){
//            loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
//            loadingNotification?.mode = MBProgressHUDMode.indeterminate
//            loadingNotification?.label.text = "Loading..."
        }
        
        let parameters = ["user_id": USER.id, "followee": user.user_id] as [String : Any]
        Alamofire.request(KApi_JoinFriends, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil) .responseJSON { response in
            
//            self.loadingNotification?.hide(animated: true)
            
            switch response.result {
            case .success(_):
                let jsonObject = JSON(response.result.value!)
                let status: String = jsonObject["status"].stringValue
                if (status == "success"){
                    self.array_Like_Users.remove(at: index)
                    
                    self.tbl_List.reloadData()
                }else{
                    COMMON.methodForAlert(titleString: kAppName, messageString: jsonObject["message"].stringValue, OKButton: kOkButton, CancelButton: "", viewController: self)
                }
                break
            case .failure(let error):
                print(error)
                COMMON.methodForAlert(titleString: kAppName, messageString: kNetworksNotAvailvle, OKButton: kOkButton, CancelButton: "", viewController: self)
                break
            }
            
        }
        
    }
    
    func loadFollowingUsersFromServer(){

//        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
//        loadingNotification?.mode = MBProgressHUDMode.indeterminate
//        loadingNotification?.label.text = "Loading..."
        
        let parameters = ["user_id": USER.id]
        Alamofire.request(kApi_Following, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil) .responseJSON { response in
            
//            self.loadingNotification?.hide(animated: true)
            
            switch response.result {
            case .success(_):
                let jsonObject = JSON(response.result.value!)
                let status: String = jsonObject["status"].stringValue
                if (status == "success"){
                    self.fetchFollowingUserDataFromJSON(json: jsonObject["data"])
                    
                }else{
                    self.array_Following_Users = []
                    
                    //                    COMMON.methodForAlert(titleString: kAppName, messageString: "Login Failed", OKButton: kOkButton, CancelButton: "", viewController: self)
                }
                break
            case .failure(let error):
                print(error)
                COMMON.methodForAlert(titleString: kAppName, messageString: kNetworksNotAvailvle, OKButton: kOkButton, CancelButton: "", viewController: self)
                break
            }
            
            self.loadLikeUsersFromServer()
        }
    }
    
    func fetchFollowingUserDataFromJSON(json: SwiftyJSON.JSON){
        array_Following_Users = []
        
        for i in (0..<json.count) {
            let follow_user = Follow_User()
            
            follow_user.initFollowUserDataWithJSON(json: json[i])
            array_Following_Users.append(follow_user)
        }
    }
 
 */
}
