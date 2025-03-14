//
//  ViewController.swift
//  NewsAPIFeed
//
//  Created by Imho Jang on 2/24/25.
//

import UIKit
import RxSwift

enum Section {
    case main
}

final class NewsListViewController: UIViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Article>
    
    private lazy var collectionView: UICollectionView = createCollectionView()
    private lazy var dataSource: DataSource = createDataSource()
    
    private var dataSourceHasItems: Bool { (dataSource.snapshot().itemIdentifiers.count) > 0 }
    private let viewModel: NewsListViewModel
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let disposeBag = DisposeBag()
    
    init(viewModel: NewsListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.title = "USA News"
        view.backgroundColor = .systemBackground
        addCollectionView()
        setupActivityIndicator()
        bind()
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bind() {
        viewModel.articles
            .filter { !$0.isEmpty }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (articles: [Article]) in
                var snapshot = NSDiffableDataSourceSnapshot<Section, Article>.init()
                snapshot.appendSections([.main])
                snapshot.appendItems(articles)
                self?.dataSource.apply(snapshot, animatingDifferences: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
                isLoading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
            })
            .disposed(by: disposeBag)
        
        viewModel.error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                if let error = error {
                    self?.showErrorAlert(error: error)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func showErrorAlert(error: Error) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func createCollectionView() -> UICollectionView {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(NewsListCell.self, forCellWithReuseIdentifier: NewsListCell.reuseIdentifier)
        view.register(LoadMoreFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "LoadMoreFooter")
        return view
    }
    
    private func addCollectionView() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(160))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(160))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(10)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 20
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        section.boundarySupplementaryItems = [footer]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func createDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, itemIdentifier in
            guard let self else { return UICollectionViewCell() }
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NewsListCell.reuseIdentifier,
                for: indexPath
            ) as! NewsListCell
            cell.configure(with: itemIdentifier, cellIndex: indexPath.item)
            cell.tapEvent
                .bind(to: self.viewModel.didTapItem)
                .disposed(by: disposeBag)
            return cell
        }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "LoadMoreFooter", for: indexPath) as! LoadMoreFooterView
            footer.button.addTarget(self, action: #selector(self.loadMoreTapped), for: .touchUpInside)
            footer.button.isEnabled = self.viewModel.hasNextPage && !self.viewModel.isLoading.value
            return footer
        }
        
        return dataSource
    }
    
    @objc private func loadMoreTapped() {
        viewModel.loadNextPage()
    }
}
