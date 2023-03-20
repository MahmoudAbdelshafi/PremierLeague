//
//  FavouriteMatchsUseCaseTests.swift
//  PremierLeagueTests
//
//  Created by Mahmoud Abdelshafi on 19/03/2023.
//

import XCTest
@testable import PremierLeague

class DefaultFavouriteMatchsUseCaseTests: XCTestCase {

    var useCase: DefaultFavouriteMatchsUseCase!
    var mockRepository: MockMatchesRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockMatchesRepository()
        useCase = DefaultFavouriteMatchsUseCase(matchesRepository: mockRepository)
    }

    override func tearDown() {
        useCase = nil
        mockRepository = nil
        super.tearDown()
    }

    func testGetFavMatchs() {
        // Given
        let expectedIds: Set<Int> = [123, 456]
        mockRepository.favMatchs = expectedIds

        // When
        let result = useCase.getFavMatchs()

        // Then
        XCTAssertEqual(result, expectedIds)
    }

    func testSetFavMatchs() {
        // Given
        let ids: Set<Int> = [789, 012]

        // When
        useCase.setFavMatchs(ids: ids)

        // Then
        XCTAssertEqual(mockRepository.setFavMatchsCallsCount, 1)
        XCTAssertEqual(mockRepository.setFavMatchsReceivedIds, ids)
    }
}

// Mock implementation of MatchesRepository for testing purposes
class MockMatchesRepository: MatchesRepository {
    
    func getMatches() async throws -> [PremierLeague.MatchEntity] {
        return []
    }
    
    var favMatchs: Set<Int>?
    var setFavMatchsCallsCount = 0
    var setFavMatchsReceivedIds: Set<Int>?

    func getFavMatchs() -> Set<Int>? {
        return favMatchs
    }

    func setFavMatchs(ids: Set<Int>) {
        setFavMatchsCallsCount += 1
        setFavMatchsReceivedIds = ids
    }
}
