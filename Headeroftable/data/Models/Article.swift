//
//  Article.swift
//  Headeroftable
//
//  Created by Alptuğ Kızılay on 27.11.2024.
//

import Foundation

struct Article: Codable {
    let id: Int
    let url: String
    let section: String
    let title: String
    let abstract: String
    let byline: String
    let publishedDate: String
    let media: [Media]
    enum CodingKeys: String, CodingKey {
           case id
           case url
           case section
           case title
           case abstract
           case byline
           case publishedDate = "published_date" // JSON'daki "published_date" anahtarıyla eşleştir
           case media
       }

    struct Media: Codable {
        let mediaMetadata: [MediaMetadata]
        let caption: String
        enum CodingKeys: String, CodingKey {
                    case mediaMetadata = "media-metadata" // JSON'daki "media-metadata" anahtarıyla eşleştir
                    case caption
                }

        struct MediaMetadata: Codable {
            let url: String
            let format: String
        }
    }
}

