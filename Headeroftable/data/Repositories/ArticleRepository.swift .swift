//
//  ArticleRepository.swift .swift
//  Headeroftable
//
//  Created by Alptuğ Kızılay on 27.11.2024.
//

import Foundation
import RxSwift

protocol ArticleRepositoryProtocol {
    /// API'den makaleleri çeker
    func getArticles() -> Observable<[Article]>
}

class ArticleRepository: ArticleRepositoryProtocol {
    var apiKey = "ciE5pGJZlFTA65wsGjUl1pB0VmX4M1nW"
    private let apiClient: APIClient
    lazy private var baseURL = "https://api.nytimes.com/svc/mostpopular/v2/viewed/1.json?api-key=ciE5pGJZlFTA65wsGjUl1pB0VmX4M1nW"

    init(apiClient: APIClient = APIClient.shared) {
        self.apiClient = apiClient
    }

    func getArticles() -> Observable<[Article]> {
        // APIClient üzerinden makaleleri getir
        return apiClient.fetchArticles(from: baseURL)
    }
}
