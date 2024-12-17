//
//  RegisterUserUseCase.swift
//  Headeroftable
//
//  Created by Alptuğ Kızılay on 17.12.2024.
//

import Foundation
import RxSwift

protocol RegisterUserUseCaseProtocol {
    func execute(email: String, password: String) -> Observable<User>
}

class RegisterUserUseCase: RegisterUserUseCaseProtocol {
    private let authRepository: AuthRepositoryProtocol
    
    init(authRepository: AuthRepositoryProtocol = AuthRepository()) {
        self.authRepository = authRepository
    }
    
    func execute(email: String, password: String) -> Observable<User> {
        print("RegisterUserUseCase - Kullanıcı kaydediliyor...")
        return authRepository.registerUser(email: email, password: password)
    }
}
