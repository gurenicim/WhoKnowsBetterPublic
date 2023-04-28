//
//  AppFlowView.swift
//  WhoKnowsBetter
//
//  Created by Guren Icim on 28.04.2023.
//

import SwiftUI

struct AppFlowView: View {
    @ObservedObject var player: Player = Player(userDefaults: UserDefaults.standard)
    @ObservedObject var isQuizReceived: QuizBooleanDelegateSwitch = QuizBooleanDelegateSwitch.shared
    @ObservedObject var quiz: Quiz = Quiz.shared
    var body: some View {
        ZStack {
            DashBoardPage(player: player).environmentObject(player)
            
            QuizViewPage(isNewQuizReceived: $isQuizReceived.isTodaysQuizReceived, player: player, questionArray: quiz.questionArray)
        }
    }
}
