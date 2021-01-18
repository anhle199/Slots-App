//
//  CardRowView.swift
//  Slots
//
//  Created by Le Hoang Anh on 17/01/2021.
//

import SwiftUI

struct CardRowView: View {

    @State var symbols: [String]
    @Binding var backgrounds: [Color]
    @Binding var numbers: [Int]

    var body: some View {
        HStack {
            Spacer()

            ForEach(0..<symbols.count, id: \.self) { index in
                CardView(symbol: self.$symbols[numbers[index]],
                         background: self.$backgrounds[index])
            }

            Spacer()
        }
    }
}

struct CardRowView_Previews: PreviewProvider {
    static var previews: some View {
        CardRowView(symbols: ["apple", "cherry", "star"],
                    backgrounds: Binding.constant([Color.red, Color.white, Color.white]),
                    numbers: Binding.constant([0, 0, 0]))
    }
}
