//
//  Untitled.swift
//  Headeroftable
//
//  Created by Alptuğ Kızılay on 21.12.2024.
//

import Foundation
import RxSwift

protocol SaveUserUseCaseProtocol {
    func execute(user: User) -> Observable<Void>
}

class SaveUserUseCase: SaveUserUseCaseProtocol {
    private let userRepository: UserRepositoryProtocol

    init(userRepository: UserRepositoryProtocol = UserRepository()) {
        self.userRepository = userRepository
    }

    func execute(user: User) -> Observable<Void> {
        return userRepository.saveUser(user: user)
    }
}
