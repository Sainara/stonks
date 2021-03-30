//
//  FilterOptionItem.swift
//  MixApp
//
//  Created by Ян Мелоян on 20.12.2020.
//

struct FilterOptionItem {
    var name: String, type: FilterOptionType, isSelected: Bool = false
    
    init(name: String, type: FilterOptionType) {
        self.name = name
        self.type = type
    }
}

enum FilterOptionType: String {
    case taste, producer
}


