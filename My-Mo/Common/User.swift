//
//  User.swift
//  My-Mo
//
//  Created by iDeveloper on 12/2/16.
//  Copyright © 2016 iDeveloper. All rights reserved.
//

import Foundation
import SwiftyJSON

class User: NSObject{
    
    var id: Int = 0
    var username: String = ""
    var email: String = ""
    var password: String = ""
    var name: String = ""
    var user_status: String = ""
    var avatar: String = ""
    var time: String = ""
    var mobile: String = ""
    var who_can: String = ""
    var notification: Int = 0
    var host_history: Int = 0
    var allow_friend_to_search: Int = 0
    var who_can_send_dm: String = ""
    var clear_text_conversation: String = ""
    var country: String = ""
    var city: String = ""
    var blocked_users: Int = 0
    var status: String = ""
    var nta: Int = 0
    
    var avatar_image: NSData? = nil
    
    func initUserData(){
        id = 0
        username = ""
        email = ""
        password = ""
        name = ""
        user_status = ""
        avatar = ""
        time = ""
        mobile = ""
        who_can = ""
        notification = 0
        host_history = 0
        allow_friend_to_search = 0
        who_can_send_dm = ""
        clear_text_conversation = ""
        country = ""
        city = ""
        blocked_users = 0
        status = ""
        nta = 0

        avatar_image = nil
    }

    func initUserDataWithJSON(json: SwiftyJSON.JSON){
        id  = json["id"].intValue
        username = json["username"].stringValue
        email = json["email"].stringValue
        name = json["name"].stringValue
        user_status = json["user_status"].stringValue
        avatar = json["avatar"].stringValue
        time = json["time"].stringValue
        mobile = json["mobile"].stringValue
        who_can = json["who_can"].stringValue
        notification = json["notification"].intValue
        
        if (json["host_history"].intValue == 3){
            host_history = 1
        }else if (json["host_history"].intValue == 5){
            host_history = 2
        }else if (json["host_history"].intValue == 7){
            host_history = 3
        }else{
            host_history = 0
        }
        
        //host_history = json["host_history"].intValue
        allow_friend_to_search = json["allow_friend_to_search"].intValue
        who_can_send_dm = json["who_can_send_dm"].stringValue
        clear_text_conversation = json["clear_text_conversation"].stringValue
        country = json["country"].stringValue
        city = json["city"].stringValue
        blocked_users = json["blocked_users"].intValue
        
        
    }
    
    func initSignUpUserDataWithJSON(json: SwiftyJSON.JSON){
        id  = json["user_id"].intValue
        username = json["details"]["username"].stringValue
        email = json["details"]["email"].stringValue
        name = json["details"]["name"].stringValue
        password = json["details"]["password"].stringValue
        user_status = json["details"]["user_status"].stringValue
        nta = json["details"]["nta"].intValue
        status = json["details"]["status"].stringValue
        avatar = json["details"]["avatar"].stringValue
        mobile = json["mobile"].stringValue
    }

    
    func initUserDataWithUserDefault(){
        prefs.set(0, forKey: "id")
        prefs.set("", forKey: "username")
        prefs.set("", forKey: "email")
//        prefs.set("", forKey: "password")
        prefs.set("", forKey: "name")
        prefs.set("", forKey: "user_status")
        prefs.set("", forKey: "avatar")
        prefs.set("", forKey: "time")
        prefs.set("", forKey: "mobile")
        prefs.set("", forKey: "who_can")
        prefs.set(0, forKey: "notification")
        prefs.set(0, forKey: "host_history")
        prefs.set(0, forKey: "allow_friend_to_search")
        prefs.set("", forKey: "who_can_send_dm")
        prefs.set("", forKey: "clear_text_conversation")
        prefs.set("", forKey: "country")
        prefs.set("", forKey: "city")
        prefs.set(0, forKey: "blocked_users")
        prefs.set("", forKey: "status")
        prefs.set(0, forKey: "nta")
        
        prefs.set(nil, forKey: "avatar_image")
    }
    
    func updateUserDataWithUserDefault(){
        prefs.set(id, forKey: "id")
        prefs.set(username, forKey: "username")
        prefs.set(email, forKey: "email")
//        prefs.set(password, forKey: "password")
        prefs.set(name, forKey: "name")
        prefs.set(user_status, forKey: "user_status")
        prefs.set(avatar, forKey: "avatar")
        prefs.set(time, forKey: "time")
        prefs.set(mobile, forKey: "mobile")
        prefs.set(who_can, forKey: "who_can")
        prefs.set(notification, forKey: "notification")
        prefs.set(host_history, forKey: "host_history")
        prefs.set(allow_friend_to_search, forKey: "allow_friend_to_search")
        prefs.set(who_can_send_dm, forKey: "who_can_send_dm")
        prefs.set(clear_text_conversation, forKey: "clear_text_conversation")
        prefs.set(country, forKey: "country")
        prefs.set(city, forKey: "city")
        prefs.set(blocked_users, forKey: "blocked_users")
        prefs.set(status, forKey: "status")
        prefs.set(nta, forKey: "nta")
        
        prefs.set(avatar_image, forKey: "avatar_image")
    }
    
    func getUserDataWithUserDefault(){
        if ((prefs.object(forKey: "id")) != nil){
            id = prefs.object(forKey: "id") as! Int
        }
        
        if ((prefs.object(forKey: "username")) != nil){
            username = prefs.object(forKey: "username") as! String
        }
        
        if ((prefs.object(forKey: "email")) != nil){
            email = prefs.object(forKey: "email") as! String
        }
        
        if ((prefs.object(forKey: "password")) != nil){
            password = prefs.object(forKey: "password") as! String
        }
        
        if ((prefs.object(forKey: "name")) != nil){
            name = prefs.object(forKey: "name") as! String
        }
        
        if ((prefs.object(forKey: "user_status")) != nil){
            user_status = prefs.object(forKey: "user_status") as! String
        }

        if ((prefs.object(forKey: "avatar")) != nil){
            avatar = prefs.object(forKey: "avatar") as! String
        }
        
        if ((prefs.object(forKey: "time")) != nil){
            time = prefs.object(forKey: "time") as! String
        }
        
        if ((prefs.object(forKey: "mobile")) != nil){
            mobile = prefs.object(forKey: "mobile") as! String
        }
        
        if ((prefs.object(forKey: "who_can")) != nil){
            who_can = prefs.object(forKey: "who_can") as! String
        }
        
        if ((prefs.object(forKey: "notification")) != nil){
            notification = prefs.object(forKey: "notification") as! Int
        }
        
        if ((prefs.object(forKey: "host_history")) != nil){
            host_history = prefs.object(forKey: "host_history") as! Int
        }
        
        if ((prefs.object(forKey: "allow_friend_to_search")) != nil){
            allow_friend_to_search = prefs.object(forKey: "allow_friend_to_search") as! Int
        }
        
        if ((prefs.object(forKey: "who_can_send_dm")) != nil){
            who_can_send_dm = prefs.object(forKey: "who_can_send_dm") as! String
        }
        
        if ((prefs.object(forKey: "clear_text_conversation")) != nil){
            clear_text_conversation = prefs.object(forKey: "clear_text_conversation") as! String
        }

        if ((prefs.object(forKey: "country")) != nil){
            country = prefs.object(forKey: "country") as! String
        }

        if ((prefs.object(forKey: "city")) != nil){
            city = prefs.object(forKey: "city") as! String
        }

        if ((prefs.object(forKey: "blocked_users")) != nil){
            blocked_users = prefs.object(forKey: "blocked_users") as! Int
        }
        
        if ((prefs.object(forKey: "status")) != nil){
            status = prefs.object(forKey: "status") as! String
        }

        if ((prefs.object(forKey: "nta")) != nil){
            nta = prefs.object(forKey: "nta") as! Int
        }
        
        if ((prefs.object(forKey: "avatar_image")) != nil){
            avatar_image = prefs.object(forKey: "avatar_image") as? NSData
        }

    }
}
