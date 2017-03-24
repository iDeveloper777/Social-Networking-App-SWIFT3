//
//  SearchViewController.swift
//  My-Mo
//
//  Created by iDeveloper on 11/5/16.
//  Copyright © 2016 iDeveloper. All rights reserved.
//

import UIKit
import Contacts

import Alamofire
import SwiftyJSON
import MBProgressHUD
import Firebase

class SearchViewController: UIViewController {
    
    @IBOutlet weak var view_Navigation: UIView!
    @IBOutlet weak var view_Main: UIView!
    
    var array_ContactList: [PhoneContact_User] = []
//    var loadingNotification:MBProgressHUD? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        if (DATAKEEPER.getContactUploaded() == "NO"){
            getContactList()
//        }
        
        
    }

    //MARK: - Buttons' Events
    @IBAction func click_btn_Back(_ sender: AnyObject) {
    }
    
    @IBAction func click_btn_Username(_ sender: AnyObject) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SearchUsernameView") as! SearchUsernameViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func click_btn_Phonebook(_ sender: AnyObject) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SearchPhonebookView") as! SearchPhonebookViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func click_btn_World(_ sender: AnyObject) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SearchWorldView") as! SearchWorldViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    @IBAction func click_btn_Map(_ sender: AnyObject) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SearchMapView") as! SearchMapViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    //MARK: - Contact List
    func getContactList(){
        
        let contacts: [CNContact] = {
            let contactStore = CNContactStore()
            let keysToFetch = [
                CNContactGivenNameKey,
                CNContactMiddleNameKey,
                CNContactFamilyNameKey,
                CNContactEmailAddressesKey,
                CNContactPhoneNumbersKey,
                CNContactImageDataAvailableKey,
                CNContactThumbnailImageDataKey] as [Any]
            
            // Get all the containers
            var allContainers: [CNContainer] = []
            do {
                allContainers = try contactStore.containers(matching: nil)
            } catch {
                print("Error fetching containers")
            }
            
            var results: [CNContact] = []
            
            // Iterate all containers and append their contacts to our results array
            for container in allContainers {
                let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
                
                do {
                    let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                    results.append(contentsOf: containerResults)
                } catch {
                    print("Error fetching results for container")
                }
            }
            
            return results
        }()
        
        if (contacts.count == 0){
            return
        }
        
        for i in (0..<contacts.count){
            let cont: CNContact = contacts[i]
            
            let cnPhone: CNPhoneNumber = cont.phoneNumbers[0].value
            let phone: String = cnPhone.value(forKey: "digits") as! String
            
            let pc_user = PhoneContact_User()
            pc_user.mobile = phone
            pc_user.username = cont.givenName + " " + cont.middleName + " "
            
            array_ContactList.append(pc_user)
        }
        
        //sort
        for i in (0..<array_ContactList.count-1){
            var pc_user: PhoneContact_User = array_ContactList[i]
            for j in (i..<array_ContactList.count){
                let pc_user_compare: PhoneContact_User = array_ContactList[j]
                
                if (pc_user.username.compare(pc_user_compare.username) == .orderedAscending){
                    
                }else if (pc_user.username.compare(pc_user_compare.username) == .orderedDescending){
                    array_ContactList.remove(at: i)
                    array_ContactList.insert(pc_user_compare, at: i)
                    
                    array_ContactList.remove(at: j)
                    array_ContactList.insert(pc_user, at: j)
                    
                    pc_user = pc_user_compare
                }
                
            }
        }
        
        if (array_ContactList.count > 0){
            var str_Numbers: String = ""
            
            for i in (0..<array_ContactList.count){
                let pc_user: PhoneContact_User = array_ContactList[i]
                
                if (i < array_ContactList.count - 1){
                    str_Numbers = str_Numbers + pc_user.mobile + ","
                }else{
                    str_Numbers = str_Numbers + pc_user.mobile
                }
            }
            
//            uploadContactsToServer(value: str_Numbers)
        }
    }
    
    /*
    func uploadContactsToServer(value: String){
//        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
//        loadingNotification?.mode = MBProgressHUDMode.indeterminate
//        loadingNotification?.label.text = "Loading..."
        
        let parameters = ["user_id": USER.id, "contacts": value, "device": "ios"] as [String : Any]
        Alamofire.request(kApi_UploadContacts, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil) .responseJSON { response in
            
//            self.loadingNotification?.hide(animated: true)
            
            switch response.result {
            case .success(_):
                let jsonObject = JSON(response.result.value!)
                let status: String = jsonObject["status"].stringValue
                if (status == "success"){
                    DATAKEEPER.updateContactUploaded(value: "YES")
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
