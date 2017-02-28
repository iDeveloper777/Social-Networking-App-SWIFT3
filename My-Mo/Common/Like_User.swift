//
//  Like_User.swift
//  My-Mo
//
//  Created by iDeveloper on 2/15/17.
//  Copyright © 2017 iDeveloper. All rights reserved.
//

import Foundation
import SwiftyJSON

class Like_User: NSObject{
    
    var user_id: Int = 0
    var username: String = ""
    var avatar: String = ""
    var like_or_not: Int = 0
    var time: String = ""
    var date: String = ""
    var type: String = ""
    var following: String = ""
    
    func initUserData(){
        user_id = 0
        username = ""
        avatar = ""
        like_or_not = 0
        time = ""
        date = ""
        type = ""
        following = "yes"
    }
    
    func initLikeUserDataWithJSON(json: SwiftyJSON.JSON){
        user_id  = json["user_id"].intValue
        username = json["username"].stringValue
        avatar = json["avatar"].stringValue
        like_or_not  = json["like_or_not"].intValue
        time = json["time"].stringValue
        date = json["date"].stringValue
        type = json["type"].stringValue
        following = json["following"].stringValue
    }
}
