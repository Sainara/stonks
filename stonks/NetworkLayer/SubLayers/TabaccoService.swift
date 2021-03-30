//
//  TabaccoService.swift
//  MixApp
//
//  Created by Ян Мелоян on 17.11.2020.
//

import SwiftyJSON
import Alamofire

class TabaccoService: MixAppNetwork {
    
    static let main = TabaccoService()
    
    override private init() {}
    
    func getTabaccoWithSearchQuery(query:String, complition: @escaping (Result<[Tabaco], NetworkError>)->Void) {
        
        guard let headers = self.getHTTPHeaders(rawHeaders: [.accept]) else {
            complition(.failure(.primaryError))
            return
        }
        
        let parameters = ["match" : query.split(separator: " ").joined(separator: "_")]
        
        AF.request(MixAppNetwork.tabaccosUrl, parameters: parameters, headers: headers).validate(statusCode: 200..<300).responseJSON { response in
            print(response.debugDescription)
            switch response.result {
            case .success(let value):
                let json = JSON(value)

                var items = [Tabaco]()
                for rawItem in json["data"]["tobaccos"].arrayValue {
                    items.append(Tabaco(data: rawItem))
                }
                complition(.success(items))
            case .failure(let error):
                print(error.localizedDescription)
                complition(.failure(.primaryError))
            }
        }
    }
}

