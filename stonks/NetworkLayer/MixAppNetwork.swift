//
//  WylsacomTVNetwork.swift
//  WylsaPodcastUIKit
//
//  Created by Ян Мелоян on 20.08.2020.
//  Copyright © 2020 tommt. All rights reserved.
//

import Alamofire
import SwiftyJSON

class MixAppNetwork {
        
    internal static let baseurl = "https://vast-mesa-42456.herokuapp.com/api/"
//    internal static let videourl = "\(baseurl)videos"
//    internal static let podcastsurl = "\(baseurl)podcasts"
//    internal static let liveStreamurl = "\(baseurl)liveStream"
    
    internal static let appleAuthUrl = "\(baseurl)auth/apple"
    internal static let vkAuthUrl = "\(baseurl)auth/vk"
    internal static let meUrl = "\(baseurl)me"
    internal static let refreshUrl = "\(baseurl)auth/refresh"
    
    internal static let mixBaseUrl = "\(baseurl)mix"
    internal static let mixesUrl = "\(mixBaseUrl)es"
    internal static let myMixesUrl = "\(baseurl)my-mixes"
    internal static let likeMixUrl = "\(mixBaseUrl)/like"
    internal static let dislikeMixUrl = "\(mixBaseUrl)/dislike"
    
    internal static let commentBaseUrl = "\(baseurl)comment"
    internal static let getCommentsUrl = "\(commentBaseUrl)s"
    
    internal static let favMixUrl = "\(baseurl)favourites"
    
    internal static let tabaccoUrl = "\(baseurl)tobacco"
    internal static let tabaccosUrl = "\(tabaccoUrl)s"
    
    internal static let filterOptionsUrl = "\(baseurl)filter-options"

//    internal static let authWithApple = "\(baseurl)userProfile/apple"
//    internal static let userData = "\(baseurl)userProfile"
//
//    internal static let getCommentForVideo = "\(baseurl)comment/video"
//    internal static let getCommentForLive = "\(baseurl)comment/liveStream"
        
    func getToken(complition:@escaping()->Void) {
        
        switch isNeedIssueNewToken() {
        case .byAuth:
            //getTokenWithParams(url: MixAppNetwork.loginUrl, parameters: [:]) {
                print("Getted by auth")
                complition()
            //}
        case .byRefresh( _):
            getTokenWithPefresh {
                print("Getted by refresh")
                complition()
            }
        case .doNothing:
            print("Getted by doNothing")
            complition()
        }
    }
    
    func getTokenWithPefresh(complition:@escaping()->Void) {
        guard let headers = self.getHTTPHeaders(rawHeaders: [.refreshToken]) else {
            complition()
            return
        }
                
        AF.request(MixAppNetwork.refreshUrl, method: .post, headers: headers).validate(statusCode: 200..<300).responseJSON { response in
            print(response.debugDescription)
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("Get tokens")
                print("accessToken = \(json["data"]["access_token"].stringValue)")
                print("refreshToken = \(json["data"]["refresh_token"].stringValue)")
                App.shared.accessToken = json["data"]["access_token"].string
                App.shared.refreshToken = json["data"]["refresh_token"].string
                complition()
            case .failure(let error):
                App.shared.accessToken = nil
                self.onFailure(error: error, on403: {
                    App.shared.refreshToken = nil
                    self.getTokenWithPefresh {
                        complition()
                    }
                }) {
                    print("try get again")
                    self.getTokenWithPefresh {
                        complition()
                    }
                }
                complition()
                print("\(error.responseCode ?? 600)")
                print(error.localizedDescription)
            }
        }
    }
    
    func onFailure(error:AFError, on403: ()->Void, repatCode:@escaping()->Void) {
        if let errorCode = error.responseCode, errorCode == 403 {
            on403()
        } else {
          DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
                repatCode()
            }
        }
    }
    
    func isNeedIssueNewToken() -> TokenGettingType {
        guard let accessToken = App.shared.accessToken else {
            guard let refreshToken = App.shared.refreshToken else {
                return .byAuth
            }
            return .byRefresh(refreshToken: refreshToken)
        }
        if App.shared.refreshToken == nil {
            return .byAuth
        }

        if checkTokenExp(jwt: accessToken) {
            guard let refreshToken = App.shared.refreshToken else {
                return .byAuth
            }
            return .byRefresh(refreshToken: refreshToken)
        }
        return .doNothing
    
    }
    
    func checkTokenExp(jwt:String) -> Bool {
        let payload = jwt.components(separatedBy: ".")
        if payload.count > 1 {
            var payload64 = payload[1]
            while payload64.count % 4 != 0 {
                payload64 += "="
            }
            let payloadData = Data(base64Encoded: payload64,
                                   options:.ignoreUnknownCharacters)!
            
            let json = JSON(payloadData)
            let now = Date()
            let exp = Date(timeIntervalSince1970: .init(integerLiteral: Int64(json["exp"].intValue)))

            if now >= exp {
                return true
            }
            return false
        }
        return true
    }
    
    func getHTTPHeaders(rawHeaders:[HTTPHeaderType]) -> HTTPHeaders? {
        
        var headers = HTTPHeaders()
        
        for rawHeader in rawHeaders {
            if let header = rawHeader.initHeader() {
                headers.add(header)
            } else {
                return nil
            }
        }

        return headers
    }

    let basicHeaders:[HTTPHeaderType] = [.accessToken, .accept]

    enum HTTPHeaderType {
        case accessToken, refreshToken, accept

        func initHeader() -> HTTPHeader? {
            switch self {
            case .accept:
                return HTTPHeader.accept("application/json")
            case .accessToken:
                guard let token = App.shared.accessToken else {return nil}
                return HTTPHeader(name: "X-Auth-Access", value: token)
            case .refreshToken:
                guard let token = App.shared.refreshToken else {return nil}
                return HTTPHeader(name: "X-Auth-Refresh", value: token)
            }
        }
    }
    
    enum TokenGettingType {
        case byAuth, byRefresh(refreshToken:String), doNothing
    }
}

