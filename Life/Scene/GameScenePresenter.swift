//
//  GameScenePresenter.swift
//  Life
//
//  Created by Олег Войтин on 04.07.2024.
//

import Foundation

protocol GameScenePresenterProtocol: AnyObject {
    func start()
}

final class GameScenePresenter: GameScenePresenterProtocol {
    
    weak var scene: GameSceneProtocol?

    func start() {
        
    }
}
