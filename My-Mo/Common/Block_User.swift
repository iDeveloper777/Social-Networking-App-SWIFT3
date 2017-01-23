//
//  Block_User.swift
//  My-Mo
//
//  Created by iDeveloper on 1/3/17.
//  Copyright © 2017 iDeveloper. All rights reserved.
//

import Foundation

import SwiftyJSON

class Block_User: NSObject{
    
    var id: Int = 0
    var username: String = ""
    var name: String = ""
    var avatar: String = ""
    var blocked: String = ""
    
    func initUserData(){
        id = 0
        username = ""
        name = ""
        avatar = ""
        blocked = "no"
    }
    
    func initBlockUserDataWithJSON(json: SwiftyJSON.JSON){
        id  = json["id"].intValue
        username = json["username"].stringValue
        name = json["name"].stringValue
        avatar = "http://mymotiff.com/" + json["avatar"].stringValue
        blocked = json["blocked"].stringValue
    }
}
