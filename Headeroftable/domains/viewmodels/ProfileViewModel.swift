//
//  ProfileViewModel.swift
//  Headeroftable
//
//  Created by Alptuğ Kızılay on 15.12.2024.
//

import RxSwift
import RxCocoa

class ProfileViewModel {
    private let fetchUsersUseCase: FetchUsersUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    let users: BehaviorRelay<[User]> = BehaviorRelay(value: [])
    
    // Oturum açmış kullanıcı için
    let currentUser: BehaviorRelay<User?> = UserManager.shared.currentUser
    
    let error: PublishSubject<String> = PublishSubject()
    
    init(fetchUsersUseCase: FetchUsersUseCaseProtocol = FetchUsersUseCase()) {
        self.fetchUsersUseCase = fetchUsersUseCase
        bindCurrentUser()
    }
    
    private func bindCurrentUser() {
        UserManager.shared.currentUser
            .observe(on: MainScheduler.instance)
            .bind(to: currentUser)
            .disposed(by: disposeBag)
    }
    
    // Favori makale ekleme
    func addFavoriteArticle(_ articleId: String) {
        UserManager.shared.addFavoriteArticle(articleId)
    }
    
    // Favori makale kaldırma
    func removeFavoriteArticle(_ articleId: String) {
        UserManager.shared.removeFavoriteArticle(articleId)
    }
    // Sistemdeki tüm kullanıcıları getirmek için (eski işlev)
    func fetchUsers() {
        fetchUsersUseCase.execute()
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] users in
                    self?.users.accept(users)
                },
                onError: { [weak self] error in
                    self?.error.onNext(error.localizedDescription)
                }
            )
            .disposed(by: disposeBag)
    }
}

