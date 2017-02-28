//
//  PhoneContact_User.swift
//  My-Mo
//
//  Created by iDeveloper on 1/26/17.
//  Copyright © 2017 iDeveloper. All rights reserved.
//

import Foundation

import Foundation
import SwiftyJSON

class PhoneContact_User: NSObject{
    
    var id: Int = 0
    var name: String = ""
    var username: String = ""
    var mobile: String = ""
    var avatar: String = ""
    
    func initUserData(){
        id = 0
        username = ""
        name = ""
        mobile = ""
        avatar = ""
    }
    
//    func initPhoneBookUserDataWithJSON(json: SwiftyJSON.JSON){
//        id  = json["id"].intValue
//        username = json["username"].stringValue
//        name = json["name"].stringValue
//        mobile = json["mobile"].stringValue
//        avatar = "http://mymotiff.com/" + json["avatar"].stringValue
//    }
}
