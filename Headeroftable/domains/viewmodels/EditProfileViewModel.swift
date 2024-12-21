//
//  EditProfileViewModel.swift
//  Headeroftable
//
//  Created by Alptuğ Kızılay on 21.12.2024.
//

import Foundation
import RxSwift

class EditProfileViewModel {
    private let saveUserUseCase: SaveUserUseCaseProtocol
    private let disposeBag = DisposeBag()

    // Gözlemlenebilir hata ve başarı mesajları
    let successMessage = PublishSubject<String>()
    let errorMessage = PublishSubject<String>()

    init(saveUserUseCase: SaveUserUseCaseProtocol = SaveUserUseCase()) {
        self.saveUserUseCase = saveUserUseCase
    }

    func saveUser(user: User) {
        saveUserUseCase.execute(user: user)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] in
                    self?.successMessage.onNext("User saved successfully!")
                },
                onError: { [weak self] error in
                    self?.errorMessage.onNext("Error saving user: \(error.localizedDescription)")
                }
            )
            .disposed(by: disposeBag)
    }
}
