//
//  MatchesRepositoryTests.swift
//  PremierLeagueTests
//
//  Created by Mahmoud Abdelshafi on 18/03/2023.
//

import XCTest
@testable import PremierLeague
import Moya

final class MatchesRepositoryTests: XCTestCase {
    
    private var repo: MatchesRepository!
    private var useCase: DefaultFetchMatchesUseCaseMock!

    override func setUpWithError() throws {
        repo = DefaultGetMatchesRepository(provider: MoyaProvider<MainTarget>())
        useCase = DefaultFetchMatchesUseCaseMock(matchesRepository: repo)
    }

    override func tearDownWithError() throws {
        repo = nil
        useCase = nil
    }
    
    func testExecuteMatchsUseCase_whenFaildMatchsExecution() async {
        // given
        let expectation = self.expectation(description: "execute UseCase Faild")
        expectation.expectedFulfillmentCount = 1
        useCase.success = false
        var matchs = [PremierLeague.MatchEntity]()
        // when
        do {
            matchs = try await useCase!.execute()
            matchs = try await repo.getMatches()
        } catch {
            expectation.fulfill()
        }
       
        wait(for: [expectation], timeout: 5)
        XCTAssertTrue(matchs.isEmpty)
        XCTAssertTrue(useCase.matchs.isEmpty)
        XCTAssertNotNil(useCase.error)
    }
    
    
    func testExecuteMatchsUseCase_whenSuccessMatchsExecution() async {
        // given
        let expectation = self.expectation(description: "execute UseCase success")
        expectation.expectedFulfillmentCount = 1
        useCase.success = true
        var matchs = [PremierLeague.MatchEntity]()
        // when
        do {
            matchs = try await useCase!.execute()
            expectation.fulfill()
        } catch {
            
        }
        
        wait(for: [expectation], timeout: 5)
        XCTAssertFalse(matchs.isEmpty)
        XCTAssertFalse(useCase.matchs.isEmpty)
        XCTAssertTrue(matchs.contains(where: { $0.homeTeam?.name == "area1" }))
        XCTAssertNil(useCase.error)
    }


    
    class DefaultFetchMatchesUseCaseMock: FetchMatchesUseCase {
        
        private let matchesRepository: MatchesRepository
        var success: Bool!
        var matchs: [PremierLeague.MatchEntity] = []
        var error: MoyaError?
        
        init(matchesRepository: MatchesRepository) {
            self.matchesRepository = matchesRepository
        }
        
        func execute() async throws -> [PremierLeague.MatchEntity] {
            if success {
                matchs = FetchMatchesUseCaseTests.matchs
                return matchs
            }else {
                error = MoyaError.requestMapping("")
                throw error!
            }
        }
        
    }
}
