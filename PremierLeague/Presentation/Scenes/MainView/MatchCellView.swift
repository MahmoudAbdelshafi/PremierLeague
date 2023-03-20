//
//  MatchCellView.swift
//  PremierLeague
//
//  Created by Mahmoud Abdelshafi on 17/03/2023.
//

import SwiftUI

struct MatchCellView: View {
    
    @ObservedObject private var viewModel: DefaultMainViewModel
    private let match: MatchEntity
    
    init(viewModel: DefaultMainViewModel, matchEntity: MatchEntity) {
        self.viewModel = viewModel
        self.match = matchEntity
    }
    
    var body: some View  {
        VStack(alignment:.listRowSeparatorTrailing) {
            starImage
            HStack(alignment: .center) {
                homeTeamName
                scoreOrTime
                awayTeamName
            }.padding(8)
        }
        .background(
            RoundedRectangle(cornerRadius:  5, style: .continuous)
                .fill(Color.gray)
                .foregroundColor(.gray)
        )
        .padding(8)
    }
    
    private var starImage: some View {
        Image(systemName: viewModel.checkIfFavourite(match: match) ? "star.fill" : "star")
            .foregroundColor(viewModel.checkIfFavourite(match: match) ? .red : .black)
            .padding(8)
            .padding(.leading, 5)
            .font(.system(size: 15))
            .onTapGesture {
                viewModel.toggleFav(item: match)
            }
    }
    
    private var homeTeamName: some View {
        VStack(alignment: .center) {
            Text(match.homeTeam?.shortName ?? "")
                .font(.system(size: 14))
                .multilineTextAlignment(.center)
        }
        .frame(minWidth: 0, maxWidth: .infinity)
    }
    
    private var scoreOrTime: some View {
        HStack(alignment: .center) {
            if match.status == .finished {
                VStack {
                    Text("\(match.score)")
                        .font(.largeTitle)
                }
            } else {
                VStack {
                    Text("Time")
                        .font(.headline)
                        .padding(.bottom, 8)
                    Text(match.time )
                        .font(.headline)
                }
                .frame(maxWidth: .infinity)
                .alignmentGuide(HorizontalAlignment.center) { d in
                    d[HorizontalAlignment.trailing]
                }
                .alignmentGuide(VerticalAlignment.center) { d in
                    d[VerticalAlignment.center]
                }
            }
        }
    }
    
    private var awayTeamName: some View {
        VStack(alignment: .center) {
            Text(match.awayTeam?.shortName ?? "")
                .font(.system(size: 14))
                .multilineTextAlignment(.center)
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .frame(height: 50)
    }
}

//struct MatchCellView_Previews: PreviewProvider {
//    static var previews: some View {
////        MatchCellView(viewModel: <#MainViewModel#>, matchEntity: <#MatchEntity#>)
//    }
//}
