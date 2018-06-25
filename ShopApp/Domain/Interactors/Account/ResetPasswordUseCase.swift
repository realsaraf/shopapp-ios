//
//  ResetPasswordUseCase.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 1/2/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

class ResetPasswordUseCase {
    private let repository: AuthentificationRepository

    init(repository: AuthentificationRepository) {
        self.repository = repository
    }

    func resetPassword(email: String, _ callback: @escaping ApiCallback<Void>) {
        repository.resetPassword(email: email, callback: callback)
    }
}
