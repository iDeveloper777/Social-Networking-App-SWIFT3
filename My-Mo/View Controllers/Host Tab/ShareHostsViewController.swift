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
        
        loadHostUsersFromServer()
    }
    
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
        
        for i in (0..<json[0].count) {
            let hostUser = Host_User()
            
            hostUser.initHostUserDataWithJSON(json: json[0][i])
            appDelegate.array_HostUsers.append(hostUser)
        }
    }
    
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

    func isCheckedUser(user_id: Int) -> Bool{
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
