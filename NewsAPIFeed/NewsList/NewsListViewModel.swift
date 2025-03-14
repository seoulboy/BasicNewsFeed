//
//  FeedViewModel.swift
//  NewsAPIFeed
//
//  Created by Imho Jang on 2/24/25.
//

import Foundation
import RxSwift
import RxRelay

protocol NewsListViewModel {
    var hasNextPage: Bool { get }
    var articles: BehaviorRelay<[Article]> { get }
    var isLoading: BehaviorRelay<Bool> { get }
    var error: BehaviorRelay<Error?> { get }
    var didTapItem: PublishSubject<Int> { get }
    func loadNextPage()
}

final class DefaultNewsListViewModel: NewsListViewModel {
    weak var coordinator: NewsListCoordinator?
    var hasNextPage: Bool { currentPage * pageSize < totalResultCount }
    let articles: BehaviorRelay<[Article]> = .init(value: [])
    let isLoading: BehaviorRelay<Bool> = .init(value: false)
    let error: BehaviorRelay<Error?> = .init(value: nil)
    let didTapItem: PublishSubject<Int> = .init()
    private var newsList: NewsList?
    private var totalResultCount = 0
    private var currentPage = 1
    private var pageSize = 5
    private let networkService: NewsDataService
    private let disposeBag = DisposeBag()
    
    init(networkService: NewsDataService, coordinator: NewsListCoordinator) {
        self.networkService = networkService
        self.coordinator = coordinator
        loadInitialData()
        bind()
    }
    
    func loadInitialData() {
        loadPage()
    }
    
    func loadNextPage() {
        guard hasNextPage else {
            return
        }
        
        guard !isLoading.value else { return }
        
        currentPage += 1
        loadPage()
    }

    func loadPage() {
        guard !isLoading.value else { return }
        isLoading.accept(true)
        Task { @MainActor in
            do {
                let newsList = try await networkService.fetchNews(page: currentPage, pageSize: pageSize)
                self.newsList = newsList
                self.totalResultCount = newsList?.totalResults ?? 0
                let articles = articles.value + (newsList?.articles ?? [])
                self.articles.accept(articles)
                self.error.accept(nil)
            } catch {
                self.error.accept(error)
            }
            self.isLoading.accept(false)
        }
    }
    
    private func bind() {
        didTapItem
            .subscribe(onNext: { [weak self] index in
                guard let self,
                      let urlString = self.articles.value[index].url else { return }
                coordinator?.showNewsDetail(with: urlString)
            })
            .disposed(by: disposeBag)
    }
}
