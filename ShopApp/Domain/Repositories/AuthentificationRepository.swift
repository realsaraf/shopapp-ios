//
//  AuthentificationRepository.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 11/10/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

protocol AuthentificationRepository {
    func signUp(firstName: String, lastName: String, email: String, password: String, phone: String, callback: @escaping ApiCallback<Void>)

    func signIn(email: String, password: String, callback: @escaping ApiCallback<Void>)

    func signOut(callback: @escaping ApiCallback<Void>)

    func isSignedIn(callback: @escaping ApiCallback<Bool>)

    func resetPassword(email: String, callback: @escaping ApiCallback<Void>)
}
