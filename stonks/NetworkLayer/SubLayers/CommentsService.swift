//
//  CommentsService.swift
//  MixApp
//
//  Created by Ян Мелоян on 09.11.2020.
//

import SwiftyJSON
import Alamofire

class CommentsService: MixAppNetwork {
    
    static let main = CommentsService()
    
    override private init() {}
    
    func getComments(mixID:String, complition: @escaping (Result<[Comment], NetworkError>)->Void) {
        
        guard let headers = self.getHTTPHeaders(rawHeaders: [.accept]) else {
            complition(.failure(.tokenError))
            return
        }
        
        let parameters = ["mix_id": mixID]
        
        AF.request(MixAppNetwork.getCommentsUrl, parameters: parameters, headers: headers).validate(statusCode: 200..<300).responseJSON { response in
            print(response.request?.url)
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                print(json)
                var items = [Comment]()
                for rawItem in json["data"]["comments"].arrayValue {
                    items.append(Comment(data: rawItem))
                }
                // MARK: Remove next line
                items.sort()
                complition(.success(items))
            case .failure(let error):
                print(error.localizedDescription)
                complition(.failure(.primaryError))
            }
        }
    }
    
    func createComment(comment:String, mixID:String, complition: @escaping (Bool)->Void) {
        
        getToken {
            guard let headers = self.getHTTPHeaders(rawHeaders: self.basicHeaders) else {
                complition(false)
                return
            }
            
            let parameters = ["mix_id": mixID, "message": comment]
            
            AF.request(MixAppNetwork.commentBaseUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<300).responseJSON { response in
//                print(response.request?.url)
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

