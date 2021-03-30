//
//  SearchAndFilterService.swift
//  MixApp
//
//  Created by Ян Мелоян on 20.12.2020.
//

import SwiftyJSON
import Alamofire

class SearchAndFilterService: MixAppNetwork {
    
    static let main = SearchAndFilterService()
    
    override private init() {}
    
    func getSearchOptions(type: FilterOptionType, complition: @escaping (Result<[FilterOptionItem], NetworkError>)->Void) {
        
        guard let headers = self.getHTTPHeaders(rawHeaders: [.accept]) else {
            complition(.failure(.primaryError))
            return
        }
        
        AF.request(MixAppNetwork.filterOptionsUrl, headers: headers).validate(statusCode: 200..<300).responseJSON { response in
            print(response.debugDescription)
            switch response.result {
            case .success(let value):
                let json = JSON(value)

                var items = [FilterOptionItem]()
                
                switch type {
                case .taste:
                    for rawItem in json["data"]["tastes"].arrayValue {
                        items.append(FilterOptionItem(name: rawItem.stringValue, type: .taste))
                    }
                case .producer:
                    for rawItem in json["data"]["producers"].arrayValue {
                        items.append(FilterOptionItem(name: rawItem.stringValue, type: .producer))
                    }
                }
                complition(.success(items))
            case .failure(let error):
                print(error.localizedDescription)
                complition(.failure(.primaryError))
            }
        }
    }
    
    func getMixesWithSearchOptionsAndQuery(query:String, options:[FilterOptionItem], complition: @escaping (Result<[Mix], NetworkError>)->Void) {
        guard let headers = self.getHTTPHeaders(rawHeaders: [.accept]) else {
            complition(.failure(.tokenError))
            return
        }
        
        var parameters = [String:String]()
        
        if !query.isEmpty {
            parameters["match"] = query.replacingOccurrences(of: " ", with: "_")
        }
        
        var tastesOptions: [String] = []
        var producerOptions: [String] = []
        
        for option in options {
            switch option.type {
            case .taste:
                tastesOptions.append(option.name.replacingOccurrences(of: " ", with: "_"))
            case .producer:
                producerOptions.append(option.name.replacingOccurrences(of: " ", with: "_"))
            }
        }
        
        if !tastesOptions.isEmpty {
            parameters["taste"] = tastesOptions.joined(separator: "+")
        }
        if !producerOptions.isEmpty {
            parameters["producer"] = producerOptions.joined(separator: "+")
        }
        
        AF.request(MixAppNetwork.mixesUrl, parameters: parameters, headers: headers).validate(statusCode: 200..<300).responseJSON { response in
            
            print(response.debugDescription)
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                var items = [Mix]()
                for rawItem in json["data"]["mixes"].arrayValue {
                    items.append(Mix(data: rawItem))
                }
                complition(.success(items))
            case .failure(let error):
                print(error.localizedDescription)
                complition(.failure(.primaryError))
            }
        }
        
    }
}
