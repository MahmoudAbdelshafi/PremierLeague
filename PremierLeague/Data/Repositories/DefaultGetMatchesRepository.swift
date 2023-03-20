//
//  DefaultGetMatchesRepository.swift
//  PremierLeague
//
//  Created by Mahmoud Abdelshafi on 15/03/2023.
//

import Foundation
import Moya

final class DefaultGetMatchesRepository {
    
    private let provider: MoyaProvider<MainTarget>
    
    init(provider: MoyaProvider<MainTarget>) {
        self.provider = provider
    }
}

//MARK: - GetMatchesRepository -

extension DefaultGetMatchesRepository: MatchesRepository {

    func getMatches() async throws -> [MatchEntity] {
        let result = await provider
            .requestAsync(.getMatches)
            .filterSuccessfulStatusCodes()
            .map(MatchesDataDTO.self)
        switch result {
        case let .success(data):
            return data.matches.compactMap { $0.toDomain() }
        case let .failure(error):
            throw error
        }
    }
    
    func getFavMatchs() -> Set<Int>? {
        return UserDefaultsManger.favMatches
    }
    
    func setFavMatchs(ids: Set<Int>) {
        UserDefaultsManger.favMatches = ids
    }
}
