//
//  File.swift
//  My-Mo
//
//  Created by iDeveloper on 2/14/17.
//  Copyright © 2017 iDeveloper. All rights reserved.
//

import Foundation
import SwiftyJSON

class Follow_User: NSObject{
    
    var id: Int = 0
    var name: String = ""
    var username: String = ""
    var avatar: String = ""
    var motives: Int = 0
    var followers: Int = 0
    
    func initUserData(){
        id = 0
        username = ""
        name = ""
        avatar = ""
        motives = 0
        followers = 0
    }
    
    func initFollowUserDataWithJSON(json: SwiftyJSON.JSON){
        id  = json["id"].intValue
        username = json["username"].stringValue
        name = json["name"].stringValue
        avatar = "http://mymotiff.com/" + json["avatar"].stringValue
        motives = json["motives"].intValue
        followers = json["followers"].intValue
    }
}
