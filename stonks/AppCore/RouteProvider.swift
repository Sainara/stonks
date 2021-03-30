//
//  RouteProvider.swift
//  MixApp
//
//  Created by Ян Мелоян on 04.11.2020.
//

import UIKit

class RouteProvider {
    private init() {}
    
    static let shared = RouteProvider()
    
    func initViewController() -> UIViewController {
        return MainTabBarViewController()
    }
}
