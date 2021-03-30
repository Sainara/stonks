//
//  AuthService.swift
//  MixApp
//
//  Created by Ян Мелоян on 04.11.2020.
//

import SwiftyJSON
import Alamofire

class AuthService: MixAppNetwork {
    
    static let main = AuthService()
    
    override private init() {}
    
    func authWithApple(token:String, userName:String, email:String, complition: @escaping (Bool)->Void) {
        
        guard let headers = self.getHTTPHeaders(rawHeaders: [.accept]) else {
            complition(false)
            return
        }
        
        let parameters = ["token" : token, "user_name": userName, "user_email": email]
        
        AF.request(MixAppNetwork.appleAuthUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                App.shared.accessToken = json["data"]["access_token"].stringValue
                App.shared.refreshToken = json["data"]["refresh_token"].stringValue
                print(json)
                complition(true)
            case .failure(let error):
                print(error.localizedDescription)
                complition(false)
            }
        }
    }
    
    func getMe(complition: @escaping (Bool)->Void) {
        
        getToken {
            guard let headers = self.getHTTPHeaders(rawHeaders: self.basicHeaders) else {
                complition(false)
                return
            }
            AF.request(MixAppNetwork.meUrl, method: .get, headers: headers).validate(statusCode: 200..<300).responseJSON { response in
                print(response.debugDescription)
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print(json)
                    App.shared.user = User(data: json["data"])
                    complition(true)
                case .failure(let error):
                    print(error.localizedDescription)
                    complition(false)
                }
            }
        }
    }
}
