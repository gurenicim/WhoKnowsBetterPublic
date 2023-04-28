//
//  QuizBooleanDelegateSwitch.swift
//  WhoKnowsBetter
//
//  Created by Guren Icim on 28.04.2023.
//

import Foundation

class QuizBooleanDelegateSwitch: ObservableObject {
    static let shared = QuizBooleanDelegateSwitch()
    @Published var isTodaysQuizReceived: Bool = false
}
