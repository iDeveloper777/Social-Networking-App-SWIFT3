//
//  Motiff_User.swift
//  My-Mo
//
//  Created by iDeveloper on 12/23/16.
//  Copyright © 2016 iDeveloper. All rights reserved.
//

import Foundation

import SwiftyJSON

class Motiff_User: NSObject{
    
    var id: String = ""
    var username: String = ""
    var name: String = ""
    var avatar: String = ""
    var country: String = ""
    var city: String = ""
    var who_can: String = ""
    var friend: String = ""
    var live_motiffs: Int = 0
    var motiffs: [Home_Motiff] = []
    var followers: Int64 = 0
    
    func initUserData(){
        id = ""
        username = ""
        name = ""
        avatar = ""
        country = ""
        city = ""
        who_can = ""
        friend = ""
        live_motiffs = 0
        motiffs = []
        followers = 0
    }
    
    func initUserDataWithUser(user: User){
        id = user.id
        username = user.username
        name = user.name
        avatar = user.avatar
        country = user.country
        city = user.city
        who_can = user.who_can
        followers = user.followers
    }
    
//    func initMotiffUserDataWithJSON(json: SwiftyJSON.JSON){
////        id  = json["id"].intValue
//        username = json["username"].stringValue
//        name = json["name"].stringValue
//        avatar = json["avatar"].stringValue
//        country = json["country"].stringValue
//        city = json["city"].stringValue
//        who_can = json["who_can"].stringValue
//        friend = json["friend"].stringValue
//        live_motiffs = json["live_motiffs"].intValue
//        followers = json["followers"].intValue
//        
//        motiffs = []
//        let jsonMotiffs = json["motiffs"] as SwiftyJSON.JSON
//        
//        for i in (0..<jsonMotiffs.count) {
//            let motiff = Home_Motiff()
//            
//            motiff.initHomeMotiffDataWithJSON(json: jsonMotiffs[i])
//            motiffs.append(motiff)
//        }
//
//    }
}

class Home_Motiff: NSObject{
    
    var motiff_id: String = ""
    var hosted_by: String = ""
    var title: String = ""
    var Description: String = ""
    var location: String = ""
    var content_url: String = ""
    var thumbnail: String = ""
    var like: Int = 0
    var likes_count: Int = 0
    var read: Int = 0
    var time: String = ""
    var isVideo: Int = 0
    
    func initMotiffData(){
        motiff_id = ""
        hosted_by = ""
        title = ""
        Description = ""
        location = ""
        content_url = ""
        thumbnail = ""
        like = 0
        likes_count = 0
        read = 0
        time = ""
        isVideo = 0
    }
    
    func initMotiffDataWithHost(host: Host){
        motiff_id = host.id
        hosted_by = host.user_id
        title = host.title
        Description = host.Description
        location = host.location_latitude + "," + host.location_longitude
        content_url = host.content_url
        thumbnail = host.thumbnail_url
        isVideo = host.isVideo
        
        if (COMMON.get_Date_from_UTC_time(string: host.creation_date + " " + host.creation_time) == COMMON.get_Current_UTC_Date()){
            time = "Today " + host.creation_time
        }else{
            time = COMMON.get_Date_time_from_UTC_time(string: host.creation_date + " " + host.creation_time)
        }
        
    }
    
//    func initHomeMotiffDataWithJSON(json: SwiftyJSON.JSON){
//        motiff_id  = json["motiff_id"].intValue
//        hosted_by = json["hosted_by"].intValue
//        title = json["title"].stringValue
//        Description = json["description"].stringValue
//        location = json["location"].stringValue
//        thumbnail = json["thumbnail"].stringValue
//        likes = json["likes"].intValue
//        read = json["read"].intValue
//        time = json["time"].stringValue
//    }
}



