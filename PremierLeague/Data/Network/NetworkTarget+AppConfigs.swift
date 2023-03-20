//
//  NetworkTarget+AppConfigs.swift
//  PremierLeague
//
//  Created by Mahmoud Abdelshafi on 15/03/2023.
//

import Foundation
import Moya

extension TargetType {
    
    var baseURL: URL {
        guard let url = URL(string: AppConfiguration().apiBaseURL) else { fatalError("Base URL is not valid") }
        return url
    }
    
    var headers: [String: String]? {
        return ["X-Auth-Token": AppConfiguration().apiKey]
    }
    
}
