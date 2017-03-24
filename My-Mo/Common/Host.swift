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
import Firebase

class Host: NSObject{
    
    var id: String = ""
    var user_id: String = ""
    var title: String = ""
    var Description: String = ""
    var isVideo: Int = 0
    var content_url: String = ""
    var content_width: String = ""
    var content_height: String = ""
    var thumbnail_url: String = ""
    
    var location_latitude: String = ""
    var location_longitude: String = ""
    var creation_date: String = ""
    var creation_time: String = ""
    var mapsearch: Int = 0
    var duration: Int = 0
    
    var share_with: String = ""
    var share_array: [Any] = []
    
    var markasread_array: [Any] = []
    var likes_count: Int = 0
    var likes_array: [Like_User] = []
    
    var comments_count: Int = 0
    var comments_array: [Comment] = []
    
    func initHostData(){
        id = ""
        user_id = ""
        title = ""
        Description = ""
        isVideo = 0
        content_url = ""
        content_width = ""
        content_height = ""
        thumbnail_url = ""
        
        location_latitude = ""
        location_longitude = ""
        creation_date = ""
        creation_time = ""
        mapsearch = 0
        duration = 0
        
        share_with = ""
        share_array = []
        
        markasread_array = []
        likes_count = 0
        likes_array = []
        
        comments_count = 0
        comments_array = []
    }
    
    func initHostDataWithDictionary(dic_motiff: [String : Any]){
        
        id = dic_motiff["id"] as! String
        user_id = dic_motiff["user_id"] as! String
        title = dic_motiff["title"] as! String
        Description = dic_motiff["Description"] as! String
        isVideo = dic_motiff["isVideo"] as! Int
        content_url = dic_motiff["content_url"] as! String
        content_width = dic_motiff["content_width"] as! String
        content_height = dic_motiff["content_height"] as! String
        thumbnail_url = dic_motiff["thumbnail_url"] as! String
        location_latitude = dic_motiff["location_latitude"] as! String
        location_longitude = dic_motiff["location_longitude"] as! String
        creation_date = dic_motiff["creation_date"] as! String
        creation_time = dic_motiff["creation_time"] as! String
        mapsearch = dic_motiff["mapsearch"] as! Int
        duration = dic_motiff["duration"] as! Int
        share_with = dic_motiff["share_with"] as! String
        
        if (dic_motiff["share_array"] != nil){
            self.share_array = dic_motiff["share_array"] as! [Any]
        }
        
        if (dic_motiff["markasread_array"] != nil){
            markasread_array = dic_motiff["markasread_array"] as! [Any]
        }
        
        likes_count = dic_motiff["likes_count"] as! Int
        comments_count = dic_motiff["comments_count"] as! Int
        
        if (dic_motiff["likes_array"] != nil){
            var temp_likes_array: [Like_User] = []
            let temp_array: [Any] = dic_motiff["likes_array"] as! [Any]
            
            for i in (0..<temp_array.count){
                let temp_dict: [String: Any] = temp_array[i] as! [String: Any]
                let like_user: Like_User = Like_User()
                
                like_user.initLikeDataWithDictionary(dic_like: temp_dict)
                temp_likes_array.append(like_user)
            }
            
            likes_array = temp_likes_array
        }
        
        if (dic_motiff["comments_array"] != nil){
            var temp_comments_array: [Comment] = []
            let temp_array: [Any] = dic_motiff["comments_array"] as! [Any]
            
            for i in (0..<temp_array.count){
                let temp_dict: [String: Any] = temp_array[i] as! [String: Any]
                let comment: Comment = Comment()
                
                comment.initCommentDataWithDictionary(dic_comment: temp_dict)
                temp_comments_array.append(comment)
            }
            
            comments_array = temp_comments_array
        }

    }
    
    /*
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
//            thumbnail_image = ROThumbnail.sharedInstance.getThumbnail(URL(string: thumbnail)!)
        }else{
            if (thumbnail != ""){
                let size: CGSize = IMAGEPROCESSING.imageSize(with: NSURL(string: thumbnail)!)
                width = size.width
                height = size.height
                
                let str: String = String(describing: width) + " / " + String(describing: height)
                print(str)
            }
        }
    }
    */
}
