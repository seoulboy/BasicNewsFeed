//
//  NewsList.swift
//  NewsAPIFeed
//
//  Created by Imho Jang on 2/25/25.
//

import Foundation

// MARK: - NewsList
struct NewsList: Codable {
    let status: String?
    let totalResults: Int?
    let articles: [Article]?
}

// MARK: - Article
struct Article: Codable, Hashable {
    let source: Source?
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}

// MARK: - Source
struct Source: Codable, Hashable {
    let id: String?
    let name: String?
}
