//
//  FavoritesResponse.swift
//  stonks
//
//  Created by Artem Meloyan on 2/8/21.
//

import Foundation

struct FavoritesResponseWrapped: Codable {
    var data: FavoritesResponse
}

struct FavoritesResponse: Codable {
    var tickers: [String]
}
