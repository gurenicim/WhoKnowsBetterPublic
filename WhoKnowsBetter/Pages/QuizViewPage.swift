//
//  QuizViewPage.swift
//  WhoKnowsBetter
//
//  Created by Guren Icim on 24.04.2023.
//

import SwiftUI

struct QuizViewPage: View {
    @State var doneCount: Int = 0
    @State var correctAnswerCount: Int = 0
    @State var passCount: Int = 0
    @State var wrongAnswerCount: Int = 0
    @State var point: Int = 0
    @Binding var isNewQuizReceived: Bool
    @ObservedObject var player: Player
    var quiz: Quiz = Quiz.shared
    var edgeTransition: AnyTransition = .move(edge: .bottom)
    var body: some View {
        ZStack {
            if isNewQuizReceived {
                Color.white
                    .ignoresSafeArea()
                VStack {
                    Spacer().frame(height: 42)
                    ScrollView {
                        ForEach(quiz.questionArray) { question in
                            QuestionComponent(question: question, doneCount: $doneCount, correctAnswerCount: $correctAnswerCount, passCount: $passCount, wrongAnswerCount: $wrongAnswerCount, point: $point).padding(16)
                            
                        }
                    }.scrollContentBackground(.hidden).listRowSeparator(.hidden).listSectionSeparator(.hidden)
                    HStack{
                        Spacer()
                        Button(action: {
                            UserDefaults.standard.set(false, forKey: "isNewQuizReceived")
                            isNewQuizReceived = false
                            player.correctAnswerCount += correctAnswerCount
                            player.passCount += passCount
                            player.wrongAnswerCount += wrongAnswerCount
                            player.point += point
                            doneCount = 0
                            correctAnswerCount = 0
                            passCount = 0
                            wrongAnswerCount = 0
                            point = 0
                            player.updateStats()
                            quiz.removeAll()
                        }, label: {
                            Text("Done").font(.system(.title2)).foregroundColor(.black)
                        }).frame(minWidth: 150).padding(16).background(RoundedRectangle(cornerRadius: 50).fill(Color.green.opacity(0.7))).contentShape(RoundedRectangle(cornerRadius: 50))
                            .disabled(doneCount<2)
                        Spacer()
                    }.padding(16)
                }.transition(edgeTransition)
            }
        }.animation(.easeInOut(duration: 0.5) , value: isNewQuizReceived)
    }
}
