//
//  User.swift
//  Headeroftable
//
//  Created by Alptuğ Kızılay on 15.12.2024.
//

import FirebaseFirestore

struct User: Codable {
    @DocumentID var id: String?
    let name: String
    let email: String
    let dateOfBirth: Date
    let gender: Gender
    let profileImageURL: String?
    let bio: String?
    var favoriteArticles: [FavoriteArticle]

    enum Gender: String, Codable {
        case male = "Male"
        case female = "Female"
        case other = "Other"
        case unknown = "Unknown"
    }

    struct FavoriteArticle: Codable {
        let articleId: String
        let addedAt: Date
    }
}
