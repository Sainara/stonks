//
//  AuthResultDelegate.swift
//  MixApp
//
//  Created by Ян Мелоян on 04.11.2020.
//

protocol AuthResultDelegate {
    func started()
    func complete(isSuccess:Bool)
}
