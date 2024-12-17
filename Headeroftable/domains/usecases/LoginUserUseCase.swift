//
//  LoginUserUseCase.swift
//  Headeroftable
//
//  Created by Alptuğ Kızılay on 17.12.2024.
//

import Foundation
import RxSwift

protocol LoginUserUseCaseProtocol {
    func execute(email: String, password: String) -> Observable<User>
}

class LoginUserUseCase: LoginUserUseCaseProtocol {
    private let authRepository: AuthRepositoryProtocol
    
    init(authRepository: AuthRepositoryProtocol = AuthRepository()) {
        self.authRepository = authRepository
    }
    
    func execute(email: String, password: String) -> Observable<User> {
        print("LoginUserUseCase - Kullanıcı giriş yapıyor...")
        return authRepository.loginUser(email: email, password: password)
    }
}
