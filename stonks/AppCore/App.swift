//
//  App.swift
//  MixApp
//
//  Created by Ян Мелоян on 04.11.2020.
//

import Foundation
import UIKit

class App {
    private init() {
        user = SRProvider.restoreUser()
        accessToken = SRProvider.restoreToken(type: .access)
        refreshToken = SRProvider.restoreToken(type: .refresh)
    }
    
    static let shared = App()
    
    let SRProvider = SaveRestoreProvider.shared
    
    var user:User? {
        willSet {
            SRProvider.saveUser(user: newValue)
        }
    }
    
    var accessToken:String? {
        willSet {
            SRProvider.saveToken(token: newValue, type: .access)
        }
    }
    
    var refreshToken:String? {
        willSet {
            SRProvider.saveToken(token: newValue, type: .refresh)
        }
    }
    
//    var currentUser:AbstractUser? {
//        didSet {
//            SaveRestoreProvider.shared.saveUser(user: currentUser)
//        }
//    }
//
    func logOut() {
        user = nil
        accessToken = nil
        refreshToken = nil

    }
    
//    var isNeedUpdateDocs = false
    var isNeedReloadFeedData = false
    var isNeedUpdateProfile = false
    var isNeedUpdateFavs = false
//    var isNeedUpdateDialogs = false
}
