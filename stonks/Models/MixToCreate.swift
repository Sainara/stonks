//
//  MixToCreate.swift
//  MixApp
//
//  Created by Ян Мелоян on 17.11.2020.
//

import Foundation

struct MixToCreate: Encodable {
    var taste:String, description:String, instructions:String, ingredients:[MixToCreateIngridient]
}

struct MixToCreateIngridient: Encodable {
    var tobacco_id:Int, proportion:Int
}
