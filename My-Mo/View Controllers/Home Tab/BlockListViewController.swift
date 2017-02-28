//
//  BlockListViewController.swift
//  My-Mo
//
//  Created by iDeveloper on 11/11/16.
//  Copyright © 2016 iDeveloper. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD

class BlockListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, BlockedTBCellDelegate{
    @IBOutlet weak var view_Navigation: UIView!
    @IBOutlet weak var view_Main: UIView!
    @IBOutlet weak var tbl_List: UITableView!
    
    //Local Variables
//    var loadingNotification:MBProgressHUD? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadBlockListFromServer()
        
        tbl_List.separatorStyle = .none
    }
    
    func loadBlockListFromServer(){
        if (appDelegate.array_BlockUsers.count == 0){
//            loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
//            loadingNotification?.mode = MBProgressHUDMode.indeterminate
//            loadingNotification?.label.text = "Loading..."
        }
        
        let parameters = ["user_id":USER.id]
        Alamofire.request(kApi_BlockList, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil) .responseJSON { response in
            
            if (appDelegate.array_BlockUsers.count == 0){
//                self.loadingNotification?.hide(animated: true)
            }
            
            switch response.result {
            case .success(_):
                let jsonObject = JSON(response.result.value!)
                let status: String = jsonObject["status"].stringValue
                if (status == "success"){
                    self.fetchBlockListFromJSON(json: jsonObject["response"])
                    
                    self.tbl_List.reloadData()
                }else{
//                    COMMON.methodForAlert(titleString: kAppName, messageString: kErrorComment, OKButton: kOkButton, CancelButton: "", viewController: self)
                }
                break
            case .failure(let error):
                print(error)
                COMMON.methodForAlert(titleString: kAppName, messageString: kNetworksNotAvailvle, OKButton: kOkButton, CancelButton: "", viewController: self)
                break
            }
            
        }
    }

    func fetchBlockListFromJSON(json: SwiftyJSON.JSON){
        appDelegate.array_BlockUsers = []
        
        for i in (0..<json.count) {
            let blockUser = Block_User()
            
            blockUser.initBlockUserDataWithJSON(json: json[i])
            appDelegate.array_BlockUsers.append(blockUser)
        }
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
        return appDelegate.array_BlockUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:BlockedTBCell = self.tbl_List.dequeueReusableCell(withIdentifier: "BlockListCell")! as! BlockedTBCell
        cell.cellDelegate = self
        
        let block_User: Block_User = appDelegate.array_BlockUsers[indexPath.row]
        
        cell.img_Avatar.sd_setImage(with: URL(string: block_User.avatar), placeholderImage: UIImage(named: "Placeholder_Avatar.png"))
        cell.lbl_Name.text = block_User.name
        
        
        if (block_User.blocked == "yes"){
            cell.is_Blocked = 1
            cell.btn_Block?.setTitle("UnBlock", for: .normal)
            cell.btn_Block?.setTitleColor(UIColor.lightGray, for: .normal)
        }else{
            cell.is_Blocked = 0
            cell.btn_Block?.setTitle("Block", for: .normal)
            cell.btn_Block?.setTitleColor(UIColor.darkGray, for: .normal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - BlockedTBCellDelegate
    func change_Block_Button(cell: BlockedTBCell) {
        blockUser(cell: cell)
    }
    
    //MARK: - blockUesr and unblockUser
    func blockUser(cell: BlockedTBCell){
        let indexPath: IndexPath = self.tbl_List.indexPath(for: cell)!
        let block_User: Block_User = appDelegate.array_BlockUsers[indexPath.row]
        
//        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
//        loadingNotification?.mode = MBProgressHUDMode.indeterminate
//        loadingNotification?.label.text = "Loading..."
        
        var str_API_URL: String = ""
        var parameters: [String : Any] = [:]
        
        if (cell.is_Blocked == 0){
            str_API_URL = kApi_BlockUser
            parameters = ["user_id":USER.id, "blocked_id":block_User.id]
        }else{
            str_API_URL = kApi_UnBlockUser
            parameters = ["user_id":USER.id, "unblocked_id":block_User.id]
        }
        
        Alamofire.request(str_API_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil) .responseJSON { response in
            
//            self.loadingNotification?.hide(animated: true)
            
            switch response.result {
            case .success(_):
                let jsonObject = JSON(response.result.value!)
                let status: String = jsonObject["status"].stringValue
                if (status == "success"){
                    if (cell.is_Blocked == 0){
                        block_User.blocked = "yes"
                        cell.is_Blocked = 1
                        USER.blocked_users = USER.blocked_users + 1
                    }else{
                        block_User.blocked = "no"
                        cell.is_Blocked = 0
                        USER.blocked_users = USER.blocked_users - 1
                    }
                    
                    cell.change_Btn_Option(option: cell.is_Blocked)
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
