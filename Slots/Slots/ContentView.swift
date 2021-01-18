//
//  ContentView.swift
//  Slots
//
//  Created by Le Hoang Anh on 17/01/2021.
//

import SwiftUI

struct ContentView: View {

    private let countRows = 3 // also is number of the columns

//    @State private var symbols = [
//        ["apple", "cherry", "star"],
//        ["apple", "cherry", "star"],
//        ["apple", "cherry", "star"],
//    ]

    private let symbols = ["apple", "cherry", "star"]

    @State private var backgrounds = [
        [Color.white, Color.white, Color.white],
        [Color.white, Color.white, Color.white],
        [Color.white, Color.white, Color.white],
    ]

    @State private var numbers = [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0],
    ]

    @State private var credits = 1000
    private let betAmount = 15

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

                // Credits counter
                Text("Credits: " + String(credits))
                    .foregroundColor(.black)
                    .padding(10)
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(20)

                Spacer()

                // Cards
                VStack {
                    ForEach(0..<countRows) { row in
                        CardRowView(symbols: self.symbols,
                                    backgrounds: self.$backgrounds[row],
                                    numbers: self.$numbers[row])
                    }
                }

                Spacer()

                // Button
                Button(action: {
                    if (credits >= betAmount) {
                        // Set default backgrounds
                        self.backgrounds = self.backgrounds.map { colorsEachRow in
                            colorsEachRow.map { _ in
                                Color.white
                            }
                        }

                        // Random images (index)
                        self.numbers = self.numbers.map { row in
                            row.map { _ in
                                Int.random(in: 0..<countRows)
                            }
                        }


                        var countMatches = 0

                        // Check rows and columns
                        for i in 0..<countRows {
                            if (isMatchRow(at: i)) {
                                countMatches += 1
                                self.updateBackgroundsInRow(at: i)
                            }

                            if (isMatchColumn(at: i)) {
                                countMatches += 1
                                self.updateBackgroundsInColumn(at: i)
                            }
                        }

                        // Check main diagonal
                        if (isMatchMainDiagonal()) {
                            countMatches += 1
                            self.updateBackgroundsInMainDiagonal()
                        }

                        // Check secondary diagonal
                        if (isMatchSecondaryDiagonal()) {
                            countMatches += 1
                            self.updateBackgroundsInSecondaryDiagonal()
                        }

                        // Winning
                        if (countMatches > 0) {
                            if (countMatches == 8) {
                                if (isMatchAllCell()) {
                                    countMatches = 10
                                }
                            }

                            self.credits += countMatches * (betAmount / countRows) * 10
                        } else {
                            self.credits -= betAmount
                        }
                    }

                }) {
                    Text("Spin")
                        .bold()
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 30)
                        .background(Color.pink)
                        .cornerRadius(20)
                }

                Spacer()
            }
        }
    }

    // Check rows
    func isMatchRow(at i: Int) -> Bool {
        for j in 0..<(numbers[i].count - 1) {
            if numbers[i][j] != numbers[i][j + 1] {
                return false
            }
        }

        return true
    }

    // Check columns
    func isMatchColumn(at i: Int) -> Bool {
        for j in 0..<(countRows - 1) {
            if numbers[j][i] != numbers[j + 1][i] {
                return false
            }
        }

        return true
    }

    // Check main diagonal
    func isMatchMainDiagonal() -> Bool {
        for i in 0..<(countRows - 1) {
            if numbers[i][i] != numbers[i + 1][i + 1] {
                return false
            }
        }

        return true
    }

    // Check secondary diagonal
    func isMatchSecondaryDiagonal() -> Bool {
        for i in 0..<(countRows - 1) {
            if numbers[i][countRows - 1 - i] != numbers[i + 1][countRows - 2 - i] {
                return false
            }
        }

        return true
    }

    // Check table
    func isMatchAllCell() -> Bool {
        for row in numbers {
            if !row.allSatisfy( { $0 == numbers[0][0] } ) {
                return false
            }
        }

        return true
    }

    // Update background of row i
    func updateBackgroundsInRow(at i: Int) {
        self.backgrounds[i] = self.backgrounds[i].map { _ in
            Color.green
        }
    }

    // Update background of column i
    func updateBackgroundsInColumn(at i: Int) {
        for j in 0..<countRows {
            self.backgrounds[j][i] = .green
        }
    }

    // Update background of main diagonal
    func updateBackgroundsInMainDiagonal() {
        for i in 0..<countRows {
            self.backgrounds[i][i] = .green
        }
    }

    // Update background of secondary diagonal
    func updateBackgroundsInSecondaryDiagonal() {
        for i in 0..<countRows {
            self.backgrounds[i][countRows - 1 - i] = .green
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
