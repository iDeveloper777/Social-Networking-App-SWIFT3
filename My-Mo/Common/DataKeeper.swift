//
//  DataKeeper.swift
//  My-Mo
//
//  Created by iDeveloper on 12/30/16.
//  Copyright © 2016 iDeveloper. All rights reserved.
//

import Foundation

class DataKeeper: NSObject{
    let userdefault = UserDefaults.standard
    
    //MARK: - Logined
    func getLogined() -> String{
        var retVal = ""
        
        if ((userdefault.object(forKey: "logined")) != nil){
            retVal = userdefault.object(forKey: "logined") as! String
        }
        
        return retVal
    }
    
    func updateLogined(logined: String){
        userdefault.set(logined, forKey: "logined")
        userdefault.synchronize()
    }

//----- User Info-----
    //MARK: - User Name
    func getUserName() -> String{
        var retVal = ""
        
        if ((userdefault.object(forKey: "username")) != nil){
            retVal = userdefault.object(forKey: "username") as! String
        }
        
        return retVal
    }
    
    func updateUserName(username: String){
        userdefault.set(username, forKey: "username")
        userdefault.synchronize()
    }
    
    //MARK: - Password
    func getPassword() -> String{
        var retVal = ""
        
        if ((userdefault.object(forKey: "password")) != nil){
            retVal = userdefault.object(forKey: "password") as! String
        }
        
        return retVal
    }
    
    func updatePassword(password: String){
        userdefault.set(password, forKey: "password")
        userdefault.synchronize()
    }

//Motiff Like Array
    func getMotiffLikes(){
        var arr: [String] = []
        let str_Parameter = "motiff_likes_" + String(USER.id)
        
        if ((userdefault.object(forKey: str_Parameter)) != nil){
            let str_Likes = userdefault.object(forKey: str_Parameter) as! String
            
            arr = str_Likes.components(separatedBy: ",")
        }
        
        appDelegate.array_Motiff_Likes = []
        appDelegate.array_Motiff_Likes = arr
    }
    
    func updateMotiffLikes(arr: [String]){
        let str_Likes = arr.joined(separator: ",")
        let str_Parameter = "motiff_likes_" + String(USER.id)
        
        userdefault.set(str_Likes, forKey: str_Parameter)
        userdefault.synchronize()
    }

    //MARK: - Password
    func getContactUploaded() -> String{
        var retVal = "NO"
        
        if ((userdefault.object(forKey: "ContactUploaded")) != nil){
            retVal = userdefault.object(forKey: "ContactUploaded") as! String
        }
        
        return retVal
    }
    
    func updateContactUploaded(value: String){
        userdefault.set(value, forKey: "ContactUploaded")
        userdefault.synchronize()
    }

}
