//
//  AuthViewModel.swift
//  Headeroftable
//
//  Created by Alptuğ Kızılay on 16.12.2024.
//

import Foundation
import RxSwift

class AuthViewModel {
    private let authUseCase: AuthUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    let authResult = PublishSubject<User>()
    let error = PublishSubject<String>()
    
    
    init(authUseCase: AuthUseCaseProtocol = AuthUseCase()) {
        self.authUseCase = authUseCase
    }
    
    // Kayıt Ol Fonksiyonu
    func registerUser(email: String, password: String) {
        authUseCase.registerUser(email: email, password: password)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] user in
                    print("VM/ Kayıt Başarılı: \(user)")
                    self?.authResult.onNext(user)
                },
                onError: { [weak self] error in
                    print("VM/ Kayıt Hatası: \(error.localizedDescription)")
                    self?.error.onNext(error.localizedDescription)
                }
            )
            .disposed(by: disposeBag)
    }
    
    // Giriş Yap Fonksiyonu
    func loginUser(email: String, password: String) {
        authUseCase.loginUser(email: email, password: password)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] user in
                    print("VM/ Giriş Başarılı: \(user)")
                    self?.authResult.onNext(user)
                },
                onError: { [weak self] error in
                    print("VM/ Giriş Hatası: \(error.localizedDescription)")
                    self?.error.onNext(error.localizedDescription)
                }
            )
            .disposed(by: disposeBag)
    }
}

