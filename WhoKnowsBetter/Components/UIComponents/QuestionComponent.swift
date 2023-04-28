//
//  QuestionComponent.swift
//  WhoKnowsBetter
//
//  Created by Guren Icim on 24.04.2023.
//

import SwiftUI

struct QuestionComponent: View {
    var question: Question = Question()
    @Binding var doneCount: Int
    @Binding var correctAnswerCount: Int
    @Binding var passCount: Int
    @Binding var wrongAnswerCount: Int
    @Binding var point: Int
    @State var backgroundColor: Color = .yellow
    @State var isDisabled: Bool = false
    
    var body: some View {
        questionView
    }
    
    var questionView: some View {
        VStack {
            Label(question.getQuestionText(), systemImage: "questionmark.circle").labelStyle(.titleOnly).padding(20)
            VStack{
                // First Answer
                Button(action: {
                    evaluate(answer: question.getFirstAnswer())
                    isDisabled = true
                    doneCount += 1
                }, label: { Text(question.getFirstAnswer()).foregroundColor(.white)
                    })
                .padding(.horizontal, 24).padding(.vertical,10).background(
                    RoundedRectangle(cornerRadius: 50, style: .continuous).fill(Color.black.opacity(0.3))
                ).disabled(isDisabled)
                // Pass
                Button(action: {
                    passCount+=1
                    backgroundColor = .gray
                    isDisabled = true
                    doneCount += 1
                }, label: { Text("Pass").foregroundColor(.black)
                }).padding(.horizontal, 24).padding(.vertical,10).background(
                    RoundedRectangle(cornerRadius: 50, style: .continuous).fill(Color.white.opacity(0.5))
                ).disabled(isDisabled)
                // Second Answer
                Button(action: {
                    evaluate(answer: question.getSecondAnswer())
                    isDisabled = true
                    doneCount += 1
                }, label: { Text(question.getSecondAnswer()).foregroundColor(.white)
                    })                .padding(.horizontal, 24).padding(.vertical,10).background(
                        RoundedRectangle(cornerRadius: 50, style: .continuous).fill(Color.black.opacity(0.3))
                    ).disabled(isDisabled)
            }
        }.padding(.horizontal,36).padding().background(
            RoundedRectangle(cornerRadius: 50, style: .continuous).fill(backgroundColor.opacity(0.7))
        )
    }
    
    func evaluate(answer: String) {
        if answer == question.getCorrectAnswer() {
            correctAnswerCount+=1
            point+=question.getWeight()
            backgroundColor = .green
        } else {
            wrongAnswerCount+=1
            point-=question.getWeight()
            backgroundColor = .red
        }
    }
    
}
