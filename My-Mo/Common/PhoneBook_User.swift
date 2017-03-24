//
//  PhoneBook_User.swift
//  My-Mo
//
//  Created by iDeveloper on 1/26/17.
//  Copyright © 2017 iDeveloper. All rights reserved.
//

import Foundation
import SwiftyJSON

class PhoneBook_User: NSObject{
    
    var id: String = ""
    var name: String = ""
    var username: String = ""
    var mobile: String = ""
    var avatar: String = ""
    
    func initUserData(){
        id = ""
        username = ""
        name = ""
        mobile = ""
        avatar = ""
    }
   /*
    func initPhoneBookUserDataWithJSON(json: SwiftyJSON.JSON){
        id  = json["id"].intValue
        username = json["username"].stringValue
        name = json["name"].stringValue
        mobile = json["mobile"].stringValue
        avatar = "http://mymotiff.com/" + json["avatar"].stringValue
    }
     */
}
 
