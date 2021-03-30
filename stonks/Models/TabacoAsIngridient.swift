//
//  TabacoAsIngridient.swift
//  MixApp
//
//  Created by Ян Мелоян on 05.11.2020.
//

import SwiftyJSON

struct TabacoAsIngridient {
    var tabaco:Tabaco, percentage:Int
    
    init(data:JSON) {
        tabaco = Tabaco(data: data["tobacco"])
        percentage = data["proportion"].intValue
    }
    
    init(tabaco:Tabaco, percentage:Int) {
        self.tabaco = tabaco
        self.percentage = percentage
    }
}

extension TabacoAsIngridient: Hashable {
    var hashValue: Int {
        tabaco.id
    }
}
