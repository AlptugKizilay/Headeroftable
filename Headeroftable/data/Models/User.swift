//
//  User.swift
//  Headeroftable
//
//  Created by Alptuğ Kızılay on 15.12.2024.
//

import FirebaseFirestore

struct User: Codable {
    @DocumentID var id: String?
    var name: String
    var email: String
    var dateOfBirth: Date
    var gender: Gender
    var profileImageURL: String?
    var country: String
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

    // User modelini Dictionary'ye dönüştüren extension
    func asDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [
            "name": name,
            "email": email,
            "dateOfBirth": dateOfBirth,
            "gender": gender.rawValue,
            "profileImageURL": profileImageURL ?? NSNull(),
            "country": country,
            "favoriteArticles": favoriteArticles.map { $0.asDictionary() }
        ]

        if let id = id {
            dictionary["id"] = id
        }

        return dictionary
    }
}

// FavoriteArticle için asDictionary uzantısı
extension User.FavoriteArticle {
    func asDictionary() -> [String: Any] {
        return [
            "articleId": articleId,
            "addedAt": addedAt
        ]
    }
}
