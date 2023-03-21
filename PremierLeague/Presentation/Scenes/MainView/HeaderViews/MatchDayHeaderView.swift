//
//  MatchDayHeaderView.swift
//  PremierLeague
//
//  Created by Mahmoud Abdelshafi on 21/03/2023.
//

import SwiftUI

struct MatchDayHeaderView: View {
    var title: String
    var color: Color
    
    var body: some View {
        HStack(alignment: .center, spacing: 8.0) {
            DividerView(color: color)
            
            Text(title)
                .font(.subheadline)
                .bold()
                .foregroundColor(.black)
            DividerView(color: color)
        }
        .padding()
    }
}

struct DividerView: View {
    let color: Color
    
    var body: some View {
        color
            .frame(height: 1)
            .clipShape(RoundedRectangle(cornerRadius: 1, style: .continuous))
    }
}
