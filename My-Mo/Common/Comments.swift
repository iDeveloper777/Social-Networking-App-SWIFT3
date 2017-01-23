//
//  Comments.swift
//  My-Mo
//
//  Created by iDeveloper on 12/26/16.
//  Copyright © 2016 iDeveloper. All rights reserved.
//

import Foundation
import SwiftyJSON

class Comment: NSObject{
    
    var motiff_user: Int = 0
    var user_id: Int = 0
    var avatar: String = ""
    var username: String = ""
    var comment_id: Int = 0
    var comment: String = ""
    var time: String = ""
    var date: String = ""
    var following: String = ""
    
    func initCommentData(){
        motiff_user = 0
        user_id = 0
        avatar = ""
        username = ""
        comment_id = 0
        comment = ""
        time = ""
        date = ""
        following = ""
    }
    
    func initCommentDataWithJSON(json: SwiftyJSON.JSON){
        motiff_user  = json["motiff_user"].intValue
        user_id  = json["user_id"].intValue
        avatar = json["avatar"].stringValue
        username = json["username"].stringValue
        comment_id  = json["comment_id"].intValue
        comment = json["comment"].stringValue
        time = json["time"].stringValue
        date = json["date"].stringValue
        following = json["following"].stringValue
    }
}
