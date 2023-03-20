//
//  MainViewModel.swift
//  PremierLeague
//
//  Created by Mahmoud Abdelshafi on 15/03/2023.
//

import Foundation
import Combine
import SwiftUI

protocol MainViewModelOutput {
    var state: MatchsListStatus { get set }
    var matcheEntities: [MatchEntities] { get set }
    var isFavorite: Bool { get set }
}

protocol MainViewModelInput {
    func viewAppeared()
    func showFav(_ bool: Bool)
    func toggleFav(item: MatchEntity)
    func checkIfFavourite(match: MatchEntity) -> Bool
}

protocol MainViewModel: ObservableObject, MainViewModelInput, MainViewModelOutput { }

final class DefaultMainViewModel: ObservableObject, MainViewModel {
    
    //MARK: - Properties -
    
    @Published var state: MatchsListStatus = .Loading
    @Published var matcheEntities = [MatchEntities]()
    @Published var isFavorite = false {
        didSet {
            getMatchsGroup()
        }
    }
    
    private(set) var matches = [MatchEntity]()
    
    private(set) var favoriteMatches = [MatchEntity]() {
        didSet {
            getMatchsGroup()
        }
    }
    
    var savedFavoriteIds: Set<Int> = []
    
    //MARK: - Private Properties -
    
    private let fetchMatchesUseCase: FetchMatchesUseCase
    
    private let favouriteMatchsUseCase: FavouriteMatchsUseCase
    
    private var isFirstTimeLoading = true
    
    //MARK: - Init -
    
    init(fetchMatchesUseCase: FetchMatchesUseCase, favouriteMatchsUseCase: FavouriteMatchsUseCase) {
        self.fetchMatchesUseCase = fetchMatchesUseCase
        self.favouriteMatchsUseCase = favouriteMatchsUseCase
    }
    
}

//MARK: - View Model Output -

extension DefaultMainViewModel {
    
    func viewAppeared() {
        if isFirstTimeLoading {
            isFirstTimeLoading = false
            fetchMaches()
        }
    }
    
    private func fetchMaches() {
        Task {
            await getMatches()
            favouriteMatchsUseCase.setFavMatchs(ids: savedFavoriteIds)
            getFavoriteMatches()
        }
    }
    
}

//MARK: - View Model Inputs -

extension DefaultMainViewModel {
    
    func getMatches() async {
        do {
            let matchsData = try await fetchMatches()
            matches = matchsData
            getMatchsGroup()
            savedFavoriteIds = favouriteMatchsUseCase.getFavMatchs() ?? []
        } catch {
            AlertWrapper.showError(error.localizedDescription)
            getMatchsGroup()
        }
    }
    
    func fetchMatches() async throws -> [MatchEntity] {
        try await fetchMatchesUseCase.execute()
    }
    
    func showFav(_ bool: Bool) {
        isFavorite = bool
        getMatchsGroup()
    }
    
    func toggleFav(item: MatchEntity) {
        if savedFavoriteIds.contains(item.id) {
            savedFavoriteIds.remove(item.id)
        } else {
            savedFavoriteIds.insert(item.id)
        }
        favouriteMatchsUseCase.setFavMatchs(ids: savedFavoriteIds)
        getFavoriteMatches()
    }
    
    func checkIfFavourite(match: MatchEntity) -> Bool {
        savedFavoriteIds.contains(match.id)
    }
}

//MARK: - Private Functions -

extension DefaultMainViewModel {
    
    private func getMatchsGroup() {
        var dic = [String: MatchEntities]()
        let matches: [MatchEntity] = isFavorite ? favoriteMatches : self.matches
        for (index, match) in matches.enumerated() {
            let compareDate: String = match.compareDate
            if let _ = dic[compareDate] {
                dic[compareDate]?.matches.append(match)
            } else {
                dic[compareDate] = MatchEntities(
                    id: index,
                    sectionTitle: compareDate,
                    matchDate: DateHelper.date(from: compareDate, with: DatePattern.dd_MM_yyyy)!,
                    matches: [match]
                )
            }
        }
        
        let sortedMatchGroup = dic.map({ $0.value }).sorted { $0.matchDate < $1.matchDate }
        let currentDate = DateHelper().getCurrentDate(with: .dd_MM_yyyy)!
        let nextGroups = sortedMatchGroup.filter({$0.matchDate >= currentDate})
        let lastGroups = sortedMatchGroup.filter({$0.matchDate < currentDate})
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            self.matcheEntities = nextGroups + lastGroups
            self.state = self.isFavorite ? .ShowFavorite(self.matcheEntities): .showMatchesGroup(self.matcheEntities)
        }
        
    }
    
    private func getFavoriteMatches(){
        favoriteMatches = matches.filter { (savedFavoriteIds.contains($0.id)) }
    }
}
