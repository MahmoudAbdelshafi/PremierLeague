//
//  AppDIContainer.swift
//  PremierLeague
//
//  Created by Mahmoud Abdelshafi on 15/03/2023.
//

import Foundation

final class AppDIContainer {
    
    lazy var appConfiguration = AppConfiguration()
    
    // MARK: - DIContainers of Scenes
    
    func makeMainScenesDiContainer() -> MainScenesDiContainer {
        return MainScenesDiContainer()
    }
    
}

