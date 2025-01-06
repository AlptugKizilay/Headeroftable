//
//  LogoutUserUseCase.swift
//  Headeroftable
//
//  Created by Alptuğ Kızılay on 6.01.2025.
//

import Foundation
import RxSwift

protocol LogoutUserUseCaseProtocol {
    func execute() -> Observable<Void>
}

class LogoutUserUseCase: LogoutUserUseCaseProtocol {
    private let authRepository: AuthRepositoryProtocol
    
    init(authRepository: AuthRepositoryProtocol = AuthRepository()) {
        self.authRepository = authRepository
    }
    
    func execute() -> Observable<Void> {
        return authRepository.logoutUser()
    }
}
//protocol -> testable, logout işlemini  farklı bir şekilde genişletmek (örneğin, oturum sonlandırma loglarını kaydetmek)
