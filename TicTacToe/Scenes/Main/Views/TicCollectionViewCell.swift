//
//  TicCollectionViewCell.swift
//  TicTacToe
//
//  Created by Miguel Barone on 31/10/21.
//

import UIKit

final class TicCollectionViewCell: UICollectionViewCell {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TicCollectionViewCell: ViewConfiguration {
    func configureView() {
        backgroundColor = .white

        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
    }

    func buildHierarchy() {
        contentView.addSubview(imageView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -8),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 8),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
        ])
    }

    func configure(itemType: TicItemType) {
        imageView.image = itemType.image
        isUserInteractionEnabled = false
    }

    func paintBackground() {
        backgroundColor = .green
    }

    func resetItem() {
        backgroundColor = .white
        imageView.image = nil
        isUserInteractionEnabled = true
    }
}
