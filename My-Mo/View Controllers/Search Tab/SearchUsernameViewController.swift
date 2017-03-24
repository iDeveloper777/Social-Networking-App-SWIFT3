//
//  SearchUsernameViewController.swift
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

class SearchUsernameViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, SearchUsernameTBCellDelegate{

    @IBOutlet weak var view_Navigation: UIView!
    @IBOutlet weak var view_Main: UIView!
    @IBOutlet weak var view_Search: UIView!
    @IBOutlet weak var txt_Search: UITextField!
    
    @IBOutlet weak var view_Table: UIView!
    @IBOutlet weak var tbl_List: UITableView!
    
//    var loadingNotification:MBProgressHUD? = nil
    
    let refreshControl: UIRefreshControl = UIRefreshControl()
//    let refreshControl: PetRefreshControl = PetRefreshControl()
    var refresh_Flag: Int = 0
    
    var array_Search_Users_Filter: [Follow_User] = []
    
    // MARK: - Life Cycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()

//        appDelegate.array_Search_Users = []
        array_Search_Users_Filter = []
        
        setLayout()
    }
    
    func setLayout(){
        refreshControl.addTarget(self, action: #selector(refreshAllDatas), for: .valueChanged)
        tbl_List.addSubview(refreshControl)
        
//        refreshControl.tintColor = UIColor.clear
//        refreshControl.addTarget(self, action: #selector(refreshAllDatas), for: .valueChanged)
//        tbl_List.addSubview(refreshControl)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (appDelegate.array_Search_Users.count == 0){
            tbl_List.reloadData()
            loadSearchUsersFromFirebase()
        }else{
            refreshTableViewWithSearch()
        }
    }

    //MARK: - Buttons' Events
    @IBAction func click_btn_Back(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func click_btn_Cancel(_ sender: AnyObject) {
        array_Search_Users_Filter = []
        txt_Search.text = ""
        txt_Search.resignFirstResponder()
        
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
        return array_Search_Users_Filter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SearchUsernameTBCell = self.tbl_List.dequeueReusableCell(withIdentifier: "SearchUsernameCell")! as! SearchUsernameTBCell
        cell.cellDelegate = self
        
        let user: Follow_User = array_Search_Users_Filter[indexPath.row]
        
        cell.img_Avatar.sd_setImage(with: URL(string: user.avatar), placeholderImage: UIImage(named: "Placeholder_Avatar.png"))
        cell.lbl_Name.text = user.username
        cell.lbl_Followers.text = String(user.followers) + "  followers"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    func pressedLikesButton(sender: UIButton){
        print(sender.tag)
    }
    
    //MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.txt_Search.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        refreshTableViewWithSearch()
    }
    
    @IBAction func changedEditingTextbox(_ sender: Any) {
        refreshTableViewWithSearch()
    }
    
    func refreshTableViewWithSearch() {
        array_Search_Users_Filter = []
        
        if (txt_Search.text == ""){
            tbl_List.reloadData()
            return
        }
        
        for i in (0..<appDelegate.array_Search_Users.count) {
            let user: Follow_User = appDelegate.array_Search_Users[i]
            
            array_Search_Users_Filter.append(user)
        }
        
        var k: Int = 0
        while(k < array_Search_Users_Filter.count){
            let user: Follow_User = array_Search_Users_Filter[k]
            
            let username: String = user.username
            let lowerString: String = username.lowercased()
            let compareLowerString: String = (txt_Search.text?.lowercased())!
            
            if (lowerString.range(of: compareLowerString) == nil){
                array_Search_Users_Filter.remove(at: k)
            }else{
                k += 1
            }
        }
        
        tbl_List.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - SearchUsernameTBCellDelegate
    func select_btn_Follow(cell: SearchUsernameTBCell) {
        let indexPath: IndexPath = self.tbl_List.indexPath(for: cell)!
        
//        sendFriendRequest(index: indexPath.row)
        sendFriendRequestWithFirebase(index: indexPath.row)
    }

    //MARK: - refreshAllDatas
    func refreshAllDatas(){
        refresh_Flag = 1
//        refreshControl.beginRefreshing()
        
//        txt_Search.text = ""
//        loadSearchUsersFromServer()
        
        loadSearchUsersFromFirebase()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            
            print("Following load")
        })
    }
    
    // MARK: - Firebase
    func loadSearchUsersFromFirebase(){
//        appDelegate.array_Search_Users = []
//        appDelegate.array_All_Users = []
//        appDelegate.array_All_Followings = []
//        array_Search_Users_Filter = []
        
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
                    
                    for i in (0..<appDelegate.array_All_Users.count){
                        let follow_user: Follow_User = Follow_User()
                        let user: User = appDelegate.array_All_Users[i]
                        
                        if (user.id == USER.id){ continue}
                        
                        var n_Flag = false
                        for j in (0..<appDelegate.array_All_Followings.count){
                            let following: Following = appDelegate.array_All_Followings[j]
                            
                            if (following.id == USER.id && following.following_id == user.id){
                                n_Flag = true
                                break
                            }
                        }
                        
                        if (n_Flag == false){
                            follow_user.id = user.id
                            follow_user.name = user.name
                            follow_user.username = user.username
                            follow_user.avatar = user.avatar
                            follow_user.motives = user.motives
                            follow_user.followers = user.followers
                            
                            appDelegate.array_Search_Users.append(follow_user)
                        }
                    }
                    
                    if (appDelegate.array_Search_Users.count == 0){
                        self.refreshTableViewWithSearch()
                        self.refresh_Flag = 0
                        self.refreshControl.endRefreshing()
                        return
                    }
                    
                    //sort
                    for i in (0..<appDelegate.array_Search_Users.count-1){
                        var user: Follow_User = appDelegate.array_Search_Users[i]
                        for j in (i..<appDelegate.array_Search_Users.count){
                            let user_compare: Follow_User = appDelegate.array_Search_Users[j]
                            
                            if (user.username.lowercased().compare(user_compare.username.lowercased()) == .orderedAscending){
                                
                            }else if (user.username.lowercased().compare(user_compare.username.lowercased()) == .orderedDescending){
                                appDelegate.array_Search_Users.remove(at: i)
                                appDelegate.array_Search_Users.insert(user_compare, at: i)
                                
                                appDelegate.array_Search_Users.remove(at: j)
                                appDelegate.array_Search_Users.insert(user, at: j)
                                
                                user = user_compare
                            }
                            
                        }
                    }

                    self.refreshTableViewWithSearch()
                    self.refresh_Flag = 0
                    self.refreshControl.endRefreshing()
                }else{
                    self.refresh_Flag = 0
                    self.refreshControl.endRefreshing()
                    
                    COMMON.methodForAlert(titleString: kAppName, messageString: (error?.localizedDescription)!, OKButton: kOkButton, CancelButton: "", viewController: self)
                }
        }
    }

    func sendFriendRequestWithFirebase(index: Int){
        let follow_user: Follow_User = array_Search_Users_Filter[index]
        
        FirebaseModule.shareInstance.FollowingUser(id: USER.id, following_id: follow_user.id){
            (response: String?, error: Error?) in
            
            if (error == nil && response == "success"){
                self.array_Search_Users_Filter.remove(at: index)
                
                for i in (0..<appDelegate.array_Search_Users.count){
                    let user_compare: Follow_User = appDelegate.array_Search_Users[i]
                    
                    if (follow_user.id == user_compare.id){
                        appDelegate.array_Search_Users.remove(at: i)
                        break
                    }
                }
                
                self.addFollowingUser(id: follow_user.id)
                
            }else{
                COMMON.methodForAlert(titleString: kAppName, messageString: (error?.localizedDescription)!, OKButton: kOkButton, CancelButton: "", viewController: self)
            }
        }
        
        FirebaseModule.shareInstance.IncreaseUserFollowings(id: USER.id, following_id: follow_user.id){ (response: String?, error: Error?) in
            
            if (error == nil && response == "success"){
                
            }else{
                COMMON.methodForAlert(titleString: kAppName, messageString: (error?.localizedDescription)!, OKButton: kOkButton, CancelButton: "", viewController: self)
            }
        }
    }
    
    
    func addFollowingUser(id: String){
        for i in (0..<appDelegate.array_All_Users.count){
            let user: User = appDelegate.array_All_Users[i]
            
            if (user.id == id){
                let following: Following = Following()
                following.id = USER.id
                following.following_id = id
                
                appDelegate.array_All_Followings.append(following)
                
                let follow_user: Follow_User = Follow_User()
                follow_user.id = user.id
                follow_user.name = user.name
                follow_user.username = user.username
                follow_user.avatar = user.avatar
                follow_user.motives = user.motives
                follow_user.followers = user.followers + 1
                
                user.followers = user.followers + 1
                
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
                
            }
        }
        self.tbl_List.reloadData()
    }
    /*
    // MARK: - API Calls
    func loadSearchUsersFromServer(){
        if (refresh_Flag == 0){
//            loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
//            loadingNotification?.mode = MBProgressHUDMode.indeterminate
//            loadingNotification?.label.text = "Loading..."
        }
        
        let parameters = ["user_id": USER.id]
        Alamofire.request(kApi_AppUsers, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil) .responseJSON { response in
            
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
                    self.fetchSearchUserDataFromJSON(json: jsonObject["data"])
                    
                }else{
                    appDelegate.array_Search_Users = []
                    self.array_Search_Users_Filter = []
                    
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
    
    func fetchSearchUserDataFromJSON(json: SwiftyJSON.JSON){
        appDelegate.array_Search_Users = []
        array_Search_Users_Filter = []
        
        for i in (0..<json.count) {
            let follow_user = Follow_User()
            
            follow_user.initFollowUserDataWithJSON(json: json[i])
            appDelegate.array_Search_Users.append(follow_user)
        }
        
        //sort
        for i in (0..<appDelegate.array_Search_Users.count-1){
            var user: Follow_User = appDelegate.array_Search_Users[i]
            for j in (i..<appDelegate.array_Search_Users.count){
                let user_compare: Follow_User = appDelegate.array_Search_Users[j]
                
                if (user.username.lowercased().compare(user_compare.username.lowercased()) == .orderedAscending){
                    
                }else if (user.username.lowercased().compare(user_compare.username.lowercased()) == .orderedDescending){
                    appDelegate.array_Search_Users.remove(at: i)
                    appDelegate.array_Search_Users.insert(user_compare, at: i)
                    
                    appDelegate.array_Search_Users.remove(at: j)
                    appDelegate.array_Search_Users.insert(user, at: j)
                    
                    user = user_compare
                }
                
            }
        }

        refreshTableViewWithSearch()
    }
    
    func sendFriendRequest(index: Int){
        let follow_user: Follow_User = array_Search_Users_Filter[index]
        
//        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
//        loadingNotification?.mode = MBProgressHUDMode.indeterminate
//        loadingNotification?.label.text = "Loading..."
        
        let parameters = ["user_id": USER.id, "followee": follow_user.id] as [String : Any]
        Alamofire.request(KApi_JoinFriends, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil) .responseJSON { response in
            
//            self.loadingNotification?.hide(animated: true)
            
            switch response.result {
            case .success(_):
                let jsonObject = JSON(response.result.value!)
                let status: String = jsonObject["status"].stringValue
                if (status == "success"){
                    let user: Follow_User = self.array_Search_Users_Filter[index]
                    
                    self.array_Search_Users_Filter.remove(at: index)
                    
                    for i in (0..<appDelegate.array_Search_Users.count){
                        let user_compare: Follow_User = appDelegate.array_Search_Users[i]
                        
                        if (user.id == user_compare.id){
                            appDelegate.array_Search_Users.remove(at: i)
                            break
                        }
                    }
                    
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
*/
}
