//
//  MatchesRepository.swift
//  PremierLeague
//
//  Created by Mahmoud Abdelshafi on 15/03/2023.
//

import Foundation

protocol MatchesRepository {
    func getMatches() async throws -> [MatchEntity]
    func getFavMatchs() -> Set<Int>?
    func setFavMatchs(ids: Set<Int>)
}
