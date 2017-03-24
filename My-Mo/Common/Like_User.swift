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
    
    var motiff_id: String = ""
    var user_id: String = ""
    var username: String = ""
    var avatar: String = ""
    var like_or_not: Int = 0
    var time: String = ""
    var date: String = ""
    var type: String = ""
    var following: String = ""
    
    func initUserData(){
        motiff_id = ""
        user_id = ""
        username = ""
        avatar = ""
        like_or_not = 0
        time = ""
        date = ""
        type = ""
        following = "yes"
    }
    
    func initLikeDataWithDictionary(dic_like: [String : Any]){
        
        motiff_id = dic_like["motiff_id"] as! String
        user_id = dic_like["user_id"] as! String
        username = dic_like["username"] as! String
        avatar = dic_like["avatar"] as! String
        like_or_not = dic_like["like_or_not"] as! Int
        time = dic_like["time"] as! String
        date = dic_like["date"] as! String
        type = dic_like["type"] as! String
        following = dic_like["following"] as! String
    }
    
    func getDictionaryWithLikeData() -> [String: Any]{
        var dic_like: [String: Any] = [:]
        dic_like["motiff_id"] = motiff_id
        dic_like["user_id"] = user_id
        dic_like["username"] = username
        dic_like["avatar"] = avatar
        dic_like["like_or_not"] = like_or_not
        dic_like["date"] = date
        dic_like["time"] = time
        dic_like["type"] = type
        dic_like["following"] = following
        
        return dic_like
    }
    /*
    
    func initLikeUserDataWithJSON(json: SwiftyJSON.JSON){
//        user_id  = json["user_id"].intValue
        username = json["username"].stringValue
        avatar = json["avatar"].stringValue
        like_or_not  = json["like_or_not"].intValue
        time = json["time"].stringValue
        date = json["date"].stringValue
        type = json["type"].stringValue
        following = json["following"].stringValue
    }
     */
    
}
