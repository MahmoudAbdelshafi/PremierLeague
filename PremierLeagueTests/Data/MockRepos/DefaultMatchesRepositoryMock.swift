//
//  DefaultMatchesRepositoryMock.swift
//  PremierLeagueTests
//
//  Created by Mahmoud Abdelshafi on 18/03/2023.
//

import Foundation
import Moya
@testable import PremierLeague

class DefaultMatchesRepositoryMock: BaseRepoMock, MatchesRepository {
    
    var matchsData: [PremierLeague.MatchEntity]? = []
    var error: MoyaError? = MoyaError.requestMapping("")
    
    func getMatches() async throws -> [PremierLeague.MatchEntity] {
        if shouldSuccess {
            error = nil
            return matchsData!
        } else {
            throw error!
        }
    }
    
    func getFavMatchs() -> Set<Int>? {
        []
    }
    
    func setFavMatchs(ids: Set<Int>) {
        
    }
}
