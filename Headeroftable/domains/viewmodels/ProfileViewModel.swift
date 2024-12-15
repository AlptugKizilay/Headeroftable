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
    let error: PublishSubject<String> = PublishSubject()

    init(fetchUsersUseCase: FetchUsersUseCaseProtocol = FetchUsersUseCase()) {
        self.fetchUsersUseCase = fetchUsersUseCase
    }

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

