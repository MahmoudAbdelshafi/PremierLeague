//
//  FetchMatchesUseCase.swift
//  PremierLeague
//
//  Created by Mahmoud Abdelshafi on 15/03/2023.
//

import Foundation


protocol FetchMatchesUseCase {
    func execute() async throws -> [MatchEntity]
}


final class DefaultFetchMatchesUseCase: FetchMatchesUseCase {
    
    //MARK: - Properties

    private let matchesRepository: MatchesRepository
    
    
    //MARK: - Init

    init(matchesRepository: MatchesRepository) {
        self.matchesRepository = matchesRepository
    }
    
    func execute() async throws -> [MatchEntity] {
        try await matchesRepository.getMatches()
    }
}
