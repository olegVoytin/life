//
//  Atomic.swift
//  Life
//
//  Created by Олег Войтин on 05.07.2024.
//

import Foundation

// Generic actor для атомарного доступа
actor Atomic<T> {
    private var value: T

    init(_ value: T) {
        self.value = value
    }

    // Метод для чтения значения
    func read() -> T {
        return value
    }

    // Метод для записи значения
    func write(_ newValue: T) {
        value = newValue
    }
}
