//
//  Moya+Async.swift
//  PremierLeague
//
//  Created by Mahmoud Abdelshafi on 15/03/2023.
//

import Moya
import Foundation

class AsyncMoyaRequestWrapper {
    internal typealias MoyaContinuation = CheckedContinuation<Result<Response, MoyaError>, Never>
    
    var performRequest: (MoyaContinuation) -> Moya.Cancellable?
    var cancellable: Moya.Cancellable?
    
    init(_ performRequest: @escaping (MoyaContinuation) -> Moya.Cancellable?) {
        self.performRequest = performRequest
    }
    
    func perform(continuation: MoyaContinuation) {
        cancellable = performRequest(continuation)
    }
    
    func cancel() {
        cancellable?.cancel()
    }
}

public extension MoyaProvider {
    func requestAsync(_ target: Target) async -> Result<Response, MoyaError> {
        let asyncRequestWrapper = AsyncMoyaRequestWrapper { [weak self] continuation in
            guard let self = self else { return nil }
            
            return self.request(target) { result in
               
                    switch result {
                    case let .success(response):
                        DispatchQueue.main.async {
                            continuation.resume(returning: .success(response))
                        }
                    case let .failure(moyaError):
                        continuation.resume(returning: .failure(moyaError))
                    }
                }
            
        }
        
        return await withTaskCancellationHandler(operation: {
            await withCheckedContinuation { continuation in
                asyncRequestWrapper.perform(continuation: continuation)
            }
        }, onCancel: {
            asyncRequestWrapper.cancel()
        })
    }
}

extension Result where Failure == Moya.MoyaError {
    init(catching body: () throws -> Success) {
        do {
            self = .success(try body())
        } catch {
            self = .failure(error as! MoyaError)
        }
    }
}

public extension Result where Success == Moya.Response, Failure == Moya.MoyaError {
    func filter<R: RangeExpression>(statusCodes: R) -> Result<Success, Failure> where R.Bound == Int {
        flatMap { response in Result { try response.filter(statusCodes: statusCodes) } }
    }
    
    func filter(statusCode: Int) -> Result<Success, Failure> {
        flatMap { response in Result { try response.filter(statusCode: statusCode) } }
    }
    
    func filterSuccessfulStatusCodes() -> Result<Success, Failure> {
        flatMap { response in Result { try response.filterSuccessfulStatusCodes() } }
    }
    
    func filterSuccessfulStatusAndRedirectCodes() -> Result<Success, Failure> {
        flatMap { response in Result { try response.filterSuccessfulStatusAndRedirectCodes() } }
    }
    
    func mapImage() -> Result<Image, Failure> {
        flatMap { response in Result<Image, Failure> { try response.mapImage() } }
    }
    
    func mapJSON(failsOnEmptyData: Bool = true) -> Result<Any, Failure> {
        flatMap { response in Result<Any, Failure> { try response.mapJSON(failsOnEmptyData: failsOnEmptyData) } }
    }
    
    func mapString(atKeyPath keyPath: String? = nil) -> Result<String, Failure> {
        flatMap { response in Result<String, Failure> { try response.mapString(atKeyPath: keyPath) } }
    }
    
    func map<D: Decodable>(_ type: D.Type, atKeyPath keyPath: String? = nil, using decoder: JSONDecoder = .init(), failsOnEmptyData: Bool = true) -> Result<D, Failure> {
        flatMap { response in Result<D, Failure> { try response.map(type, atKeyPath: keyPath, using: decoder, failsOnEmptyData: failsOnEmptyData) } }
    }
}

