//
//  Following.swift
//  My-Mo
//
//  Created by iDeveloper on 3/4/17.
//  Copyright © 2017 iDeveloper. All rights reserved.
//

import Foundation
import SwiftyJSON
import Firebase

class Following: NSObject{
    var id: String = ""
    var following_id: String = ""
    
    func initFollowingData(){
        id = ""
        following_id = ""
    }
    
    func initFollowingDataWithDictionary(value: NSDictionary?){
        if (value != nil){
            self.id = value?["id"] as? String ?? ""
            self.following_id = value?["following_id"] as? String ?? ""
        }
    }
}
