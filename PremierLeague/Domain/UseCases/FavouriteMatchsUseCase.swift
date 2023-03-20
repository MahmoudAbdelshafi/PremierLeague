//
//  FavouriteMatchsUseCase.swift
//  PremierLeague
//
//  Created by Mahmoud Abdelshafi on 17/03/2023.
//

import Foundation

protocol FavouriteMatchsUseCase {
    func getFavMatchs() -> Set<Int>?
    func setFavMatchs(ids: Set<Int>)
}

final class DefaultFavouriteMatchsUseCase: FavouriteMatchsUseCase {
    
    //MARK: - Properties

    private let matchesRepository: MatchesRepository
    
    //MARK: - Init
    
    init(matchesRepository: MatchesRepository) {
        self.matchesRepository = matchesRepository
    }
    
    func getFavMatchs() -> Set<Int>? {
        matchesRepository.getFavMatchs()
    }
    
    func setFavMatchs(ids: Set<Int>) {
        matchesRepository.setFavMatchs(ids: ids)
    }
    
}
