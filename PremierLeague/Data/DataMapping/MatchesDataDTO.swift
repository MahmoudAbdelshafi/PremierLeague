//
//  MatchesDataDTO.swift
//  PremierLeague
//
//  Created by Mahmoud Abdelshafi on 15/03/2023.
//

import Foundation

struct MatchesDataDTO: Codable {
    let count: Int?
    let competition: Competition?
    let matches: [Match]
}

// MARK: - Competition
struct Competition: Codable {
    let id: Int?
    let area: Area?
    let name, code, plan: String?
    let lastUpdated: Date?
}

// MARK: - Area
struct Area:  Hashable, Codable, Identifiable {
    let id: Int?
    let name: String?
    let shortName: String?
    let crest: String?
    let tla: String?
}

// MARK: - Match
struct Match: Codable {
    let id: Int?
    let season: Season?
    let utcDate: String?
    let status: String?
    let matchday: Int?
    let stage: Stage?
    let group: String?
    let lastUpdated: String?
    let odds: Odds?
    let score: Score?
    let homeTeam, awayTeam: Area?
    let referees: [Referee]?
}

// MARK: - Odds
struct Odds: Codable {
    let msg: String?
}


// MARK: - Referee
struct Referee: Codable {
    let id: Int?
    let name: String?
    let role: Role?
    let nationality: Nationality?
}

enum Nationality: String, Codable {
    case australia = "Australia"
    case england = "England"
}

enum Role: String, Codable {
    case referee = "REFEREE"
}

// MARK: - Score
struct Score: Codable {
    let winner: Winner?
    let duration: Duration?
    let fullTime, halfTime, extraTime, penalties: Time?
}

enum Duration: String, Codable {
    case regular = "REGULAR"
}


public struct Time: Codable {
    public let home: Int?
    public let away: Int?
}


enum Winner: String, Codable {
    case awayTeam = "AWAY_TEAM"
    case draw = "DRAW"
    case homeTeam = "HOME_TEAM"
}

// MARK: - Season
struct Season: Codable {
    let id: Int?
    let startDate, endDate: String?
    let currentMatchday: Int?
}

enum Stage: String, Codable {
    case regularSeason = "REGULAR_SEASON"
}

enum Status: String, Codable , Hashable{
    case finished = "FINISHED"
    case postponed = "POSTPONED"
    case scheduled = "SCHEDULED"
    case timed = "TIMED"
}

//MARK: - MatchesDataDTO To Domain -

extension MatchesDataDTO {

//    func toDomain() -> MatchEntities {
//        return self.matches.compactMap { $0.toDomain }
//    }
}



extension Match {
    
    func toDomain() -> MatchEntity {
        
        let time = self.status! == Status.finished.rawValue ? getDate(date: self.utcDate) : getMatchTime(date: self.utcDate)
        let entity = MatchEntity(id: self.id ?? 0,
                                 homeTeam: self.homeTeam,
                                 awayTeam: self.awayTeam,
                                 time:time ?? "",
                                 status: Status(rawValue: self.status!) ?? Status.finished,
                                 score: getScore(score: self.score) ?? "",
                                 compareDate: getDate(date: self.utcDate!) ?? "")
        return entity
    }
    
    func getScore(score: Score?) -> String? {
        if let score = score , score.winner != nil  , let homeTeamScore = score.fullTime?.home , let awayTeamScore = score.fullTime?.away {
            return "\(homeTeamScore)  -  \(awayTeamScore)"
        }
        return nil
    }
    
    func getDate(date: String?) -> String?{
        return DateHelper().formatToStr(str: date ?? "", format: .dateFormat, toFormat: .dd_MM_yyyy)
    }
    
    func getMatchTime(date: String?) -> String?{
        return DateHelper().formatToStr(str: date ?? "", format: .dateFormat, toFormat: .time)
    }
    
}
