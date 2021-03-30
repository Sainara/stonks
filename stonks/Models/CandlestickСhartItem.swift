//
//  CandlestickСhartItem.swift
//  stonks
//
//  Created by Artem Meloyan on 3/23/21.
//

import SwiftyJSON

struct CandlestickСhartItem {
     
    var open: Double,
        close: Double,
        low: Double,
        high: Double,
        timestamp: Int
    
    init(data: JSON) {
        self.open = data["open"].doubleValue
        self.close = data["close"].doubleValue
        self.low = data["low"].doubleValue
        self.high = data["high"].doubleValue
        self.timestamp = data["timestamp"].intValue
    }
}
