//
//  CardView.swift
//  Slots
//
//  Created by Le Hoang Anh on 17/01/2021.
//

import SwiftUI

struct CardView: View {

    @Binding var symbol: String
    @Binding var background: Color
    private let transition = AnyTransition.move(edge: .bottom)

    var body: some View {
        VStack {
            switch symbol {
                case "apple":
                    Image(symbol)
                        .resizable()
                        .scaledToFit()
                        .transition(transition)
                case "cherry":
                    Image(symbol)
                        .resizable()
                        .scaledToFit()
                        .transition(transition)
                default:
                    Image(symbol)
                        .resizable()
                        .scaledToFit()
                        .transition(transition)
            }
        }
        .background(background.opacity(0.5))
        .cornerRadius(20)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(symbol: Binding.constant("apple"),
                 background: Binding.constant(Color.white))
    }
}
