//
//  LoadMoreFooterView.swift
//  NewsAPIFeed
//
//  Created by Imho Jang on 2/26/25.
//

import UIKit

final class LoadMoreFooterView: UICollectionReusableView {
    let button = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        button.setTitle("Load More", for: .normal)
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
