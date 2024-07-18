//
//  Array.swift
//  Life
//
//  Created by Олег Войтин on 06.07.2024.
//

import Foundation

extension Array {

    func chunked(into size: Int) -> [[Element]] {
        var chunks: [[Element]] = []

        for index in stride(from: 0, to: count, by: size) {
            let chunk = Array(self[index..<Swift.min(index + size, count)])
            chunks.append(chunk)
        }
        
        return chunks
    }
}
