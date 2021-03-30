//
//  TickerMainPage.swift
//  stonks
//
//  Created by Artem Meloyan on 3/23/21.
//

import Charts
import UIKit

class TickerMainPage: TommyStackViewController {
    
    let ticker: TicketResponseWithDelta
    
    let chart = CandleStickChartView()
    var data = CandleChartData()
    
    let capitaliztion = InfoLabel(title: "Капитализация", subtitle: "Стоимость компании")
    let ebitda = InfoLabel(title: "Объем", subtitle: "Кол-во акций")
    let pe = InfoLabel(title: "P/E", subtitle: "Цена акции / прибыль")
    let eps = InfoLabel(title: "Рост EPS", subtitle: "Средний рост за 5 лет")
    
    var chartMode: ChartMode = .fiveMin
    
    enum ChartMode {
        case fiveMin, fiveteenMin
    }
    
    var pokazateli: [InfoLabel] = []
    
    init(ticker: TicketResponseWithDelta) {
        self.ticker = ticker
        
        super.init(nibName: nil, bundle: nil)
        
        title = ticker.ticket.company
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupChart()
        
        self.capitaliztion.update(with: "\(ticker.ticket.market_capitalization) $", 0)
        self.ebitda.update(with: "\(ticker.ticket.volume)", 0)
        self.pe.update(with: "\(ticker.ticket.pe_ratio)", 0)
        self.eps.update(with: "\(ticker.ticket.eps)%", 0)
        
        chart.noDataText = "Загрузка..."
    }
    
    func setupView() {
        stackView.addArrangedSubview(chart)
        
        chart.snp.makeConstraints { (make) in
            make.height.equalTo(400)
            make.width.equalToSuperview()
        }
        
        pokazateli = [capitaliztion, ebitda, pe, eps]
        
        pokazateli.forEach({addWidthArrangedSubView(view: $0, offsets: 0)})
    }
    
    func setupChart() {
        
        let consistenceValue = UUID()
        
        NetworkLayer.shared.getBaseInformation(about: ticker.ticket.ticker, consistence: consistenceValue.uuidString) { result in
            if let consist = result.0, consist == consistenceValue.uuidString {
               // self.activityIndicator.stopAnimating()
                
                switch result.1 {
                case .success(let ticketResponse):
                    switch self.chartMode {
                    case .fiveMin:
                        self.buildChart(chartData: ticketResponse.fiveMinChart)
                    case .fiveteenMin:
                        self.buildChart(chartData: ticketResponse.fiveteenMinChart)
                    }
                    
                case .failure(let error):
                    print(error)
                    //self.setLabelText(text: "Не могу найти тикер", tag: tag)
                }
            }
        }
        
    }
    
    func buildChart(chartData: [CandlestickСhartItem]) {
        var lineChartEntry = [CandleChartDataEntry]()
        var lineDate = [String]()
                
        for i in 0..<chartData.count {
            let value = CandleChartDataEntry(
                x: Double(i),
                shadowH: chartData[i].high,
                shadowL: chartData[i].low,
                open: chartData[i].open,
                close: chartData[i].close,
                data: chartData[i].timestamp
            )
            lineChartEntry.append(value)
            lineDate.append(Date(milliseconds: chartData[i].timestamp).toString(.time(.short)))
        }// here we add it to the data set
        
        
        let line1 = CandleChartDataSet(entries: lineChartEntry, label: "")
        line1.shadowColorSameAsCandle = true
        line1.increasingColor = .greenColor
        line1.decreasingColor = .redColor
        data.addDataSet(line1)
        
        chart.xAxis.valueFormatter = IndexAxisValueFormatter(values: lineDate)
        
        chart.data = data
    }
}
