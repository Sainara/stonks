//
//  Tabaco.swift
//  MixApp
//
//  Created by Ян Мелоян on 05.11.2020.
//

import SwiftyJSON

struct Tabaco {
    var id:Int, producer:String, taste:[String], strength:Int, name:String
    
    init(data:JSON) {
        id = data["id"].intValue
        name = data["name"].stringValue
        producer = data["producer"].stringValue
        taste = Self.initTastes(data: data["tastes"])
        strength = data["strength"].intValue
    }
    
    private static func initTastes(data:JSON) -> [String] {
        var result: [String] = []
        for item in data.arrayValue {
            result.append(item.stringValue)
        }
        return result
    }
    
    func getFormatedName() -> String {
        "\(producer) - \(name) (\(taste.joined(separator: ", ")))"
    }
    
//    init(id:Int, name:String) {
//        self.id = id
//        self.name = name
//    }
}

extension Tabaco: Hashable {
    var hashValue: Int {
        id
    }
}
