//
//  Mix.swift
//  MixApp
//
//  Created by Ян Мелоян on 05.11.2020.
//

import SwiftyJSON

class Mix {
    var id:Int, name:String, likes:Int, dislikes:Int, creatorID:Int, description:String, instruction:String, imageUrl:String, color:String, created_at:Date
    
    var tabacos:[TabacoAsIngridient] = []
    var comments:[Comment] = []
    
    init(data:JSON) {
        
        print(data)
        
        id = data["id"].intValue
        name = data["taste"].stringValue
        likes = data["likes"].intValue
        dislikes = data["dislikes"].intValue
        creatorID = data["creator_id"].intValue
        description = data["description"].stringValue
        instruction = data["instruction"].stringValue
        imageUrl = data["image_url"].stringValue
        color = data["image_most_color"].stringValue
        
        created_at = Date(timeIntervalSince1970: TimeInterval(data["created_at"].intValue))
        
        for comment in data["comments"].arrayValue {
            comments.append(Comment(data: comment))
        }
        // MARK: Remove next line
        comments.sort()
        for ingridient in data["ingredients"].arrayValue {
            tabacos.append(TabacoAsIngridient(data: ingridient))
        }
        
    }
    
    init(id:Int, name:String, likes:Int, dislikes:Int, creatorID:Int, description:String, instruction:String, imageUrl:String, color:String, created_at:Date) {
        self.id = id
        self.name = name
        self.likes = likes
        self.dislikes = dislikes
        self.creatorID = creatorID
        self.description = description
        self.instruction = instruction
        self.imageUrl = imageUrl
        self.color = color
        self.created_at = created_at
    }
    
    var getFormatedTabacos:String {
        return tabacos.map({$0.tabaco.name}).joined(separator: " * ")
    }
}

extension Mix: Hashable {
    static func == (lhs: Mix, rhs: Mix) -> Bool {
        lhs.id == rhs.id
    }
    
    var hashValue: Int {
        id
    }
}

extension Mix: Comparable {
    static func < (lhs: Mix, rhs: Mix) -> Bool {
        lhs.created_at < rhs.created_at
    }
}
