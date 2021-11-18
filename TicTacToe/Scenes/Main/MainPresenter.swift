//
//  MainPresenter.swift
//  TicTacToe
//
//  Created by Miguel Barone on 17/11/21.
//

import UIKit

protocol MainPresenting: AnyObject {
    func presentSelectedItem(at indexPath: IndexPath, itemType: TicItemType)
    func presentWinner(_ itemType: TicItemType, winningRows: [Int])
    func presentDraw()
    func presentResetGame()
}

final class MainPresenter: MainPresenting {
    private weak var view: MainDisplaying?

    init(view: MainDisplaying) {
        self.view = view
    }

    func presentSelectedItem(at indexPath: IndexPath, itemType: TicItemType) {
        view?.updateCell(at: indexPath, itemType: itemType)
    }

    func presentWinner(_ itemType: TicItemType, winningRows: [Int]) {
        view?.displayWinner(typeWinner: itemType, winningRows: winningRows)
    }

    func presentDraw() {
        view?.displayDraw()
    }

    func presentResetGame() {
        view?.displayResetGame()
    }
}
