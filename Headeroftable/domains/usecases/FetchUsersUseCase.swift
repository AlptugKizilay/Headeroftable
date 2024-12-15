//
//  FetchUsersUseCase.swift
//  Headeroftable
//
//  Created by Alptuğ Kızılay on 15.12.2024.
//

import Foundation
import RxSwift

protocol FetchUsersUseCaseProtocol {
    func execute() -> Observable<[User]>
}

class FetchUsersUseCase: FetchUsersUseCaseProtocol {
    private let userRepository: UserRepositoryProtocol

    init(userRepository: UserRepositoryProtocol = UserRepository()) {
        self.userRepository = userRepository
    }

    func execute() -> Observable<[User]> {
        return userRepository.fetchUsersAsModels()
    }
}
