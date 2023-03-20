//
//  MainViewModelTests.swift
//  PremierLeagueTests
//
//  Created by Mahmoud Abdelshafi on 18/03/2023.
//


import XCTest
import Foundation
import Combine
@testable import PremierLeague

class DefaultMainViewModelTests: XCTestCase {
    
    var viewModel: DefaultMainViewModel!
    var mockFetchMatchesUseCase: MockFetchMatchesUseCase!
    var mockFavouriteMatchsUseCase: MockFavouriteMatchsUseCase!
    
    static let area = Area(id: 1, name: "", shortName: "asd", crest: "SS", tla: "FFF")
    static let item = MatchEntity(id: 1,
                           homeTeam: area,
                           awayTeam: area, time: "32423", status: .finished, score: "sadas", compareDate: "asd")
    
    override func setUp() {
        super.setUp()
        mockFetchMatchesUseCase = MockFetchMatchesUseCase()
        mockFavouriteMatchsUseCase = MockFavouriteMatchsUseCase()
        viewModel = DefaultMainViewModel(fetchMatchesUseCase: mockFetchMatchesUseCase,
                                          favouriteMatchsUseCase: mockFavouriteMatchsUseCase)
    }
    
    override func tearDown() {
        super.tearDown()
        viewModel = nil
        mockFetchMatchesUseCase = nil
        mockFavouriteMatchsUseCase = nil
    }

    func test_fetchMatches_success() async {
        let responseExpectation = expectation(description: "response")
        mockFetchMatchesUseCase.isSuccess = true
        do {
            _ = await viewModel.getMatches()
            _ = try await viewModel.fetchMatches()
            viewModel.state = .showMatchesGroup([])
            responseExpectation.fulfill()
        } catch {
            
        }

        wait(for: [responseExpectation], timeout: 5)
        XCTAssertTrue(mockFetchMatchesUseCase.isExecuteCalled, "Execute method should be called")
        XCTAssertEqual(viewModel.state, MatchsListStatus.showMatchesGroup([]), "State should change to match list view model")
    }
    
    func test_fetchMatches_failure() async {
        mockFetchMatchesUseCase.isSuccess = false
        
       _ = await viewModel.getMatches()
        
        XCTAssertTrue(mockFetchMatchesUseCase.isExecuteCalled, "Execute method should be called")
        XCTAssertEqual(viewModel.state, MatchsListStatus.Loading, "State should have been Loading when there is a failure while fetching matches")
    }
    
    func test_showFav() {
        let bool = true
        viewModel.showFav(bool)
        
        XCTAssertNotNil(viewModel.matcheEntities, "matchEntities array should be populated")
        XCTAssertNotNil(viewModel.favoriteMatches, "favoriteMatches array should be populated")
        XCTAssertEqual(viewModel.isFavorite, bool, "isFavorite value should have changed")
    }
    
    func test_toggleFav() {
        let item = DefaultMainViewModelTests.item
        let expectedIds: Set<Int> = [1]
        viewModel.toggleFav(item: item)
        
        XCTAssertNotNil(viewModel.savedFavoriteIds, "savedFavoriteIds set should not be nil")
        XCTAssertEqual(viewModel.savedFavoriteIds, expectedIds, "savedFavoriteIds set should match expectations")
    }
    
    func test_checkIfFavourite() {
        let item = DefaultMainViewModelTests.item
        viewModel.savedFavoriteIds = [item.id]
        XCTAssertTrue(viewModel.checkIfFavourite(match: item), "Item should be favourite as per savedFavoriteIds set")
    }
}

class MockFetchMatchesUseCase: FetchMatchesUseCase {
    var isExecuteCalled = false
    var isSuccess = false
    
    func execute() async throws -> [MatchEntity] {
        isExecuteCalled = true
        if isSuccess {
            return []
        } else {
            throw NSError(domain: "", code: -1, userInfo: nil)
        }
    }
}

class MockFavouriteMatchsUseCase: FavouriteMatchsUseCase {
    var isSetFavMatchsCalled = false
    var isGetFavMatchsCalled = false
    
    func setFavMatchs(ids: Set<Int>) {
        isSetFavMatchsCalled = true
    }
    
    func getFavMatchs() -> Set<Int>? {
        isGetFavMatchsCalled = true
        return nil
    }
}
