//
//  FetchMatchesUseCaseTests.swift
//  PremierLeagueTests
//
//  Created by Mahmoud Abdelshafi on 18/03/2023.
//

import XCTest
import Moya
@testable import PremierLeague

final class FetchMatchesUseCaseTests: XCTestCase {
    
    //MARK: - Properties -
    
    private var repoMock: DefaultMatchesRepositoryMock!
    private var useCase: FetchMatchesUseCase!
    
    static let matchs: [PremierLeague.MatchEntity] = {
        let matchEntity1 = PremierLeague.MatchEntity(id: 1, homeTeam: Area(id: 1, name: "area1", shortName: "adas", crest: "sadsa", tla: "sadas"),
                                                awayTeam: Area(id: 1, name: "area1", shortName: "adas", crest: "sadsa", tla: "sadas"),
                                                time: "asda", status: .postponed, score: "asdas", compareDate: "asdasd")
        let matchEntity2 = PremierLeague.MatchEntity(id: 2, homeTeam: Area(id: 2, name: "area2", shortName: "adas", crest: "sadsa", tla: "sadas"),
                                                 awayTeam: Area(id: 2, name: "area1", shortName: "adas", crest: "sadsa", tla: "sadas"),
                                                 time: "asda", status: .postponed, score: "asdas", compareDate: "asdasd")
        return [ matchEntity1, matchEntity2 ]
    }()
    
    
    override func setUpWithError() throws {
        repoMock = DefaultMatchesRepositoryMock()
        useCase = DefaultFetchMatchesUseCase(matchesRepository: repoMock)
    }
    
    override func tearDownWithError() throws {
        repoMock = nil
        useCase = nil
    }
    
    func testFetchMatchesUseCase_whenFaildFetchesMatchs() async throws {
        // given
        let expectation = self.expectation(description: "Fetch Matchs UseCase Faild")
        expectation.expectedFulfillmentCount = 2
        repoMock.matchsData = nil
        repoMock.shouldSuccess = false
        
        // when
        do {
            _ = try await useCase!.execute()
        }
        catch {
            expectation.fulfill()
        }
        // then
        var matchsData: [PremierLeague.MatchEntity]? = []
        do {
            matchsData = try await repoMock.getMatches()
        } catch {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
        XCTAssertTrue(matchsData!.isEmpty)
        XCTAssertNotNil(repoMock.error)
    }
    
    func testFetchMatchesUseCase_whenSuccessfullyFetchesMatchsData() async throws {
        // given
        let expectation = self.expectation(description: "Fetch Matchs UseCase Successfully")
        expectation.expectedFulfillmentCount = 2
        repoMock.matchsData = FetchMatchesUseCaseTests.matchs
        repoMock.shouldSuccess = true

        // when
        do {
            _ = try await useCase!.execute()
            expectation.fulfill()
        }
        
        var matchsData: [PremierLeague.MatchEntity]? = []
        do {
            matchsData = try await repoMock.getMatches()
            expectation.fulfill()
        }
        // then
        wait(for: [expectation], timeout: 5)
        XCTAssertTrue(!matchsData!.isEmpty)
        XCTAssertTrue(matchsData!.contains(where: { $0.homeTeam?.name == "area1" }))
    }

}
