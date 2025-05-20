//
//  ViewCode.swift
//  Schedule
//
//  Created by Rafaela Torres Alves Ribeiro Galdino on 19/05/25.
//  Copyright © 2025 Rafaela Galdino. All rights reserved.
//

protocol ViewCode {
    func setup()
    func setupHierarchy()
    func setupConstraints()
    func setupAdditionalConfiguration()
    func setupTheme()
}

extension ViewCode {
    func setup() {
        setupTheme()
        setupHierarchy()
        setupConstraints()
        setupAdditionalConfiguration()
    }

    func setupAdditionalConfiguration() {}

    func setupTheme() {}
}
