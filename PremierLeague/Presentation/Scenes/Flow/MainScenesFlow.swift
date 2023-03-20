//
//  MainScenesFlow.swift
//  PremierLeague
//
//  Created by Mahmoud Abdelshafi on 15/03/2023.
//

import UIKit
import SwiftUI

protocol MainScenesFlowCoordinatorDependencies {
    func makeMainHostingController() -> MainLessonsHostingController
}

final class MainScenesCoordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: MainScenesFlowCoordinatorDependencies
    
    private weak var mainLessonsVC: MainLessonsHostingController?
    
    init(navigationController: UINavigationController,
         dependencies: MainScenesFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let hostingController = dependencies.makeMainHostingController()
        navigationController?.pushViewController(hostingController, animated: false)
        mainLessonsVC = hostingController
    }

}
