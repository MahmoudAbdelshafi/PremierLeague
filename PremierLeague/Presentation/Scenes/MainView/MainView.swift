//
//  MainView.swift
//  PremierLeague
//
//  Created by Mahmoud Abdelshafi on 15/03/2023.
//

import UIKit
import Combine
import SwiftUI

class MainLessonsHostingController: UIHostingController<MainView<DefaultMainViewModel>> {
    
    override init(rootView: MainView<DefaultMainViewModel>) {
        super.init(rootView: rootView)
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

struct MainView<T : MainViewModel> : View {
    
    @ObservedObject var viewModel: T
     @State private var isFavoriteSelected = false
     @State private var selectedIndex = 0
  
     var body: some View {
         VStack() {
             HStack(alignment: .top) {
                 segmentedView()
             }
             Spacer()
             
             switch viewModel.state {
             case .Loading:
                 ProgressView()
             case .showMatchesGroup(let matchesGroup):
                 matchesGroupView(matchesGroup: matchesGroup)
             case .Failure(let error):
                 Text(error)
             case .ShowFavorite(let matchesGroup):
                 matchesGroupView(matchesGroup: matchesGroup)
             }
             Spacer()
             
         }.onAppear{
             UISegmentedControl.appearance().selectedSegmentTintColor = .darkGray
             viewModel.viewAppeared()
         }
     }

     private func segmentedView() -> some View {
         VStack{
             Picker("", selection: $isFavoriteSelected ) {
                 Text(Constans.SegmentedView.all).tag(false)
                 Text(Constans.SegmentedView.favorite).tag(true)
             }
             .pickerStyle(.navigationLink).padding(20).onChange(of: isFavoriteSelected) {
                 viewModel.showFav($0)
             }
         }
     }
  
     private func matchesGroupView(matchesGroup: [MatchEntities]) -> some View {
         List(matchesGroup, id: \.id, rowContent: matchGroupViewSection)
             .listRowSeparator(.hidden)
             .listStyle(.grouped)
             .background(Color.clear)
     }
     
     private func matchGroupViewSection(_ matchGroup: MatchEntities) -> some View {
         Section(header: Text(matchGroup.sectionTitle).font(.title).multilineTextAlignment(.center)) {
             ForEach(matchGroup.matches, id: \.id) { match in
                 MatchCellView(viewModel: viewModel as! DefaultMainViewModel, matchEntity: match)
             }
         }
     }
 }
