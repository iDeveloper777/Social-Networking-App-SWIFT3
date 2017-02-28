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

class LikesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, LikeUserTBCellDelegate{

    @IBOutlet weak var view_Navigation: UIView!
    @IBOutlet weak var view_Table: UIView!
    @IBOutlet weak var tbl_List: UITableView!
    
    var host: Host = Host()
//    var loadingNotification:MBProgressHUD? = nil
    let refreshControl: UIRefreshControl = UIRefreshControl()
    var refresh_Flag: Int = 0

    var swipeArray:[Int] = []
    var array_Like_Users: [Like_User] = []
    var array_Following_Users: [Follow_User] = []
    var workingIndexPath: IndexPath? = nil
    
    // MARK: - Life Cycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        array_Like_Users = []
        array_Following_Users = []
        
        refreshControl.addTarget(self, action: #selector(refreshAllDatas), for: .valueChanged)
        tbl_List.addSubview(refreshControl)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tbl_List.reloadData()
        loadFollowingUsersFromServer()
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
        return array_Like_Users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:LikeUserTBCell = self.tbl_List.dequeueReusableCell(withIdentifier: "LikesCell")! as! LikeUserTBCell
        cell.cellDelegate = self
        
        let user: Like_User = array_Like_Users[indexPath.row]
        
        cell.img_Avatar.sd_setImage(with: URL(string: user.avatar), placeholderImage: UIImage(named: "Placeholder_Avatar.png"))
        cell.lbl_Name.text = user.username
        cell.lbl_Date.text = user.date + ", " + COMMON.convertTimestamp(aTimeStamp: user.time)
        
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
        
        if (workingIndexPath != nil){
            
            let preCell: LikeUserTBCell = tbl_List.cellForRow(at: workingIndexPath!) as! LikeUserTBCell
            
            if (swipeArray[(workingIndexPath?.row)!] == 1){
                swipeArray[(workingIndexPath?.row)!] = 0
                
                UIView.animate(withDuration: 0.5, animations: {
                    preCell.view_Swipe.frame = preCell.contentView.frame
                })
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
    func isFollowingUser(Id: Int) -> Bool {
        var flag: Bool = false
        
        for i in (0..<array_Following_Users.count){
            let user: Follow_User = array_Following_Users[i]
            
            if (user.id == Id){
                flag = true
            }
        }
        return flag
    }
    
    //MARK: - LikeUserTBCellDelegate
    func select_btn_Follow(cell: LikeUserTBCell) {
        let indexPath: IndexPath = self.tbl_List.indexPath(for: cell)!
        
        sendFriendRequest(index: indexPath.row)
    }
    
    //MARK: - refreshAllDatas
    func refreshAllDatas(){
        refresh_Flag = 1
        loadFollowingUsersFromServer()
    }
    
    // MARK: - API Calls
    func loadLikeUsersFromServer(){
        if (host.id == 0){
            return
        }
        
        if (refresh_Flag == 0){
//            loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
//            loadingNotification?.mode = MBProgressHUDMode.indeterminate
//            loadingNotification?.label.text = "Loading..."
        }
        
        let parameters = ["user_id": USER.id, "motiff_id": host.id]
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
        
        let parameters = ["user_id": USER.id, "followee": user.user_id]
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
}
