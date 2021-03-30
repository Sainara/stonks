//
//  MixService.swift
//  MixApp
//
//  Created by Ян Мелоян on 05.11.2020.
//

import SwiftyJSON
import Alamofire

class MixService: MixAppNetwork {
    
    static let main = MixService()
    
    override private init() {}
    
    func getMixes(complition: @escaping (Result<[Mix], NetworkError>)->Void) {
        
        guard let headers = self.getHTTPHeaders(rawHeaders: [.accept]) else {
            complition(.failure(.tokenError))
            return
        }
        
        AF.request(MixAppNetwork.mixesUrl, headers: headers).validate(statusCode: 200..<300).responseJSON { response in
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
    
    func getMix(mixId:String, complition: @escaping (Result<Mix, NetworkError>)->Void) {
        
        guard let headers = self.getHTTPHeaders(rawHeaders: [.accept]) else {
            complition(.failure(.tokenError))
            return
        }
        
        let parameters = ["mix_id" : mixId]
        
        AF.request(MixAppNetwork.mixBaseUrl, parameters: parameters, headers: headers).validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                complition(.success(Mix(data: json["data"])))
            case .failure(let error):
                print(error.localizedDescription)
                complition(.failure(.primaryError))
            }
        }
    }
    
    func getMyMixes(complition: @escaping (Result<[Mix], NetworkError>)->Void) {
        getToken {
            guard let headers = self.getHTTPHeaders(rawHeaders: self.basicHeaders) else {
                complition(.failure(.tokenError))
                return
            }
            
            AF.request(MixAppNetwork.myMixesUrl, headers: headers).validate(statusCode: 200..<300).responseJSON { response in
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
    
    func voteMix(mixId:String, isLike:Bool, isRemove:Bool, complition: @escaping (Bool)->Void) {
        getToken {
            guard let headers = self.getHTTPHeaders(rawHeaders: self.basicHeaders) else {
                complition(false)
                return
            }
            
            let parameters = ["mix_id" : mixId]
            
            AF.request(isLike ? MixAppNetwork.likeMixUrl : MixAppNetwork.dislikeMixUrl, method: isRemove ? .put : .delete, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<300).responseJSON { response in
                print(response.debugDescription)
                switch response.result {
                case .success( _):
                    complition(true)
                case .failure(let error):
                    print(error.localizedDescription)
                    complition(false)
                }
            }
        }
    }
    
    func addToFav(company:String, isRemove:Bool = false, complition: @escaping (Bool)->Void) {
        getToken {
            guard let headers = self.getHTTPHeaders(rawHeaders: self.basicHeaders) else {
                complition(false)
                return
            }
            
            let parameters = ["company" : company]
            
            AF.request(MixAppNetwork.favMixUrl, method: isRemove ? .delete : .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<300).responseJSON { response in
                print(response.debugDescription)
                switch response.result {
                case .success( _):
                    complition(true)
                case .failure(let error):
                    print(error.localizedDescription)
                    complition(false)
                }
            }
        }
    }
    
    func createMix(mix:MixToCreate, complition: @escaping (Bool)->Void) {
        
        getToken {
            guard let headers = self.getHTTPHeaders(rawHeaders: self.basicHeaders) else {
                complition(false)
                return
            }
            
            var arr:[[String:String]] = []
            
            for ingridient in mix.ingredients {
                arr.append(["tobacco_id":"\(ingridient.tobacco_id)", "proportion": "\(ingridient.proportion)"])
            }
            let parameters = ["description": mix.description, "taste": mix.taste, "instruction": mix.instructions, "ingredients": arr] as [String : Any]
            
            AF.request(MixAppNetwork.mixBaseUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<300).responseJSON { response in
                print(response.debugDescription)
                switch response.result {
                case .success( _):
                    complition(true)
                case .failure(let error):
                    print(error.localizedDescription)
                    // print(response.data.)
                    complition(false)
                }
            }
        }
    }
}

