//
//  Quiz.swift
//  WhoKnowsBetter
//
//  Created by Guren Icim on 28.04.2023.
//

import Foundation

class Quiz: ObservableObject {
    static let shared = Quiz()
    var q1: Question = Question()
    var q2: Question = Question()
    @Published var questionArray: Array<Question> = Array<Question>()
    
    func setQuestionArray(qDict: Dictionary<String,Any>) {
        q1.setQuestionText(questionText: qDict["question1"] as? String ?? "")
        q1.setfirstanswer(firstAnswer: qDict["firstAnswer1"] as? String ?? "")
        q1.setSecondAnswer(secondAnswer: qDict["secondAnswer1"] as? String ?? "")
        q1.setCorrectAnswer(correctAnswer: qDict["correctAnswer1"] as? String ?? "")
        q1.setWeight(weight: Int(qDict["weight1"] as! String) ?? 0)
        q2.setQuestionText(questionText: qDict["question2"] as? String ?? "")
        q2.setfirstanswer(firstAnswer: qDict["firstAnswer2"] as? String ?? "")
        q2.setSecondAnswer(secondAnswer: qDict["secondAnswer2"] as? String ?? "")
        q2.setCorrectAnswer(correctAnswer: qDict["correctAnswer2"] as? String ?? "")
        q2.setWeight(weight: Int(qDict["weight2"] as! String) ?? 0)
        questionArray = [q1,q2]
    }
    
    func setQuestionArray(newQuestionArray: Array<Question>) {
        questionArray = newQuestionArray
    }
    
    func addQuestion(question: Question) {
        questionArray.append(question)
    }
    
    func removeAll() {
        questionArray.removeAll()
    }
    
}
