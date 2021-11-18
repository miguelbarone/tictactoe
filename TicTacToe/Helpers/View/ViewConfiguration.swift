//
//  ViewConfiguration.swift
//  TicTacToe
//
//  Created by Miguel Barone on 31/10/21.
//

protocol ViewConfiguration {
    func buildLayout()
    func configureView()
    func buildHierarchy()
    func setupConstraints()
}

extension ViewConfiguration {
    func buildLayout() {
        configureView()
        buildHierarchy()
        setupConstraints()
    }
}
