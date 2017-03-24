//
//  ShareHostsViewController.swift
//  My-Mo
//
//  Created by iDeveloper on 11/11/16.
//  Copyright © 2016 iDeveloper. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD

class ShareHostsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var view_Navigation: UIView!
    @IBOutlet weak var view_Table: UIView!
    @IBOutlet weak var tbl_List: UITableView!
    
    //Local Variables
//    var loadingNotification:MBProgressHUD? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        loadHostUsersFromServer()
        refreshAllDatas()
    }

    //MARK: - refreshAllDatas
    func refreshAllDatas(){
        loadSearchUsersFromFirebase()
    }

    // MARK: - Firebase
    func loadSearchUsersFromFirebase(){
//        appDelegate.array_All_Users = []
//        appDelegate.array_Following_Users = []
//        appDelegate.array_Follower_Users = []
//        appDelegate.array_All_Followings = []
//        
//        appDelegate.array_HostUsers = []
        
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
                    appDelegate.array_HostUsers = []
                    
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
                            let host_user:Host_User = Host_User()
                            if (following.following_id == USER.id && following.id == user.id){
                                follower_user.id = user.id
                                follower_user.name = user.name
                                follower_user.username = user.username
                                follower_user.avatar = user.avatar
                                follower_user.motives = user.motives
                                follower_user.followers = user.followers
                                
                                appDelegate.array_Follower_Users.append(follower_user)
                                
                                host_user.id = user.id
                                host_user.name = user.name
                                host_user.username = user.username
                                host_user.avatar = user.avatar
                                
                                appDelegate.array_HostUsers.append(host_user)
                            }
                        }
                    }
                    
                    //sort
                    if (appDelegate.array_HostUsers.count > 0){
                        for i in (0..<appDelegate.array_HostUsers.count-1){
                            var user: Host_User = appDelegate.array_HostUsers[i]
                            for j in (i..<appDelegate.array_HostUsers.count){
                                let user_compare: Host_User = appDelegate.array_HostUsers[j]
                                
                                if (user.name.lowercased().compare(user_compare.name.lowercased()) == .orderedAscending){
                                    
                                }else if (user.name.lowercased().compare(user_compare.name.lowercased()) == .orderedDescending){
                                    appDelegate.array_HostUsers.remove(at: i)
                                    appDelegate.array_HostUsers.insert(user_compare, at: i)
                                    
                                    appDelegate.array_HostUsers.remove(at: j)
                                    appDelegate.array_HostUsers.insert(user, at: j)
                                    
                                    user = user_compare
                                }
                            }
                        }
                        self.tbl_List.reloadData()
                    }
                    
                }else{
                    COMMON.methodForAlert(titleString: kAppName, messageString: (error?.localizedDescription)!, OKButton: kOkButton, CancelButton: "", viewController: self)
                }
        }
    }
    
    /*
    
    // MARK: - loadHostUsersFromServer
    func loadHostUsersFromServer(){
        if (appDelegate.array_HostUsers.count == 0){
//            loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
//            loadingNotification?.mode = MBProgressHUDMode.indeterminate
//            loadingNotification?.label.text = "Loading..."
        }
        
        let parameters = ["user_id":USER.id]
        Alamofire.request(kApi_Friends, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil) .responseJSON { response in
            
            if (appDelegate.array_HostUsers.count == 0){
//                self.loadingNotification?.hide(animated: true)
            }
            
            switch response.result {
            case .success(_):
                let jsonObject = JSON(response.result.value!)
                let status: String = jsonObject["status"].stringValue
                if (status == "success"){
                    self.fetchHostUsersFromJSON(json: jsonObject["response"])
                    
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

    func fetchHostUsersFromJSON(json: SwiftyJSON.JSON){
        appDelegate.array_HostUsers = []
        
        for i in (0..<json.count) {
            let hostUser = Host_User()
            
            hostUser.initHostUserDataWithJSON(json: json[i][0])
            appDelegate.array_HostUsers.append(hostUser)
        }
    }
    */
    
    // MARK: - Buttons' Event
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
        return appDelegate.array_HostUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:HostFriendTBCell = self.tbl_List.dequeueReusableCell(withIdentifier: "ShareHostsCell")! as! HostFriendTBCell
        
        let host_User: Host_User = appDelegate.array_HostUsers[indexPath.row]
        
        cell.img_Avatar.sd_setImage(with: URL(string: host_User.avatar), placeholderImage: UIImage(named: "Placeholder_Avatar.png"))
        cell.lbl_Name.text = host_User.name
        
        if (isCheckedUser(user_id: host_User.id)){
            cell.img_Checked.isHidden = false
        }else{
            cell.img_Checked.isHidden = true
        }
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell: HostFriendTBCell = tableView.cellForRow(at: indexPath) as! HostFriendTBCell
        
        let host_User: Host_User = appDelegate.array_HostUsers[indexPath.row]
        
        if (isCheckedUser(user_id: host_User.id)){
            cell.img_Checked.isHidden = true
            
            let index: Int = appDelegate.array_Host_Friends.index(of: host_User.id)!
            appDelegate.array_Host_Friends.remove(at: index)
        }else{
            cell.img_Checked.isHidden = false
            appDelegate.array_Host_Friends.append(host_User.id)
        }
    }

    func isCheckedUser(user_id: String) -> Bool{
        var bFlag: Bool = false
        for i in (0..<appDelegate.array_Host_Friends.count){
            if (appDelegate.array_Host_Friends[i] == user_id){
                bFlag = true
            }
        }
        
        return bFlag
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
