//
//  BaseRepoMock.swift
//  PremierLeagueTests
//
//  Created by Mahmoud Abdelshafi on 18/03/2023.
//

import Foundation
import Moya

class BaseRepoMock {
    var shouldSuccess: Bool = false
    var failReponse: MoyaError!
}
