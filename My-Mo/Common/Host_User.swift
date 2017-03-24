//
//  Host_User.swift
//  My-Mo
//
//  Created by iDeveloper on 1/4/17.
//  Copyright © 2017 iDeveloper. All rights reserved.
//

import Foundation
import SwiftyJSON

class Host_User: NSObject{
    
    var id: String = ""
    var username: String = ""
    var name: String = ""
    var avatar: String = ""
    
    func initUserData(){
        id = ""
        username = ""
        name = ""
        avatar = ""
    }
    
    func initHostUserDataWithJSON(json: SwiftyJSON.JSON){
//        id  = json["id"].intValue
        username = json["username"].stringValue
        name = json["name"].stringValue
        avatar = "http://mymotiff.com/" + json["avatar"].stringValue
    }
}
