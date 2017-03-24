//
//  FirebaseModule.swift
//  My-Mo
//
//  Created by iDeveloper on 3/1/17.
//  Copyright © 2017 iDeveloper. All rights reserved.
//

import Foundation
import Firebase

typealias ServiceResponse = (String?, Error?) -> Void
typealias ServiceDictionaryResponse = (NSDictionary?, Error?) -> Void
typealias ServiceArrayResponse = (NSArray?, Error?) -> Void

class FirebaseModule: NSObject{
    let ref: FIRDatabaseReference = FIRDatabase.database().reference()
    
    class var shareInstance: FirebaseModule{
        struct Singleton{
            static let instance = FirebaseModule()
        }
        return Singleton.instance
    }
    
    //MARK: - User
    func emailCheck(input: String, onCompletion: @escaping ServiceResponse) -> Void {
        FIRAuth.auth()?.signIn(withEmail: input, password: " ") { (user, error) in
            
            if (error == nil){
                onCompletion("success", nil)
            }else{
                onCompletion(nil, error)
                print(error.debugDescription)
            }

        }
    }
    
    func SendPasswordWithFirebase(email: String, onCompletion: @escaping ServiceResponse) -> Void {
        FIRAuth.auth()?.sendPasswordReset(withEmail: email) { (error) in
            if (error == nil){
                onCompletion("success", nil)
            }else{
                onCompletion(nil, error)
                print(error.debugDescription)
            }
        }
    }

    func ConfirmRegisteredUsername(username: String?, onCompletion: @escaping ServiceResponse) -> Void{
        ref.child("usernames").child(username!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Get user value
            let value = snapshot.value as? NSDictionary
            let email = value?["email"] as? String ?? ""
            
            onCompletion(email, nil)
        }) { (error) in
            onCompletion(nil, error)
            print(error.localizedDescription)
        }
    }

    func SignUpWithEmail(email: String?, password: String?, username: String?, name: String?, mobile: String?, onCompletion: @escaping ServiceResponse) -> Void{
        
        if (email == nil || password == nil){ return}
        FIRAuth.auth()?.createUser(withEmail: email!, password: password!) { (user, error) in
            
            if (error == nil){
                let ref: FIRDatabaseReference = FIRDatabase.database().reference()
                
                ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    // Get user value
//                    let value = snapshot.value as? NSDictionary
                    let array_users = snapshot.value as? NSArray ?? []
                    let array_temp_users = array_users.mutableCopy() as! NSMutableArray
                    
                    // users
                    
                    var dic_user: [String: Any] = [:]
                    dic_user["id"] = user?.uid
                    dic_user["email"] = email
                    dic_user["username"] = username
                    dic_user["name"] = name
                    dic_user["mobile"] = mobile
                    
                    dic_user["user_status"] = ""
                    dic_user["avatar"] = ""
                    dic_user["time"] = ""
                    dic_user["who_can"] = ""
                    dic_user["notification"] = 0
                    dic_user["host_history"] = 0
                    dic_user["allow_friend_to_search"] = 0
                    dic_user["who_can_send_dm"] = ""
                    dic_user["clear_text_conversation"] = ""
                    dic_user["country"] = ""
                    dic_user["city"] = ""
                    dic_user["blocked_users"] = 0
                    dic_user["followings"] = 0
                    dic_user["followers"] = 0
                    
                    array_temp_users.add(dic_user)
                    let array_new_users = array_temp_users as NSArray
                    
                    ref.child("users").setValue(array_new_users)
                    
                    // usernames
                    if (username != nil){ ref.child("usernames").child(username!).child("email").setValue(email)}
                    
                    onCompletion("success", nil)
                }) { (error) in
                    onCompletion(nil, error)
                    print(error.localizedDescription)
                }
                
            }else{
                onCompletion(nil, error)
                print(error.debugDescription)
            }
        }
    }
    
    func SignInWithEmail(email: String?, password: String?, onCompletion: @escaping ServiceResponse) -> Void{
        
        if (email == nil || password == nil){ return}
        
        FIRAuth.auth()?.signIn(withEmail: email!, password: password!) { (user, error) in
            
            if (error == nil){
                onCompletion("success", nil)
            }else{
                onCompletion(nil, error)
                print(error.debugDescription)
            }
        }
    }

    func getAllUsers(onCompletion: @escaping ServiceArrayResponse) -> Void{
        ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Get user value
            let array_users = snapshot.value as? NSArray ?? []
            
            onCompletion(array_users, nil)
        }) { (error) in
            onCompletion(nil, error)
            print(error.localizedDescription)
        }
    }
    
    //MARK: - Following & Follower
    func getAllFollowings(onCompletion: @escaping ServiceArrayResponse) -> Void{
        ref.child("followings").observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Get user value
            let array_followings = snapshot.value as? NSArray ?? []
            
            onCompletion(array_followings, nil)
        }) { (error) in
            onCompletion(nil, error)
            print(error.localizedDescription)
        }
    }

    func FollowingUser(id: String?, following_id: String?, onCompletion: @escaping ServiceResponse) -> Void{
        
        ref.child("followings").observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Get user value
            let array_followings = snapshot.value as? NSArray ?? []
            let array_temp_followings = array_followings.mutableCopy() as! NSMutableArray
            
            // users
            
            var dic_following: [String: Any] = [:]
            dic_following["id"] = id
            dic_following["following_id"] = following_id
            
            array_temp_followings.add(dic_following)
            let array_new_followings = array_temp_followings as NSArray
            
            self.ref.child("followings").setValue(array_new_followings)
            
            onCompletion("success", nil)
        }) { (error) in
            onCompletion(nil, error)
            print(error.localizedDescription)
        }
    }
    
    func UnFollowingUser(id: String?, following_id: String?, onCompletion: @escaping ServiceResponse) -> Void{
        
        ref.child("followings").observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Get user value
            let array_followings = snapshot.value as? NSArray ?? []
            let array_temp_followings = array_followings.mutableCopy() as! NSMutableArray
            
            var n_Index = -1
            // users
            for i in (0..<array_temp_followings.count){
                let dic_following: [String: String] = array_temp_followings[i] as! [String : String]
                
                if (dic_following["id"] == id && dic_following["following_id"] == following_id){
                    n_Index = i
                    break
                }
            }

            if (n_Index != -1){ array_temp_followings.removeObject(at: n_Index)}
            let array_new_followings = array_temp_followings as NSArray
            
            self.ref.child("followings").setValue(array_new_followings)
            
            onCompletion("success", nil)
        }) { (error) in
            onCompletion(nil, error)
            print(error.localizedDescription)
        }
    }
    
    func IncreaseUserFollowings(id: String?, following_id: String, onCompletion: @escaping ServiceResponse) -> Void{
        
        ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Get user value
            //                    let value = snapshot.value as? NSDictionary
            let array_users = snapshot.value as? NSArray ?? []
            let array_temp_users = array_users.mutableCopy() as! NSMutableArray
            
            for i in (0..<array_temp_users.count){
                var dict: [String: Any] =  array_temp_users[i] as! [String : Any]
                
                let user_id = dict["id"] as! String
                if (user_id == id){
                    var followings: Int64 = dict["followings"] as! Int64
                    followings = followings + 1
                    dict["followings"] = followings
                }
                
                if (user_id == following_id){
                    var followers: Int64 = dict["followers"] as! Int64
                    followers = followers + 1
                    dict["followers"] = followers
                }
                
                array_temp_users.removeObject(at: i)
                array_temp_users.insert(dict, at: i)
            }
            
            let array_new_users = array_temp_users as NSArray
            
            self.ref.child("users").setValue(array_new_users)
            
            onCompletion("success", nil)
        }) { (error) in
            onCompletion(nil, error)
            print(error.localizedDescription)
        }
    }
    
    func DecreaseUserFollowings(id: String?, following_id: String, onCompletion: @escaping ServiceResponse) -> Void{
        
        ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Get user value
            //                    let value = snapshot.value as? NSDictionary
            let array_users = snapshot.value as? NSArray ?? []
            let array_temp_users = array_users.mutableCopy() as! NSMutableArray
            
            for i in (0..<array_temp_users.count){
                var dict: [String: Any] =  array_temp_users[i] as! [String : Any]
                
                let user_id = dict["id"] as! String
                if (user_id == id){
                    var followings: Int64 = dict["followings"] as! Int64
                    if (followings > 0){ followings = followings - 1}
                    dict["followings"] = followings
                }
                
                if (user_id == following_id){
                    var followers: Int64 = dict["followers"] as! Int64
                    if (followers > 0){ followers = followers - 1}
                    dict["followers"] = followers
                }
                
                array_temp_users.removeObject(at: i)
                array_temp_users.insert(dict, at: i)
            }
            
            let array_new_users = array_temp_users as NSArray
            
            self.ref.child("users").setValue(array_new_users)
            
            onCompletion("success", nil)
        }) { (error) in
            onCompletion(nil, error)
            print(error.localizedDescription)
        }
    }

    //MARK: - Motiff
    func upload_Motiff(host: Host, onCompletion: @escaping ServiceResponse) -> Void{
        
        ref.child("motiffs").observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Get motiffs value
            let array_motiffs = snapshot.value as? NSArray ?? []
            let array_temp_motiffs = array_motiffs.mutableCopy() as! NSMutableArray
            
            // motiff
            var dic_motiff: [String: Any] = [:]
            dic_motiff["id"] = host.id
            dic_motiff["user_id"] = host.user_id
            dic_motiff["title"] = host.title
            dic_motiff["Description"] = host.Description
            dic_motiff["isVideo"] = host.isVideo
            dic_motiff["content_url"] = host.content_url
            dic_motiff["content_width"] = host.content_width
            dic_motiff["content_height"] = host.content_height
            dic_motiff["thumbnail_url"] = host.thumbnail_url
            dic_motiff["location_latitude"] = host.location_latitude
            dic_motiff["location_longitude"] = host.location_longitude
            dic_motiff["creation_date"] = host.creation_date
            dic_motiff["creation_time"] = host.creation_time
            dic_motiff["mapsearch"] = host.mapsearch
            dic_motiff["duration"] = host.duration
            dic_motiff["share_with"] = host.share_with
            
            if (host.share_with == "Custom"){
                dic_motiff["share_array"] = host.share_array as NSArray
            }else{
                dic_motiff["share_array"] = []
            }
            
            dic_motiff["markasread_array"] = []
            dic_motiff["likes_count"] = 0
            dic_motiff["likes_array"] = []
            dic_motiff["comments_count"] = 0
            dic_motiff["comments_array"] = []
            
            array_temp_motiffs.insert(dic_motiff, at: 0)
            let array_new_motiffs = array_temp_motiffs as NSArray
            
            self.ref.child("motiffs").setValue(array_new_motiffs)
            
            onCompletion("success", nil)
        }) { (error) in
            onCompletion(nil, error)
            print(error.localizedDescription)
        }
    }
    
    func delete_Motiff(host: Host, onCompletion: @escaping ServiceResponse) -> Void{
        
        ref.child("motiffs").observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Get motiffs value
            let array_motiffs = snapshot.value as? NSArray ?? []
            let array_temp_motiffs = array_motiffs.mutableCopy() as! NSMutableArray
            
            // motiff
            for i in (0..<array_temp_motiffs.count){
                let dict: [String: Any] = array_temp_motiffs[i] as! [String : Any]
                let str_id: String = dict["id"] as! String
                
                if (str_id == host.id){
                    array_temp_motiffs.removeObject(at: i)
                    break
                }
            }
            
            let array_new_motiffs = array_temp_motiffs as NSArray
            
            self.ref.child("motiffs").setValue(array_new_motiffs)
            
            onCompletion("success", nil)
        }) { (error) in
            onCompletion(nil, error)
            print(error.localizedDescription)
        }
    }

    func update_Motiff_Map_Search(host: Host, onCompletion: @escaping ServiceResponse) -> Void{
        
        ref.child("motiffs").observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Get motiffs value
            let array_motiffs = snapshot.value as? NSArray ?? []
            let array_temp_motiffs = array_motiffs.mutableCopy() as! NSMutableArray
            
            // motiff
            for i in (0..<array_temp_motiffs.count){
                let dict: [String: Any] = array_temp_motiffs[i] as! [String : Any]
                let str_id: String = dict["id"] as! String
                var dic_motiff: [String: Any] = array_temp_motiffs[i] as! [String : Any]
                
                if (str_id == host.id){
                    dic_motiff["mapsearch"] = 0
                    
                    array_temp_motiffs.removeObject(at: i)
                    array_temp_motiffs.insert(dic_motiff, at: i)
                    break
                }
            }
            
            let array_new_motiffs = array_temp_motiffs as NSArray
            
            self.ref.child("motiffs").setValue(array_new_motiffs)
            
            onCompletion("success", nil)
        }) { (error) in
            onCompletion(nil, error)
            print(error.localizedDescription)
        }
    }

    func get_Motiff_With_ID(id: String, onCompletion: @escaping ServiceArrayResponse) -> Void{
        ref.child("motiffs").observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Get user value
            let array_motiffs = snapshot.value as? NSMutableArray ?? []
            var array_result: [Host] = []
            
            for i in (0..<array_motiffs.count){
                let dict: [String: Any] = array_motiffs[i] as! [String : Any]
                let host: Host = Host()
                
                host.initHostDataWithDictionary(dic_motiff: dict)
                if (host.id == id){
                    array_result.append(host)
                }
            }
            
            onCompletion(array_result as NSArray?, nil)
        }) { (error) in
            onCompletion(nil, error)
            print(error.localizedDescription)
        }
    }
    
    func get_Motiffs(user_id: String, onCompletion: @escaping ServiceArrayResponse) -> Void{
        ref.child("motiffs").observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Get user value
            let array_motiffs = snapshot.value as? NSMutableArray ?? []
            var array_result: [Host] = []
            
            for i in (0..<array_motiffs.count){
                let dict: [String: Any] = array_motiffs[i] as! [String : Any]
                let host: Host = Host()
                
                host.initHostDataWithDictionary(dic_motiff: dict)
                if (host.user_id == user_id){
                    array_result.append(host)
                }
            }
            
            //sort
            if (array_result.count > 0){
                for i in (0..<array_result.count-1){
                    var host: Host = array_result[i]
                    for j in (i..<array_result.count){
                        let host_compare: Host = array_result[j]
                        
                        if (host.id.compare(host_compare.id) == .orderedDescending){
                            
                        }else if (host.id.compare(host_compare.id) == .orderedAscending){
                            array_result.remove(at: i)
                            array_result.insert(host_compare, at: i)
                            
                            array_result.remove(at: j)
                            array_result.insert(host, at: j)
                            
                            host = host_compare
                        }
                    }
                }
            }
            
            onCompletion(array_result as NSArray?, nil)
        }) { (error) in
            onCompletion(nil, error)
            print(error.localizedDescription)
        }
    }
    
    func get_All_Motiffs_Map_Live(onCompletion: @escaping ServiceArrayResponse) -> Void{
        ref.child("motiffs").observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Get user value
            let array_motiffs = snapshot.value as? NSMutableArray ?? []
            var array_result: [Host] = []
            
            for i in (0..<array_motiffs.count){
                let dict: [String: Any] = array_motiffs[i] as! [String : Any]
                let host: Host = Host()
                
                host.initHostDataWithDictionary(dic_motiff: dict)
                if (host.mapsearch == 1){
                    let live_Date: Date = COMMON.get_Duration_Hours_from_UTC_Date_Time(string: host.creation_date + " " + host.creation_time, duration: host.duration)
                    
                    let current_UTC_Date: Date = COMMON.get_Real_Current_UTC_Date_Time()
                    
                    if (current_UTC_Date < live_Date){
                        array_result.append(host)
                    }
                }
            }
            
            //sort
            if (array_result.count > 0){
                for i in (0..<array_result.count-1){
                    var host: Host = array_result[i]
                    for j in (i..<array_result.count){
                        let host_compare: Host = array_result[j]
                        
                        if (host.id.compare(host_compare.id) == .orderedDescending){
                            
                        }else if (host.id.compare(host_compare.id) == .orderedAscending){
                            array_result.remove(at: i)
                            array_result.insert(host_compare, at: i)
                            
                            array_result.remove(at: j)
                            array_result.insert(host, at: j)
                            
                            host = host_compare
                        }
                    }
                }
            }
            
            onCompletion(array_result as NSArray?, nil)
        }) { (error) in
            onCompletion(nil, error)
            print(error.localizedDescription)
        }
    }
    
    //MARK: - Comment
    func upload_Comment(user: User, host: Host, comment: String, onCompletion: @escaping ServiceResponse) -> Void{
        
        ref.child("motiffs").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let whitespace = NSCharacterSet.whitespacesAndNewlines
            let trimmedString = (comment.trimmingCharacters(in: whitespace)) as String
            
            // Get motiffs value
            let array_motiffs = snapshot.value as? NSArray ?? []
            let array_temp_motiffs = array_motiffs.mutableCopy() as! NSMutableArray
            
            for i in (0..<array_temp_motiffs.count){
                let host_temp: Host = Host()
                var dic_motiff: [String: Any] = array_temp_motiffs[i] as! [String : Any]
                
                host_temp.initHostDataWithDictionary(dic_motiff: array_temp_motiffs[i] as! [String : Any])
                if (host_temp.id == host.id){
                    array_temp_motiffs.removeObject(at: i)
                    
                    // motiff
                    // Comment
                    var dic_comment: [String: Any] = [:]
                    dic_comment["motiff_user"] = host.user_id
                    dic_comment["motiff_id"] = host.id
                    dic_comment["user_id"] = user.id
                    dic_comment["username"] = user.username
                    dic_comment["avatar"] = user.avatar
                    dic_comment["comment_id"] = user.id + " " + COMMON.get_Current_UTC_Date() + " " + COMMON.get_Current_UTC_Time()
                    dic_comment["comment"] = trimmedString
                    dic_comment["date"] = COMMON.get_Current_UTC_Date()
                    dic_comment["time"] = COMMON.get_Current_UTC_Time()
                    dic_comment["following"] = ""
                    
                    var comment_temp_array: [Any] = []
                    for j in (0..<host_temp.comments_array.count){
                        let comment_temp: Comment = host_temp.comments_array[j]
                        comment_temp_array.append(comment_temp.getDictionaryWithComment())
                    }
                    
                    comment_temp_array.insert(dic_comment, at: 0)
                    
                    dic_motiff["comments_array"] = comment_temp_array as NSArray
                    array_temp_motiffs.insert(dic_motiff, at: i)
                }
            }
            
            
            let array_new_motiffs = array_temp_motiffs as NSArray
            
            self.ref.child("motiffs").setValue(array_new_motiffs)
            
            onCompletion("success", nil)
        }) { (error) in
            onCompletion(nil, error)
            print(error.localizedDescription)
        }
        
    }
    
    func delete_Comment(host: Host, comment: Comment, onCompletion: @escaping ServiceResponse) -> Void{
        
        ref.child("motiffs").observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Get motiffs value
            let array_motiffs = snapshot.value as? NSArray ?? []
            let array_temp_motiffs = array_motiffs.mutableCopy() as! NSMutableArray
            
            for i in (0..<array_temp_motiffs.count){
                let host_temp: Host = Host()
                var dic_motiff: [String: Any] = array_temp_motiffs[i] as! [String : Any]
                
                host_temp.initHostDataWithDictionary(dic_motiff: array_temp_motiffs[i] as! [String : Any])
                if (host_temp.id == host.id){
                    for j in (0..<host_temp.comments_array.count){
                        let comment_temp: Comment = host_temp.comments_array[j]
                        if (comment_temp.comment_id == comment.comment_id){
                            host_temp.comments_array.remove(at: j)
                            break
                        }
                    }
                    
                    array_temp_motiffs.removeObject(at: i)
                    
                    if (host_temp.comments_count > 0){
                        dic_motiff["comments_count"] = host_temp.comments_count - 1
                    }else{
                        dic_motiff["comments_count"] = host_temp.comments_count
                    }
                    
                    var comment_temp_array: [Any] = []
                    for j in (0..<host_temp.comments_array.count){
                        let comment_temp: Comment = host_temp.comments_array[j]
                        comment_temp_array.append(comment_temp.getDictionaryWithComment())
                    }
                    
                    dic_motiff["comments_array"] = comment_temp_array as NSArray
                    array_temp_motiffs.insert(dic_motiff, at: i)
                }
            }
            
            let array_new_motiffs = array_temp_motiffs as NSArray
            
            self.ref.child("motiffs").setValue(array_new_motiffs)
            
            onCompletion("success", nil)
        }) { (error) in
            onCompletion(nil, error)
            print(error.localizedDescription)
        }
    }
    
    //MARK: - Likes
    func upload_Like(user: User, host: Host, onCompletion: @escaping ServiceResponse) -> Void{
        
        ref.child("motiffs").observeSingleEvent(of: .value, with: { (snapshot) in

            // Get motiffs value
            let array_motiffs = snapshot.value as? NSArray ?? []
            let array_temp_motiffs = array_motiffs.mutableCopy() as! NSMutableArray
            
            for i in (0..<array_temp_motiffs.count){
                let host_temp: Host = Host()
                var dic_motiff: [String: Any] = array_temp_motiffs[i] as! [String : Any]
                
                host_temp.initHostDataWithDictionary(dic_motiff: array_temp_motiffs[i] as! [String : Any])
                if (host_temp.id == host.id){
                    array_temp_motiffs.removeObject(at: i)
                    
                    // motiff
                    // Like
                    var dic_like: [String: Any] = [:]
                    dic_like["motiff_id"] = host.id
                    dic_like["user_id"] = user.id
                    dic_like["username"] = user.username
                    dic_like["avatar"] = user.avatar
                    dic_like["like_or_not"] = 1
                    dic_like["date"] = COMMON.get_Current_UTC_Date()
                    dic_like["time"] = COMMON.get_Current_UTC_Time()
                    dic_like["type"] = ""
                    dic_like["following"] = ""
                    
                    var like_temp_array: [Any] = []
                    for j in (0..<host_temp.likes_array.count){
                        let like_temp: Like_User = host_temp.likes_array[j]
                        like_temp_array.append(like_temp.getDictionaryWithLikeData())
                    }
                    
                    like_temp_array.insert(dic_like, at: 0)
                    
                    dic_motiff["likes_array"] = like_temp_array as NSArray
                    dic_motiff["likes_count"] = host_temp.likes_count + 1
                    array_temp_motiffs.insert(dic_motiff, at: i)
                }
            }
            
           
            let array_new_motiffs = array_temp_motiffs as NSArray
            
            self.ref.child("motiffs").setValue(array_new_motiffs)
            
            onCompletion("success", nil)
        }) { (error) in
            onCompletion(nil, error)
            print(error.localizedDescription)
        }
        
    }
    
    func delete_Like(user: User, host: Host, onCompletion: @escaping ServiceResponse) -> Void{
        
        ref.child("motiffs").observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Get motiffs value
            let array_motiffs = snapshot.value as? NSArray ?? []
            let array_temp_motiffs = array_motiffs.mutableCopy() as! NSMutableArray
            
            for i in (0..<array_temp_motiffs.count){
                let host_temp: Host = Host()
                var dic_motiff: [String: Any] = array_temp_motiffs[i] as! [String : Any]
                
                host_temp.initHostDataWithDictionary(dic_motiff: array_temp_motiffs[i] as! [String : Any])
                if (host_temp.id == host.id){
                    for j in (0..<host_temp.likes_array.count){
                        let like_temp: Like_User = host_temp.likes_array[j]
                        if (like_temp.user_id == user.id){
                            host_temp.likes_array.remove(at: j)
                            break
                        }
                    }
                    
                    array_temp_motiffs.removeObject(at: i)
                    
                    if (host_temp.likes_count > 0){
                        dic_motiff["likes_count"] = host_temp.likes_count - 1
                    }else{
                        dic_motiff["likes_count"] = 0
                    }
                    
                    var like_temp_array: [Any] = []
                    for j in (0..<host_temp.likes_array.count){
                        let like_temp: Like_User = host_temp.likes_array[j]
                        like_temp_array.append(like_temp.getDictionaryWithLikeData())
                    }
                    
                    dic_motiff["likes_array"] = like_temp_array as NSArray
                    array_temp_motiffs.insert(dic_motiff, at: i)
                }
            }
            
            let array_new_motiffs = array_temp_motiffs as NSArray
            
            self.ref.child("motiffs").setValue(array_new_motiffs)
            
            onCompletion("success", nil)
        }) { (error) in
            onCompletion(nil, error)
            print(error.localizedDescription)
        }
    }
    
    //MARK: - MakeAsRead
    func upload_Read(user_id: String, host: Host, onCompletion: @escaping ServiceResponse) -> Void{
        
        ref.child("motiffs").observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Get motiffs value
            let array_motiffs = snapshot.value as? NSArray ?? []
            let array_temp_motiffs = array_motiffs.mutableCopy() as! NSMutableArray
            
            for i in (0..<array_temp_motiffs.count){
                let host_temp: Host = Host()
                var dic_motiff: [String: Any] = array_temp_motiffs[i] as! [String : Any]
                
                host_temp.initHostDataWithDictionary(dic_motiff: array_temp_motiffs[i] as! [String : Any])
                if (host_temp.id == host.id){
                    array_temp_motiffs.removeObject(at: i)
                    
                    // motiff
                    // Reads_Array
                    var reads_temp_array: [Any] = []
                    for j in (0..<host_temp.markasread_array.count){
                        let reads_temp: [String: String] = host_temp.markasread_array[j] as! [String : String]
                        reads_temp_array.append(reads_temp)
                    }
                    
                    let read: [String: String] = ["id": user_id]
                    reads_temp_array.insert(read, at: 0)
                    
                    dic_motiff["markasread_array"] = reads_temp_array as NSArray
                    array_temp_motiffs.insert(dic_motiff, at: i)
                }
            }
            
            
            let array_new_motiffs = array_temp_motiffs as NSArray
            
            self.ref.child("motiffs").setValue(array_new_motiffs)
            
            onCompletion("success", nil)
        }) { (error) in
            onCompletion(nil, error)
            print(error.localizedDescription)
        }
        
    }
}
