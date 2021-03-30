//
//  ViewController.swift
//  stonks
//
//  Created by Artem Meloyan on 12/15/20.
//

import Charts
import UIKit

class ViewController: TommyViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var ticketInput: UITextField!
    @IBOutlet weak var secondTicketInput: UITextField!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var secondPriceLabel: UILabel!
    @IBOutlet weak var coreStack: UIStackView!
    
    @IBOutlet weak var firstFavBut: UIButton!
    @IBOutlet weak var secondFavBut: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let capitaliztion = InfoLabel(title: "Капитализация", subtitle: "Стоимость компании")
    let ebitda = InfoLabel(title: "Объем", subtitle: "Кол-во акций")
    let pe = InfoLabel(title: "P/E", subtitle: "Цена акции / прибыль")
    let eps = InfoLabel(title: "Рост EPS", subtitle: "Средний рост за 5 лет")
    
    var pokazateli: [InfoLabel] = []
    
    var consistenceValue: UUID!
    
    var firstInput: TicketResponse?
    var secondInput: TicketResponse?
    
    let chart = LineChartView()
    
    
    let data = LineChartData()
    
    var line1 = LineChartDataSet()
    var line2 = LineChartDataSet()
    
    let segmentedControl = UISegmentedControl()
    
    var chartMode: ChartMode = .fiveMin
    
    enum ChartMode {
        case fiveMin, fiveteenMin
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //priceLabel.textColor = UIColor(red: 18/255, green: 18/255, blue: 18/255, alpha: 1)
        
        segmentedControl.insertSegment(action:
                                        UIAction(title: "5 minute",
                                                 state: .on,
                                                 handler: { [self] _ in
                                                    self.chartMode = .fiveMin
                                                    reloadChart()
                                                 }),
                                       at: 0,
                                       animated: false)
        
        segmentedControl.insertSegment(action:
                                        UIAction(title: "15 minute",
                                                 state: .off,
                                                 handler: { [self] _ in
                                                    self.chartMode = .fiveteenMin
                                                    reloadChart()
                                                 }),
                                       at: 1,
                                       animated: false)
        segmentedControl.selectedSegmentIndex = 0
        coreStack.addArrangedSubview(segmentedControl)
        
        coreStack.addArrangedSubview(chart)
        
        chart.snp.makeConstraints { (make) in
            make.height.equalTo(300)
            make.width.equalToSuperview()
        }
        
        let l = chart.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.drawInside = true
        l.xEntrySpace = 7
        l.yEntrySpace = 0
        l.yOffset = 0
        
        navigationItem.title = "Deutsche Bank"
        chart.noDataText = "Введите тикеры"
        chart.xAxis.labelCount = 5
        chart.borderColor = .clear
        
        ticketInput.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        secondTicketInput.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        
        pokazateli = [capitaliztion, ebitda, pe, eps]
        
        pokazateli.forEach({coreStack.addArrangedSubview($0)})
        
        ticketInput.tag = 1
        secondTicketInput.tag = 0
    }

    func getAndUpdatePrice(with ticket: String, _ tag: Int) {
        consistenceValue = .init()
        
        NetworkLayer.shared.getBaseInformation(about: ticket, consistence: consistenceValue.uuidString) { result in
            if let consist = result.0, consist == self.consistenceValue.uuidString {
                self.activityIndicator.stopAnimating()
                
                switch result.1 {
                case .success(let ticketResponse):
                    if tag == 0 {
                        self.firstInput = ticketResponse
                    } else {
                        self.secondInput = ticketResponse
                    }
                    self.setLabelText(text: "\(ticketResponse.price)$", tag: tag)
                    self.capitaliztion.update(with: "\(ticketResponse.market_capitalization) $", tag)
                    self.ebitda.update(with: "\(ticketResponse.volume)", tag)
                    self.pe.update(with: "\(ticketResponse.pe_ratio)", tag)
                    self.eps.update(with: "\(ticketResponse.eps)%", tag)
                    switch self.chartMode {
                    case .fiveMin:
                        self.drawChart(chartData: ticketResponse.fiveMinChart, name: ticketResponse.company, at: tag)
                    case .fiveteenMin:
                        self.drawChart(chartData: ticketResponse.fiveteenMinChart, name: ticketResponse.company, at: tag)
                    }
                    
                case .failure(let error):
                    print(error)
                    self.setLabelText(text: "Не могу найти тикер", tag: tag)
                }
            }
        }
    }
    
    @objc func textChanged(_ textField: UITextField) {
        if textField.text!.count >= 3 {
            getAndUpdatePrice(with: textField.text!.trimmingCharacters(in: .whitespacesAndNewlines), textField.tag)
            activityIndicator.startAnimating()
            
            setLabelText(text: "", tag: textField.tag)
        } else {
            
            setLabelText(text: "Жду тикер", tag: textField.tag)
            activityIndicator.stopAnimating()
        }
        resetData(at: textField.tag)
    }
    
    @IBAction func tapFirstFav(_ sender: Any) {
        sendToFav(value: firstInput)
    }
    
    @IBAction func tapSecondFav(_ sender: Any) {
        sendToFav(value: secondInput)
    }
    
    func sendToFav(value: TicketResponse?) {
        guard let value = value else {
            return
        }
        
        MixService.main.addToFav(company: value.company) { _ in }
    }
    
    func setLabelText(text: String, tag: Int) {
        switch tag {
        case 0:
            self.priceLabel.text = text
        default:
            self.secondPriceLabel.text = text
        }
    }
    
    func drawChart(chartData: [CandlestickСhartItem], name: String, at index: Int) {
        var lineChartEntry = [ChartDataEntry]()
        var lineData = [String]()
        
        for i in 0..<chartData.count {
            let value = ChartDataEntry(x: Double(i), y: (chartData[i].open + chartData[i].close) / 2) // here we set the X and Y status in a data chart entry
            lineChartEntry.append(value)
            lineData.append(Date(milliseconds: chartData[i].timestamp).toString(.time(.short)))
        }// here we add it to the data set.
        
        
        if index == 0 {
            line1 = LineChartDataSet(entries: lineChartEntry, label: name)
            line1.drawCirclesEnabled = false
            line1.setColor(.coreBlue)
            data.addDataSet(line1)
                        
        } else {
            line2 = LineChartDataSet(entries: lineChartEntry, label: name)
            line2.drawCirclesEnabled = false
            line2.setColor(.redColor)
            data.addDataSet(line2)
        }
        
        chart.xAxis.granularity = 1.0
        
        
        
        chart.data = data
        
        chart.xAxis.valueFormatter = IndexAxisValueFormatter(values: lineData)
    }
    
    func reloadChart() {
        resetAllChart()
        switch chartMode {
        case .fiveMin:
            if let firstInput = firstInput {
                drawChart(chartData: firstInput.fiveMinChart, name: firstInput.company, at: 0)
            }
            if let secondInput = secondInput {
                drawChart(chartData: secondInput.fiveMinChart, name: secondInput.company, at: 1)
            }
        case .fiveteenMin:
            if let firstInput = firstInput {
                drawChart(chartData: firstInput.fiveteenMinChart, name: firstInput.company, at: 0)
            }
            if let secondInput = secondInput {
                drawChart(chartData: secondInput.fiveteenMinChart, name: secondInput.company, at: 1)
            }
        }
    }
    
    func resetAllChart() {
        data.removeDataSet(line1)
        data.removeDataSet(line2)
        chart.data = data
    }
    
    func resetData(at tag: Int) {
        self.setLabelText(text: "-", tag: tag)
        self.capitaliztion.update(with: "-", tag)
        self.ebitda.update(with: "-", tag)
        self.pe.update(with: "-", tag)
        self.eps.update(with: "-", tag)
        
        if tag == 0 {
            data.removeDataSet(line1)
        } else {
            data.removeDataSet(line2)
        }
        chart.data = data
    }
}


extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
