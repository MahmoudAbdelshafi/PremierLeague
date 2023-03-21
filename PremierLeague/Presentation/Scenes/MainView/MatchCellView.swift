//
//  MatchCellView.swift
//  PremierLeague
//
//  Created by Mahmoud Abdelshafi on 17/03/2023.
//

import SwiftUI
import Kingfisher

struct MatchCellView: View {
    
    @ObservedObject private var viewModel: DefaultMainViewModel
    private let match: MatchEntity
    let backgroundColor = Color(#colorLiteral(red: 0.06274509804, green: 0.631372549, blue: 0.9568627451, alpha: 1))
    
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
                .fill(backgroundColor)
                .foregroundColor(backgroundColor)
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
            webImage(imageURL: URL( string: match.homeTeam?.crest ?? ""))
                .frame(width: 70, height: 45)
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
                        .font(.subheadline)
                    Text(match.time)
                        .font(.subheadline)
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
            webImage(imageURL: URL( string: match.awayTeam?.crest ?? ""))
            Text(match.awayTeam?.shortName ?? "")
                .font(.system(size: 14))
                .multilineTextAlignment(.center)
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .frame(height: 50)
    }
    
    private func webImage(imageURL: URL?) -> some View {
        KFImage.url(imageURL).placeholder{KFImage.url(URL( string: Constans.placeHolder)).resizable()}.resizable()
            .background(.white)
            .frame(width: 40, height: 40)
            .clipShape(Circle())
    }
}

//struct MatchCellView_Previews: PreviewProvider {
//    static var previews: some View {
////        MatchCellView(viewModel: <#MainViewModel#>, matchEntity: <#MatchEntity#>)
//    }
//}
