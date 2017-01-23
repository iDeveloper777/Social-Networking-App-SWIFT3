//
//  Host.swift
//  My-Mo
//
//  Created by iDeveloper on 1/5/17.
//  Copyright © 2017 iDeveloper. All rights reserved.
//

import Foundation
import SwiftyJSON
import ROThumbnailGenerator

class Host: NSObject{
    
    var id: Int = 0
    var title: String = ""
    var Description: String = ""
    var location: String = ""
    var thumbnail: String = ""
    var share_with: String = ""
    var creation_date: String = ""
    var creation_time: String = ""
    var total_likes: Int = 0
    var total_comments: Int = 0
    var comment1: String = ""
    var name1: String = ""
    var avatar1: String = ""
    var comment2: String = ""
    var name2: String = ""
    var avatar2: String = ""
    
    var thumbnail_image: UIImage? = nil

    
    func initHostData(){
        id = 0
        title = ""
        Description = ""
        location = ""
        thumbnail = ""
        share_with = ""
        creation_date = ""
        creation_time = ""
        total_likes = 0
        total_comments = 0
        comment1 = ""
        name1 = ""
        avatar1 = ""
        comment2 = ""
        name2 = ""
        avatar2 = ""
        
        thumbnail_image = nil
    }
    
    func initHostDataWithJSON(json: SwiftyJSON.JSON){
        id  = json["id"].intValue
        title = json["title"].stringValue
        Description = json["description"].stringValue
        location = json["location"].stringValue
        thumbnail = json["thumbnail"].stringValue
        share_with = json["share_with"].stringValue
        creation_date = json["creation_date"].stringValue
        creation_time = json["creation_time"].stringValue
        total_likes = json["total_likes"].intValue
        total_comments = json["total_comments"].intValue
        comment1 = json["comment1"].stringValue
        name1 = json["name1"].stringValue
        avatar1 = "http://mymotiff.com/" + json["avatar1"].stringValue
        comment2 = json["comment2"].stringValue
        name2 = json["name2"].stringValue
        avatar2 = "http://mymotiff.com/" + json["avatar2"].stringValue
        
        if (thumbnail.contains("mov")){
            thumbnail_image = ROThumbnail.sharedInstance.getThumbnail(URL(string: thumbnail)!)
        }
    }
    
}
