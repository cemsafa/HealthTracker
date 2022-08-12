//
//  APIManager.swift
//  HealthTracker
//
//  Created by Cem Safa on 2022-08-09.
//

import Foundation
import Moya

class APIManager {
    static let provider = apiProvider(target: Server.self, timeout: 10)
    static func apiProvider<T: TargetType>(target: T.Type, timeout: TimeInterval) -> MoyaProvider<T> {
        let plugin: PluginType = NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
        return MoyaProvider<T>(plugins: [plugin])
    }
    
    static let providerNoLog = apiProviderNoLog(target: Server.self, timeout: 10)
    static func apiProviderNoLog<T: TargetType>(target: T.Type, timeout: TimeInterval) -> MoyaProvider<T> {
        return MoyaProvider<T>()
    }
}
