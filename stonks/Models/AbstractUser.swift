//
//  AbstractUser.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 13.06.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import SwiftyJSON

class User {
    var id:Int, name:String
    
    var likedMixes = Set<Int>(), dislikedMixes = Set<Int>(), favedMixes = Set<Mix>()
    var favedTikers = [TicketResponseWithDelta]()
    
    init(data:JSON) {
//        self.phone = data["phone"].stringValue
//        self.isValid = data["isvalidated"].boolValue
//        self.isOnValidation = data["is_on_validation"].boolValue
        id = data["id"].intValue
        name = data["name"].stringValue
        
        likedMixes = Set<Int>(data["liked_mixes"].arrayValue.map({$0.intValue}))
        dislikedMixes = Set<Int>(data["disliked_mixes"].arrayValue.map({$0.intValue}))
        
        for item in data["favourite_mixes"].arrayValue {
            favedMixes.insert(Mix(data: item))
        }
        
        for item in data["favourite_stocks"].arrayValue {
            favedTikers.append(TicketResponseWithDelta(data: item))
        }
            //favedMixes = Set<Int>(data["favourite_mixes"].arrayValue.map({$0.intValue}))
//        self.inn = data["inn"].string
//        self.email = data["email"].string
//        self.isPhiz = data["isPhiz"].bool
    }
    
//    init(phone:String, isValid:Bool, isOnValidation:Bool, name:String?, inn:String?, email:String?, isPhiz:Bool?) {
//        self.phone = phone
//        self.isValid = isValid
//        self.isOnValidation = isOnValidation
//        self.name = name
//        self.inn = inn
//        self.email = email
//        self.isPhiz = isPhiz
//    }
    
    init(id:Int, name:String) {
        self.id = id
        self.name = name
    }
    
//    func isSimilar(a:AbstractUser) -> Bool {
//        if a.phone == phone, a.isValid == isValid, a.isOnValidation == isOnValidation, a.email == email, a.inn == inn, a.name == name, a.isPhiz == isPhiz {
//            return true
//        }
//        return false
//    }
}

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
}

