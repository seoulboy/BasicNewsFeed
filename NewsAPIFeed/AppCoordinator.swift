//
//  AppCoordinator.swift
//  NewsAPIFeed
//
//  Created by Imho Jang on 2/25/25.
//

import UIKit

protocol Coordinator {
    func start()
}

class AppCoordinator: Coordinator {
    
    let navigationController = UINavigationController()
    let networkService = DefaultNetworkManager()
    
    init(window: UIWindow?) {
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
    }
    
    func start() {
        let vm = DefaultNewsListViewModel(networkService: networkService, coordinator: self)
        let vc = NewsListViewController(viewModel: vm)
        navigationController.pushViewController(vc, animated: true)
    }
}

extension AppCoordinator: NewsListCoordinator {
    func showNewsDetail(with urlString: String) {
        let webVC = WebViewController()
        webVC.urlString = urlString
        navigationController.pushViewController(webVC, animated: true)
    }
}
