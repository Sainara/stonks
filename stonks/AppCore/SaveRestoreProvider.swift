//
//  SaveRestoreProvider.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 13.06.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import Foundation

class SaveRestoreProvider {
    
    private static let accessTokenKey = "accessTokenKey"
    private static let refreshTokenKey = "refreshTokenKey"
    private static let baseUserKey = "userKey"
    private static let userIsValidKey = "\(baseUserKey)IsValid"
    private static let userIsOnValidationKey = "\(baseUserKey)IsOnValidation"
    private static let userPhoneKey = "\(baseUserKey)Phone"
    private static let userIDKey = "\(baseUserKey)ID"
    private static let userNameKey = "\(baseUserKey)Name"

    private static let userINNKey = "\(baseUserKey)INN"
    private static let userEmailKey = "\(baseUserKey)Email"
    private static let userIzPhizKey = "\(baseUserKey)IsPhiz"
        
    private init() {}
    
    static let shared = SaveRestoreProvider()
    
    func saveToken(token:String?, type:TokenType) {
        switch type {
        case .access:
            UserDefaults.standard.set(token, forKey: Self.accessTokenKey)
        case .refresh:
            UserDefaults.standard.set(token, forKey: Self.refreshTokenKey)
        }
    }
    
    func restoreToken(type:TokenType) -> String? {
        switch type {
        case .access:
            print("access token - \(UserDefaults.standard.string(forKey: Self.accessTokenKey) ?? "undefined")")
            return UserDefaults.standard.string(forKey: Self.accessTokenKey)
        case .refresh:
            print("refresh token - \(UserDefaults.standard.string(forKey: Self.refreshTokenKey) ?? "undefined")")
            return UserDefaults.standard.string(forKey: Self.refreshTokenKey)
        }
    }
    
    func saveUser(user:User?) {
//        UserDefaults.standard.set(user?.isValid, forKey: Self.userIsValidKey)
//        UserDefaults.standard.set(user?.phone, forKey: Self.userPhoneKey)
//        UserDefaults.standard.set(user?.isOnValidation, forKey: Self.userIsOnValidationKey)
        UserDefaults.standard.set(user?.id, forKey: Self.userIDKey)
        UserDefaults.standard.set(user?.name, forKey: Self.userNameKey)
//        UserDefaults.standard.set(user?.inn, forKey: Self.userINNKey)
//        UserDefaults.standard.set(user?.email, forKey: Self.userEmailKey)
//        UserDefaults.standard.set(user?.isPhiz, forKey: Self.userIzPhizKey)
    }
    
    func restoreUser() -> User? {
//        guard let phone = UserDefaults.standard.string(forKey: Self.userPhoneKey) else {return nil}
//        let isValid = UserDefaults.standard.bool(forKey: Self.userIsValidKey)
//        let isOnValidation = UserDefaults.standard.bool(forKey: Self.userIsOnValidationKey)
        let id = UserDefaults.standard.integer(forKey: Self.userIDKey)
        guard let name = UserDefaults.standard.string(forKey: Self.userNameKey) else {return nil}
//        let email = UserDefaults.standard.string(forKey: Self.userEmailKey)
//        let inn = UserDefaults.standard.string(forKey: Self.userINNKey)
//        let isPhiz = UserDefaults.standard.bool(forKey: Self.userIzPhizKey)
        
        return User(id: id, name: name)
        //return AbstractUser(phone: phone, isValid: isValid, isOnValidation: isOnValidation, name: name, inn: inn, email: email, isPhiz: isPhiz)
    }
    
    enum TokenType {
        case access, refresh
    }
}
