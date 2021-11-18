//
//  MainViewController.swift
//  TicTacToe
//
//  Created by Miguel Barone on 31/10/21.
//

import UIKit

protocol MainDisplaying: AnyObject {
    func updateCell(at indexPath: IndexPath, itemType: TicItemType)
    func displayWinner(typeWinner: TicItemType, winningRows: [Int])
    func displayDraw()
    func displayResetGame()
}

final class MainViewController: UIViewController {
    private enum Constants {
        static let minorSpacing: CGFloat = 8
        static let defaultSpacing: CGFloat = 16
        static let titleLabelFontSize: CGFloat = 16
        static let winnerLabelFontSize: CGFloat = 16
        static let collectionFlowLayoutInset = UIEdgeInsets(top: .zero, left: 12, bottom: .zero, right: 12)
        static let numberOfItemsInCollection = 9
        static let numberOfItemsInRow: CGFloat = 3
        static let playAgainButtonCornerRadius: CGFloat = 8
        static let playAgainButtonHeight: CGFloat = 56
    }

    private let cellIdentifier = "TicCell"

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Your turn X"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: Constants.titleLabelFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = Constants.collectionFlowLayoutInset

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(TicCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private lazy var winnerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: Constants.winnerLabelFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var playAgainButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = Constants.playAgainButtonCornerRadius
        button.setTitle("Play again!", for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(resetGame), for: .touchUpInside)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var interactor: MainInteracting?

    override func viewDidLoad() {
        super.viewDidLoad()
        injectScene()
        buildLayout()
    }
}

extension MainViewController: ViewConfiguration {
    func configureView() {
        title = "Welcome to TicTacToe"
        view.backgroundColor = .white
    }

    func buildHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        view.addSubview(winnerLabel)
        view.addSubview(playAgainButton)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.defaultSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -Constants.defaultSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.defaultSpacing),

            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.minorSpacing),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -Constants.minorSpacing),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.minorSpacing),

            winnerLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: Constants.defaultSpacing),
            winnerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -Constants.defaultSpacing),
            winnerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.defaultSpacing),

            playAgainButton.topAnchor.constraint(equalTo: winnerLabel.bottomAnchor, constant: Constants.defaultSpacing),
            playAgainButton.bottomAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                    constant: -Constants.defaultSpacing),
            playAgainButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.defaultSpacing),
            playAgainButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.defaultSpacing),
            playAgainButton.heightAnchor.constraint(equalToConstant: Constants.playAgainButtonHeight)
        ])
    }
}

extension MainViewController: MainDisplaying {
    func updateCell(at indexPath: IndexPath, itemType: TicItemType) {
        let cell = collectionView.cellForItem(at: indexPath) as? TicCollectionViewCell
        cell?.configure(itemType: itemType)

        titleLabel.text = itemType == .x ? "Your turn O" : "Your turn X"
    }

    func displayWinner(typeWinner: TicItemType, winningRows: [Int]) {
        paintCellsBackground(in: winningRows)

        titleLabel.isHidden = true
        playAgainButton.isHidden = false
        winnerLabel.text = "\(typeWinner == .x ? "X" : "O") wins!"

        collectionView.isUserInteractionEnabled = false
    }

    func displayDraw() {
        titleLabel.isHidden = true
        playAgainButton.isHidden = false
        winnerLabel.text = "IT'S A DRAW!"
    }

    func displayResetGame() {
        collectionView.visibleCells.forEach { cell in
            let cell = cell as? TicCollectionViewCell
            cell?.resetItem()
        }

        titleLabel.isHidden = false
        playAgainButton.isHidden = true
        winnerLabel.text = ""
        collectionView.isUserInteractionEnabled = true
    }
}

private extension MainViewController {
    func injectScene() {
        let presenter = MainPresenter(view: self)

        interactor = MainInteractor(presenter: presenter)
    }

    func paintCellsBackground(in rows: [Int]) {
        rows.forEach { row in
            let indexPath = IndexPath(row: row, section: .zero)
            let cell = collectionView.cellForItem(at: indexPath) as? TicCollectionViewCell
            cell?.paintBackground()
        }
    }

    @objc
    func resetGame() {
        interactor?.resetGame()
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        interactor?.selectItem(at: indexPath)
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Constants.numberOfItemsInCollection
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = collectionView.bounds.width / Constants.numberOfItemsInRow - Constants.defaultSpacing
        let height = screenWidth

        return CGSize(width: screenWidth, height: height)
    }
}
