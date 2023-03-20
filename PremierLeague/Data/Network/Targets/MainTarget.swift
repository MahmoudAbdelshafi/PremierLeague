//
//  MainTarget.swift
//  PremierLeague
//
//  Created by Mahmoud Abdelshafi on 15/03/2023.
//

import Moya
import Foundation

enum MainTarget {
    case getMatches
}

// MARK: - TargetType

extension MainTarget: TargetType {

    var path: String {
        switch self {
        case .getMatches:
            return "competitions/2021/matches"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getMatches:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .getMatches:
            return .requestPlain
        }
    }

 
}

