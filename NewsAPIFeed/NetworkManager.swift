//
//  NetworkManager.swift
//  NewsAPIFeed
//
//  Created by Imho Jang on 2/24/25.
//

import Foundation

protocol NetworkService: NewsDataService {}

class DefaultNetworkManager: NetworkService {
    let jsondecoder = JSONDecoder()
}

extension DefaultNetworkManager {
    func fetchNews(page: Int, pageSize: Int) async throws -> NewsList? {
        let apiKey = getAPIKey()
        guard let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&pageSize=\(pageSize)&page=\(page)&apiKey=\(apiKey)") else { return nil }
        do {
            let (jsonData, _) = try await URLSession.shared.data(from: url)
            let decoded = try jsondecoder.decode(NewsList.self, from: jsonData)
            return decoded
        } catch {
            print(error)
        }
        return nil
    }
    
    // requires better security in a real-life production app such as JWT (json web token)
    private func getAPIKey() -> String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "NEWS_API_KEY") as? String else {
            fatalError("API Key is missing")
        }
        return key
    }
}
