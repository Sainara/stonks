//
//  NetworkLayer.swift
//  stonks
//
//  Created by Artem Meloyan on 2/8/21.
//

import Alamofire
import SwiftyJSON

class NetworkLayer {
    
    static let shared = NetworkLayer()
    
    let baseAPI = "https://vast-mesa-42456.herokuapp.com/api/"
    let deviceUUID: String
    
    private init() {
        deviceUUID = UIDevice.current.identifierForVendor?.uuidString ?? ""
    }
    
    func getBaseInformation(about ticker: String, consistence: String, complition: @escaping ((String?, Result<TicketResponse, NetworkError>)) -> Void) {
        
        let parameters = ["ticker" : ticker, "consistence": consistence]
        
        AF.request("\(baseAPI)overview", parameters: parameters).validate().responseJSON { response in
            print(response.debugDescription)
            switch response.result {
            
            case .success(let rawData):
                let json = JSON(rawData)
                
                let ticker = TicketResponse(data: json["data"])
                
                complition((ticker.consistence ,.success(ticker)))
            case .failure(let error):
                complition((nil, .failure(.primaryError)))
                debugPrint(error)
            }
        }
    }
    
    func getFavs(complition: @escaping (Result<FavoritesResponse, NetworkError>) -> Void) {
        
        let parameters = ["device_id" : deviceUUID]
        
        AF.request("\(baseAPI)favourites", parameters: parameters).validate().responseJSON { response in
            print(response.debugDescription)
            switch response.result {
            case .success(let rawData):
                
                let json = JSON(rawData)
                
                
                var favoritesResponse: [String] = []
                for item in json["data"]["tickers"].arrayValue {
                    favoritesResponse.append(item.stringValue)
                }
                complition(.success(FavoritesResponse(tickers: favoritesResponse)))
                
            case .failure(let error):
                complition(.failure(.primaryError))
                debugPrint(error)
            }
        }
    }
    
    func addToFavs(ticker: String, complition: @escaping (Result<Bool, NetworkError>) -> Void) {
        
        let parameters = ["device_id" : deviceUUID, "ticker": ticker]
        
        AF.request("\(baseAPI)favourites", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON {
            response in
            print(response.debugDescription)
            switch response.result {
            case .success( _):
                complition(.success(true))
            case .failure(let error):
                complition(.failure(.primaryError))
                debugPrint(error)
            }
        }
    }
    
    func removeFromFavs(ticker: String, complition: @escaping (Result<Bool, NetworkError>) -> Void) {
        
        let parameters = ["device_id" : deviceUUID, "ticker": ticker]
        
        AF.request("\(baseAPI)favourites", method: .delete, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON { response in
            print(response.debugDescription)
            switch response.result {
            case .success( _):
                complition(.success(true))
            case .failure(let error):
                complition(.failure(.primaryError))
                debugPrint(error)
            }
        }
    }
}
