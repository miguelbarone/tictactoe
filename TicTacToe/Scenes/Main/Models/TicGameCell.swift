//
//  TicGameCell.swift
//  TicTacToe
//
//  Created by Miguel Barone on 02/11/21.
//

import UIKit

enum TicItemType {
    case x
    case o

    var image: UIImage {
        switch self {
        case .x:
            return UIImage(named: "x") ?? UIImage()
        case .o:
            return UIImage(named: "circle") ?? UIImage()
        }
    }
}
