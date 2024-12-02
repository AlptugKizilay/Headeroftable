//
//  MainPageViewModel.swift
//  Headeroftable
//
//  Created by Alptuğ Kızılay on 1.12.2024.
//

import Foundation
import RxSwift
import RxCocoa

class MainPageViewModel {
    private let fetchArticlesUseCase: FetchArticlesUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    let articles: BehaviorRelay<[Article]> = BehaviorRelay(value: [])
    let error: PublishSubject<String> = PublishSubject()
    
    init(fetchArticlesUseCase: FetchArticlesUseCaseProtocol = FetchArticlesUseCase()) {
        self.fetchArticlesUseCase = fetchArticlesUseCase
    }
    
    func fetchArticles() {
        fetchArticlesUseCase.execute()
            .observe(on: MainScheduler.instance) // ana thread'de işlenmesini sağlar
            .subscribe(
                onNext: { [weak self] articles in
                    self?.articles.accept(articles)
                },
                onError: { [weak self] error in
                    self?.error.onNext(error.localizedDescription)
                }
            )
            .disposed(by: disposeBag)
    }
}
