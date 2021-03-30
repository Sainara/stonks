//
//  TicketResponse.swift
//  stonks
//
//  Created by Artem Meloyan on 12/15/20.
//

import SwiftyJSON

struct TicketResponse {
    var company: String,
        country: String,
        industry: String,
        employees: Int,
        price: Double,
        pe_ratio: Double,
        market_capitalization: String,
        ebitda: Double,
        eps: Double,
        dividend_value: Double,
        devidend_percentage: Double,
        volume: String,
        ticker: String,
        fiveMinChart: [CandlestickСhartItem],
        fiveteenMinChart: [CandlestickСhartItem]
    var consistence: String
    
    
    init(data: JSON) {
        self.company = data["company"].stringValue
        self.country = data["country"].stringValue
        self.ticker = data["ticker"].stringValue
        self.industry = data["industry"].stringValue
        self.employees = data["employees"].intValue
        self.price = data["price"].doubleValue
        self.pe_ratio = data["pe_ratio"].doubleValue
        self.market_capitalization = data["market_capitalization"].stringValue
        self.ebitda = data["ebitda"].doubleValue
        self.eps = data["eps"].doubleValue
        self.dividend_value = data["dividend_value"].doubleValue
        self.devidend_percentage = data["devidend_percentage"].doubleValue
        self.volume = data["volume"].stringValue
        
        self.fiveMinChart = data["chart_5min"].arrayValue.map({ CandlestickСhartItem(data: $0) })
        self.fiveteenMinChart = data["chart_15min"].arrayValue.map({ CandlestickСhartItem(data: $0) })
        
        consistence = data["consistence"].stringValue
    }
}

struct TicketResponseWithDelta: Equatable {
    
    static func == (lhs: TicketResponseWithDelta, rhs: TicketResponseWithDelta) -> Bool {
        lhs.ticket.company == rhs.ticket.company
    }
    
    var ticket: TicketResponse,
        delta_percent: Double,
        delta_value: Double,
        initial_price: Double,
        added_at: Int
    
    init(data: JSON) {
        self.ticket = TicketResponse(data: data["stock_overview"])
        self.delta_percent = data["delta_percent"].doubleValue
        self.delta_value = data["delta_value"].doubleValue
        self.initial_price = data["initial_price"].doubleValue
        self.added_at = data["added_at"].intValue
    }
}
