//
//  AppFlowCoordinator.swift
//  PremierLeague
//
//  Created by Mahmoud Abdelshafi on 15/03/2023.
//

import UIKit

final class AppFlowCoordinator {

    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(navigationController: UINavigationController,
         appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }

    func start() {
        let makeMainScenesDIContainer = appDIContainer.makeMainScenesDiContainer()
        let flow = makeMainScenesDIContainer.makeLessonsScenesCoordinator(navigationController: navigationController)
        flow.start()
    }
}
