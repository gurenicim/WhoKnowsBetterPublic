//
//  Question.swift
//  WhoKnowsBetter
//
//  Created by Guren Icim on 24.04.2023.
//

import Foundation

class Question: Identifiable {
    
    private var questionText: String
    private var firstAnswer: String
    private var secondAnswer: String
    private var correctAnswer: String
    private var weight: Int
    
    static func == (lhs: Question, rhs: Question) -> Bool {
        if (lhs.correctAnswer == rhs.correctAnswer) && (lhs.firstAnswer == rhs.firstAnswer) && (lhs.questionText  == rhs.questionText) && (lhs.secondAnswer == rhs.secondAnswer) && (lhs.weight == rhs.weight) {
            return true
        } else {
            return false
        }
    }
    
    init(questionText: String = "Did you like the app?", firstAnswer: String = "Yes", secondAnswer: String = "No", correctAnswer: String = "Yes", weight: Int = 50
    ) {
        self.questionText = questionText
        self.firstAnswer = firstAnswer
        self.secondAnswer = secondAnswer
        self.correctAnswer = correctAnswer
        self.weight = weight
    }
    
    func setQuestionText(questionText: String) {
        self.questionText =  questionText
    }
    
    func setfirstanswer(firstAnswer: String) {
        self.firstAnswer =  firstAnswer
    }
    
    func setSecondAnswer(secondAnswer: String) {
        self.secondAnswer =  secondAnswer
    }
    
    func setCorrectAnswer(correctAnswer: String) {
        self.correctAnswer =  correctAnswer
    }
    
    func setWeight(weight: Int) {
        self.weight =  weight
    }
    
    func getQuestionText() -> String {
        return questionText
    }
    
    func getFirstAnswer() -> String {
        return firstAnswer
    }
    
    func getSecondAnswer() -> String {
        return secondAnswer
    }
    
    func getCorrectAnswer() -> String {
        return correctAnswer
    }
    
    func getWeight() -> Int {
        return weight
    }
}
