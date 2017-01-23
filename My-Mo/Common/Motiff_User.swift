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
    
    var id: Int = 0
    var username: String = ""
    var name: String = ""
    var avatar: String = ""
    var country: String = ""
    var city: String = ""
    var who_can: String = ""
    var friend: String = ""
    var live_motiffs: Int = 0
    var motiffs: [Home_Motiff] = []
    var followers: Int = 0
    
    func initUserData(){
        id = 0
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
    
    func initMotiffUserDataWithJSON(json: SwiftyJSON.JSON){
        id  = json["id"].intValue
        username = json["username"].stringValue
        name = json["name"].stringValue
        avatar = json["avatar"].stringValue
        country = json["country"].stringValue
        city = json["city"].stringValue
        who_can = json["who_can"].stringValue
        friend = json["friend"].stringValue
        live_motiffs = json["live_motiffs"].intValue
        followers = json["followers"].intValue
        
        motiffs = []
        let jsonMotiffs = json["motiffs"] as SwiftyJSON.JSON
        
        for i in (0..<jsonMotiffs.count) {
            let motiff = Home_Motiff()
            
            motiff.initHomeMotiffDataWithJSON(json: jsonMotiffs[i])
            motiffs.append(motiff)
        }

    }
}

class Home_Motiff: NSObject{
    
    var motiff_id: Int = 0
    var hosted_by: Int = 0
    var title: String = ""
    var Description: String = ""
    var location: String = ""
    var thumbnail: String = ""
    var likes: Int = 0
    var read: Int = 0
    var time: String = ""
    
    func initUserData(){
        motiff_id = 0
        hosted_by = 0
        title = ""
        Description = ""
        location = ""
        thumbnail = ""
        likes = 0
        read = 0
        time = ""
    }
    
    func initHomeMotiffDataWithJSON(json: SwiftyJSON.JSON){
        motiff_id  = json["motiff_id"].intValue
        hosted_by = json["hosted_by"].intValue
        title = json["title"].stringValue
        Description = json["description"].stringValue
        location = json["location"].stringValue
        thumbnail = json["thumbnail"].stringValue
        likes = json["likes"].intValue
        read = json["read"].intValue
        time = json["time"].stringValue
    }
}



