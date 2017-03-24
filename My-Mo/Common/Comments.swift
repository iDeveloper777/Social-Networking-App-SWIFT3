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
    
    var motiff_id: String = ""
    var motiff_user: String = ""
    var user_id: String = ""
    var avatar: String = ""
    var username: String = ""
    var comment_id: String = ""
    var comment: String = ""
    var time: String = ""
    var date: String = ""
    var following: String = ""
    
    func initCommentData(){
        motiff_id = ""
        motiff_user = ""
        user_id = ""
        avatar = ""
        username = ""
        comment_id = ""
        comment = ""
        time = ""
        date = ""
        following = ""
    }
    
    func initCommentDataWithDictionary(dic_comment: [String : Any]){
        
        motiff_id = dic_comment["motiff_id"] as! String
        motiff_user = dic_comment["motiff_user"] as! String
        user_id = dic_comment["user_id"] as! String
        username = dic_comment["username"] as! String
        avatar = dic_comment["avatar"] as! String
        comment_id = dic_comment["comment_id"] as! String
        comment = dic_comment["comment"] as! String
        time = dic_comment["time"] as! String
        date = dic_comment["date"] as! String
        following = dic_comment["following"] as! String
    }
    
    func getDictionaryWithComment() -> [String: Any]{
        var dic_comment: [String: Any] = [:]
        dic_comment["motiff_user"] = motiff_user
        dic_comment["motiff_id"] = motiff_id
        dic_comment["user_id"] = user_id
        dic_comment["username"] = username
        dic_comment["avatar"] = avatar
        dic_comment["comment_id"] = comment_id
        dic_comment["comment"] = comment
        dic_comment["date"] = date
        dic_comment["time"] = time
        dic_comment["following"] = ""
        
        return dic_comment
    }
    
    /*
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
     */
}
