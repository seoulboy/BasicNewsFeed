//
//  NewsListCell.swift
//  NewsAPIFeed
//
//  Created by Imho Jang on 2/26/25.
//

import UIKit
import RxSwift
import RxCocoa

final class NewsListCell: UICollectionViewCell {
    static var reuseIdentifier: String = String(describing: NewsListCell.self)
    
    lazy var button: UIButton = createButton()
    lazy var label: UILabel = createLabel()
    
    var tapEvent: Observable<Int> {
        button.rx.tap.compactMap { [weak self] _ in self?.index }
    }
    
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private var index: Int?
    private var article: Article?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        addSubviews()
        configureView()
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    func configure(with item: Article, cellIndex: Int) {
        self.article = item
        self.index = cellIndex
        let text = "\(cellIndex+1). " + (item.title ?? "")
        label.text = text
    }
    
    private func configureView() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray3.cgColor
        layer.masksToBounds = true
        layer.cornerRadius = 15
        layer.cornerCurve = .continuous
    }
    
    private func addSubviews() {
        addLabel()
        addButton()
    }
    
    private func addButton() {
        contentView.addSubview(button)
        addButtonConstraints()
    }
    
    private func addButtonConstraints() {
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            button.topAnchor.constraint(equalTo: contentView.topAnchor),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func addLabel() {
        contentView.addSubview(label)
        addLabelConstraints()
    }
    
    private func createLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        return view
    }
    
    private func createButton() -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    private func addLabelConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 60),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -60)
        ])
    }
}
