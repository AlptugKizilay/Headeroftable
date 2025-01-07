//
//  UserManager.swift
//  Headeroftable
//
//  Created by Alptuğ Kızılay on 7.01.2025.
//

import Foundation
import RxSwift
import RxCocoa

class UserManager {
    static let shared = UserManager() // Singleton Instance, usermanager heryerden erişilebilir.

    // Reaktif kullanıcı durumu
    let currentUser: BehaviorRelay<User?> = BehaviorRelay(value: nil)

    private init() {}

    // Kullanıcı güncelleme
    func updateUser(_ user: User) {
        currentUser.accept(user)
    }

    func addFavoriteArticle(_ articleId: String) {
        guard var user = currentUser.value else { return }
        
        if !user.favoriteArticles.contains(where: { $0.articleId == articleId }) {
            let newFavorite = User.FavoriteArticle(articleId: articleId, addedAt: Date())
            user.favoriteArticles.append(newFavorite)
            currentUser.accept(user)
        }
    }

    func removeFavoriteArticle(_ articleId: String) {
        guard var user = currentUser.value else { return }
        user.favoriteArticles.removeAll(where: { $0.articleId == articleId })
        currentUser.accept(user)
    }
}
