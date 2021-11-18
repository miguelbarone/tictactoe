//
//  MainInteractor.swift
//  TicTacToe
//
//  Created by Miguel Barone on 17/11/21.
//

import UIKit

protocol MainInteracting: AnyObject {
    func selectItem(at indexPath: IndexPath)
    func resetGame()
}

final class MainInteractor: MainInteracting {
    private var presenter: MainPresenting
    private var isXTurn: Bool = true
    private var selectedRows: [(row: Int, type: TicItemType)] = []
    private var winnerCombinations: [[Int]] = [
        [0,3,6],
        [1,4,7],
        [2,5,8],
        [0,4,8],
        [2,4,6],
        [0,1,2],
        [3,4,5],
        [6,7,8]
    ]

    init(presenter: MainPresenting) {
        self.presenter = presenter
    }

    func selectItem(at indexPath: IndexPath) {
        let itemType: TicItemType = isXTurn ? .x : .o

        presenter.presentSelectedItem(at: indexPath, itemType: itemType)
        isXTurn.toggle()

        selectedRows.append((row: indexPath.row, type: itemType))

        validateWinner()
    }

    func resetGame() {
        selectedRows = []
        presenter.presentResetGame()
    }
}

private extension MainInteractor {
    func validateWinner() {
        let xRows = getSelectedRows(for: .x)
        let oRows = getSelectedRows(for: .o)

        for combination in winnerCombinations {
            if combination.allSatisfy(xRows.contains) {
                presenter.presentWinner(.x, winningRows: combination)
                return
            }

            if combination.allSatisfy(oRows.contains) {
                presenter.presentWinner(.o, winningRows: combination)
                return
            }
        }

        if selectedRows.count == 9 {
            presenter.presentDraw()
        }
    }

    func getSelectedRows(for itemType: TicItemType) -> [Int] {
        var rows: [Int] = []

        selectedRows.forEach { item in
            if item.type == itemType {
                rows.append(item.row)
            }
        }
        return rows
    }
}
