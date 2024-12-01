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
    let publishedDate: String?
    let media: [Media]

    struct Media: Codable {
        let mediaMetadata: [MediaMetadata]?
        let caption: String?

        struct MediaMetadata: Codable {
            let url: String?
            let format: String?
        }
    }
}

