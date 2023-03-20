//
//  MatchEntity.swift
//  PremierLeague
//
//  Created by Mahmoud Abdelshafi on 16/03/2023.
//

import Foundation


struct MatchEntities: Identifiable, Hashable {
    var id: Int
    var sectionTitle: String
    var matchDate: Date
    var matches: [MatchEntity]
}

struct MatchEntity: Identifiable, Hashable {
    let id: Int
    let homeTeam:Area?
    let awayTeam:Area?
    let time:String
    let status:Status
    let score:String
    let compareDate: String
    var isFavorite: Bool? = false
}
