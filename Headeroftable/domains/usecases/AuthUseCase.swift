//
//  AuthUseCase.swift
//  Headeroftable
//
//  Created by Alptuğ Kızılay on 16.12.2024.
//

import Foundation
import RxSwift

protocol AuthUseCaseProtocol {
    func registerUser(email: String, password: String) -> Observable<User>
    func loginUser(email: String, password: String) -> Observable<User>
}

class AuthUseCase: AuthUseCaseProtocol {
    private let authRepository: AuthRepositoryProtocol
    
  
    init(authRepository: AuthRepositoryProtocol = AuthRepository()) {
        self.authRepository = authRepository
    }
    
    func registerUser(email: String, password: String) -> Observable<User> {
        // Kayıt olma işlemi
        print("AuthUseCase - Kullanıcı kaydediliyor...")
        return authRepository.registerUser(email: email, password: password)
    }
    
    func loginUser(email: String, password: String) -> Observable<User> {
        // Giriş yapma işlemi
        print("AuthUseCase - Kullanıcı giriş yapıyor...")
        return authRepository.loginUser(email: email, password: password)
    }
}
/*
 iş mantığı
 iş kurallarını değiştirmek istersek (örneğin girişte ekstra doğrulama eklersek), bu katmanda yaparız.
 */
