//
//  ContentView.swift
//  Slots
//
//  Created by Le Hoang Anh on 17/01/2021.
//

import SwiftUI

struct ContentView: View {

    @State private var isWin = false
    @State private var symbols = ["apple", "cherry", "star"]
    @State private var backgrounds = Array<Color>(repeating: .white, count: 9)
    @State private var backgroundForCredits = Color.white
    @State private var indices = Array<Int>(repeating: 0, count: 9)
    @State private var credits = 1000
    private let betAmount = 5


    var body: some View {
        ZStack {
            // Background
            Rectangle()
                .foregroundColor(Color(red: 200 / 255.0,
                                       green: 143 / 255.0,
                                       blue: 32 / 255.0))
                .edgesIgnoringSafeArea(.all)

            // Background
            Rectangle()
                .foregroundColor(.init(red: 228 / 255.0,
                                       green: 195 / 255.0,
                                       blue: 76 / 255.0))
                .rotationEffect(Angle(degrees: 45))
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()
                
                // Title
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)

                    Text("SwiftUI Slots!")
                        .bold()
                        .foregroundColor(.white)

                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                }
                .scaleEffect(2)

                Spacer()

                HStack(spacing: 30) {
                    // Credits counter
                    Text("Credits: " + String(credits))
                        .foregroundColor(.black)
                        .padding(10)
                        .background(backgroundForCredits.opacity(0.5))
                        .animation(.none)
                        .cornerRadius(20)
                        .scaleEffect(isWin ? 1.2 : 1)
                        .animation(.spring())


                    // Button to reset credits.
                    Button(action: {
                        self.credits = 1000
                        self.backgrounds = self.backgrounds.map { _ in
                            Color.white
                        }
                        self.indices = self.indices.map { _ in
                            0
                        }
                    }) {
                        Text("Reset")
                            .foregroundColor(.black)
                            .padding(10)
                            .background(Color.white.opacity(0.5))
                            .cornerRadius(20)
                    }
                }

                Spacer()

                // Matrix Cards
                VStack {
                    ForEach(0..<3, id: \.self) { number in
                        let start = number * 3
                        let end = (number + 1) * 3

                        HStack {
                            Spacer()

                            ForEach(start..<end, id: \.self) { i in
                                CardView(symbol: self.$symbols[indices[i]],
                                         background: self.$backgrounds[i])
                            }

                            Spacer()
                        }
                    }
                }

                Spacer()

                // Buttons
                HStack(spacing: 30) {
                    VStack {
                        Button(action: {
                            self.processResult()
                        }) {
                            Text("Spin")
                                .bold()
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 30)
                                .background(Color.pink)
                                .cornerRadius(20)
                        }

                        Text("5 credits")
                    }

                    VStack {
                        Button(action: {
                            self.processResult(isMaxSpin: true)
                        }) {
                            Text("Max Spin")
                                .bold()
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 30)
                                .background(Color.pink)
                                .cornerRadius(20)
                        }

                        Text("25 credits")
                    }
                }

                Spacer()
            }
        }
        .animation(.easeOut)
    }

    func processResult(isMaxSpin: Bool = false) {
        if credits >= betAmount {
            self.isWin = false
            self.backgroundForCredits = .white
            self.backgrounds = self.backgrounds.map { _ in
                Color.white
            }

            if !isMaxSpin {
                self.indices[3] = Int.random(in: 0..<3)
                self.indices[4] = Int.random(in: 0..<3)
                self.indices[5] = Int.random(in: 0..<3)

                if isMatch(3, 4, 5) {
                    self.backgroundForCredits = .green
                    self.updateBackgroundForCellMatch(3, 4, 5)
                    self.isWin = true

                    self.credits += betAmount * 3
                } else {
                    self.credits -= betAmount
                }
            } else {
                self.indices = self.indices.map { _ in
                    Int.random(in: 0..<3)
                }

                var matches = 0
                for i in 0..<3 {
                    // Check row i
                    let row = 3 * i
                    if isMatch(row, row + 1, row + 2) {
                        matches += 1

                        // Update backgrounds at row i
                        self.updateBackgroundForCellMatch(row, row + 1, row + 2)
                    }

                    // Check column i
                    if isMatch(i, i + 3, i + 6) {
                        matches += 1

                        // Update backgrounds at column i
                        self.updateBackgroundForCellMatch(i, i + 3, i + 6)
                    }
                }

                // Check main diagonal
                if isMatch(0, 4, 8) {
                    matches += 1

                    // Update backgrounds in main diagonal
                    self.updateBackgroundForCellMatch(0, 4, 8)
                }

                // Check secondary diagonal
                if isMatch(2, 4, 6) {
                    matches += 1

                    // Update backgrounds in secondary diagonal
                    self.updateBackgroundForCellMatch(2, 4, 6)
                }

                if matches == 0 {
                    self.credits -= betAmount * 5
                } else {
                    self.isWin = true
                    var colorForCreditsLabel = Color.green

                    // Match all cells. Bonus 50 credits.
                    if matches == 8 && isMatchAllCell() {
                        self.credits += 50

                        colorForCreditsLabel = .red
                        self.backgrounds = self.backgrounds.map { _ in
                            Color.red
                        }
                    }

                    self.credits += matches * betAmount * 10

                    // Update background for credits counter label
                    self.backgroundForCredits = colorForCreditsLabel
                }
            }
        }
    }

    func isMatch(_ index1: Int, _ index2: Int, _ index3: Int) -> Bool {
        return indices[index1] == indices[index2] && indices[index2] == indices[index3]
    }

    func isMatchAllCell() -> Bool {
        !indices.contains(where: { $0 != indices[0] } )
    }

    func updateBackgroundForCellMatch(_ index1: Int, _ index2: Int, _ index3: Int) {
        self.backgrounds[index1] = .green
        self.backgrounds[index2] = .green
        self.backgrounds[index3] = .green
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
