//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Михайло Дмитрів on 15.12.2023.
//

import SwiftUI
extension Color {
    init(hex: String) {
        var cleanHexCode = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        cleanHexCode = cleanHexCode.replacingOccurrences(of: "#", with: "")
        print(cleanHexCode)
        var rgb: UInt64 = 0
        
        Scanner(string: cleanHexCode).scanHexInt64(&rgb)
        
        let redValue = Double((rgb >> 16) & 0xFF) / 255.0
        let greenValue = Double((rgb >> 8) & 0xFF) / 255.0
        let blueValue = Double(rgb & 0xFF) / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue)
    }
}
let countOfFlags = 3
struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var score = 0
    let maxScore = 8
    @State private var showingAnswer = false
    @State private var scoreTitle = ""
    @State private var isWrongAnswer = false
    @State private var tappedFlag: Int = countOfFlags + 1
    @State private var questionCount = 1
    @State private var showingResult = false
    
    @State private var animationRotateAmount = 0.0
    @State private var animationAmount = 0.0
    

    var body: some View {
        ZStack{
            RadialGradient(stops: [
                .init(color: Color(hex: "#132A13"), location: 0.3),
                .init(color: Color(hex: "#4F772D"), location: 0.3),
            ], center: .top, startRadius: 950, endRadius: 50)
            .ignoresSafeArea()
            VStack
            {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                
                    ForEach(0..<3, id: \.self) {number in
                        if number != tappedFlag {
                            Button {
                                flagTapped(number)
                                animationAmount += 1
                            } label: {
                                Image(countries[number])
                                    .clipShape(.capsule)
                                    .shadow(radius: 5)
                            }
                            .opacity(0.25)
                            .rotation3DEffect(
                                .degrees(animationAmount),
                                                        axis: (x: 1.0, y: 0.0, z: 0.0)
                            )
                        } else {
                            Button {
                                flagTapped(number)
                            } label: {
                                Image(countries[number])
                                    .clipShape(.capsule)
                                    .shadow(radius: 5)
                            }
                            .rotation3DEffect(
                                .degrees(animationRotateAmount),
                                                        axis: /*@START_MENU_TOKEN@*/(x: 0.0, y: 1.0, z: 0.0)/*@END_MENU_TOKEN@*/
                            )
                        }
                                            
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Question \(questionCount)/\(maxScore)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding(20)
        }
        .alert(scoreTitle, isPresented: $showingAnswer) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("\(scoreTitle)! That's the flag of \(countries[tappedFlag])")
            Text("Your score is \(score)/\(maxScore)")
        }
        .alert("Your result is \(score)/\(maxScore)", isPresented: $showingResult) {
            Button("Restart", action: newGame)
        }
    }
    func newGame() {
        questionCount = 0;
        score = 0

        askQuestion()
    }
    func flagTapped(_ number: Int) {
        tappedFlag = number

        withAnimation {
            animationRotateAmount += 360
        }
        withAnimation {
            animationAmount += 90
        }

        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong"
        }
        if questionCount == 8 {
            showingAnswer = false
            showingResult = true
            return
        }
        showingAnswer = true
    }
    
    func askQuestion() {
        animationAmount += 270
        tappedFlag = countOfFlags + 1
        questionCount += 1
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

#Preview {
    ContentView()
}
