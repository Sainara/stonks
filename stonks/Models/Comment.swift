//
//  Comment.swift
//  MixApp
//
//  Created by Ян Мелоян on 08.11.2020.
//

import SwiftDate
import SwiftyJSON

struct Comment {
    var id:Int, mixId:Int, creatorId:Int, creatorName:String, content:String, createAt:Date
    
    init(data:JSON) {
        id = data["comment_id"].intValue
        mixId = data["mix_id"].intValue
        creatorId = data["user_id"].intValue
        creatorName = data["user_name"].stringValue
        content = data["message"].stringValue
        createAt = Date(timeIntervalSince1970: TimeInterval(data["created_at"].intValue / 1000))
    }
}

extension Comment: Comparable {
    static func < (lhs: Comment, rhs: Comment) -> Bool {
        lhs.createAt > rhs.createAt
    }
}
