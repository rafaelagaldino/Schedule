//
//  Binder.swift
//  Schedule
//
//  Created by Rafaela Torres Alves Ribeiro Galdino on 19/05/25.
//  Copyright © 2025 Rafaela Galdino. All rights reserved.
//

import Foundation

final class Binder<T> {
    typealias Listener = (T) -> Void
    private var listener: Listener?

    var value: T {
        didSet {
            listener?(value)
        }
    }

    init(_ value: T) {
        self.value = value
    }

    func bind(listener: Listener?) {
        self.listener = listener
    }
}
