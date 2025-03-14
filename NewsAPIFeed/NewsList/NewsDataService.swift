//
//  NewsDataService.swift
//  NewsAPIFeed
//
//  Created by Imho Jang on 2/26/25.
//

protocol NewsDataService {
    func fetchNews(page: Int, pageSize: Int) async throws -> NewsList?
}
