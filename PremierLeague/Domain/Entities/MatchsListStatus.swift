//
//  MatchsListStatus.swift
//  PremierLeague
//
//  Created by Mahmoud Abdelshafi on 17/03/2023.
//

import Foundation

enum MatchsListStatus: Equatable {
    case Loading
    case showMatchesGroup([MatchEntities])
    case ShowFavorite([MatchEntities])
    case Failure(String)
}
