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
    let filteredArticles: BehaviorRelay<[Article]> = BehaviorRelay(value: []) // Filtrelenmiş makaleler
    let error: PublishSubject<String> = PublishSubject()
    
    // Arama için keyword ve filtreleme için section
    private var searchKeyword: String = ""
    private var selectedSection: String? = nil
    
    
    
    init(fetchArticlesUseCase: FetchArticlesUseCaseProtocol = FetchArticlesUseCase()) {
        self.fetchArticlesUseCase = fetchArticlesUseCase
        // articles güncellendiğinde filtreleme işlemini tetikleyin
        articles
            .subscribe(onNext: { [weak self] _ in
                self?.applyFilters() // articles değiştiğinde filtreyi uygula
            })
            .disposed(by: disposeBag)
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
    
    // Arama için kelimeyi ayarlama
    func updateSearchKeyword(_ keyword: String) {
        searchKeyword = keyword.lowercased()
        applyFilters()
    }
    
    // Filtreleme için section'ı ayarlama
    func updateSelectedSection(_ section: String?) {
        selectedSection = section
        applyFilters()
    }
    // Filtreleme ve arama işlemlerini uygula
    private func applyFilters() {
        var filtered = articles.value
        
        // Arama işlemi
        if !searchKeyword.isEmpty {
            filtered = filtered.filter {
                $0.title.lowercased().contains(searchKeyword) || // Title'da arama
                $0.abstract.lowercased().contains(searchKeyword) || // Abstract'te arama
                $0.byline.lowercased().contains(searchKeyword)
            }
        }
        
        // Section filtreleme işlemi
        if let section = selectedSection {
            filtered = filtered.filter { $0.section == section }
        }
        
        // Filtrelenmiş sonuçları güncelle
        filteredArticles.accept(filtered)
    }
}


