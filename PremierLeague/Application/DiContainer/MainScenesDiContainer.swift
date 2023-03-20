//
//  MainScenesDiContainer.swift
//  PremierLeague
//
//  Created by Mahmoud Abdelshafi on 15/03/2023.
//

import UIKit
import Moya

final class MainScenesDiContainer: MainScenesFlowCoordinatorDependencies {
    
    
    // MARK: - Repositories -
    
    static func makeDefaultMatchesRepository() -> MatchesRepository {
        DefaultGetMatchesRepository(provider: MoyaProvider<MainTarget>(plugins: [NetworkLoggerPlugin.verbose]))
    }
    
    // MARK: - Use Cases -
    
    static func makeDefaultFetchMatchesUseCase() -> FetchMatchesUseCase {
        DefaultFetchMatchesUseCase(matchesRepository: MainScenesDiContainer.makeDefaultMatchesRepository())
    }
    
     static func makeDefaultFavouriteMatchsUseCase() -> FavouriteMatchsUseCase {
         DefaultFavouriteMatchsUseCase(matchesRepository: makeDefaultMatchesRepository())
    }
    
    //MARK: - ViewModels -
    
    @MainActor static func makeDefaultMainViewModel() -> DefaultMainViewModel {
        DefaultMainViewModel(fetchMatchesUseCase: makeDefaultFetchMatchesUseCase(),
                             favouriteMatchsUseCase: makeDefaultFavouriteMatchsUseCase())
    }
}


// MARK: - MainScenes DiContainer Router Dependencies -

extension MainScenesDiContainer {
    
    @MainActor func makeMainHostingController() -> MainLessonsHostingController {
        let viewModel = MainScenesDiContainer.makeDefaultMainViewModel()
        return MainLessonsHostingController(rootView: MainView(viewModel: viewModel))
    }
    
    func makeLessonsScenesCoordinator(navigationController: UINavigationController) -> MainScenesCoordinator {
        MainScenesCoordinator(navigationController: navigationController, dependencies: self)
    }
}
