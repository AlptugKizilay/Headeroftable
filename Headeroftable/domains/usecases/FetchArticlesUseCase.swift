//
//  FetchArticlesUseCase.swift
//  Headeroftable
//
//  Created by Alptuğ Kızılay on 1.12.2024.
//

import Foundation
import RxSwift

// UseCase protokolü
protocol FetchArticlesUseCaseProtocol {
    func execute() -> Observable<[Article]>
}

// UseCase implementasyonu
class FetchArticlesUseCase: FetchArticlesUseCaseProtocol {
    private let repository: ArticleRepositoryProtocol

    init(repository: ArticleRepositoryProtocol = ArticleRepository()) {
        self.repository = repository
    }

    func execute() -> Observable<[Article]> {
        return repository.getArticles()
    }
}
