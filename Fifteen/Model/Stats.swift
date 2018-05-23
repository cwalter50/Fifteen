//
//  HighScoreResults.swift
//  Fifteen
//
//  Created by Christopher Walter on 5/21/18.
//  Copyright © 2018 AssistStat. All rights reserved.
//

import UIKit

// this class is created to quickly calculate averages, fastest, shortestMoves, etc. for personalScores
class Stats {
//    var allScores: [Score] = []
//    var allLevelScores: [Score] = []
    var personalScores: [Score] = []
    var personalLevelScores: [Score] = []
    var averageLevelTime: Int
    var averageLevelMoves: Int
    var bestTimeLevel: Int
    var leastMovesLevel: Int
    var gamesPlayedLevel: Int
    var gamesPlayedTotal: Int
    var averageTotalTime: Int
    var averageTotalMoves: Int
    var bestTime: Int
    var leastMoves: Int
    
    init(scores: [Score], difficultyLevel: String) {
        self.personalScores = scores
        self.personalLevelScores = []
        self.gamesPlayedTotal = scores.count
        var totalTime = 0 // this will be used to help find average
        var totalMoves = 0 // this is used to find average
        var totalTimeLevel = 0
        var totalMovesLevel = 0
        self.bestTime = 1000000 // set to a really high number, so that we can beat it easily
        self.leastMoves = 1000000
        self.bestTimeLevel = 10000000
        self.leastMovesLevel = 1000000
        
        for score in scores {
            if score.time < bestTime {
                bestTime = score.time
            }
            if score.moves < leastMoves {
                leastMoves = score.moves
            }
            totalTime += score.time
            totalMoves += score.moves
            
            if score.difficultyLevel == difficultyLevel {
                personalLevelScores.append(score)
                if score.time < bestTimeLevel {
                    bestTimeLevel = score.time
                }
                if score.moves < leastMovesLevel {
                    leastMovesLevel = score.moves
                }
                totalTimeLevel += score.time
                totalMovesLevel += score.moves
            }
            
        }
        self.gamesPlayedLevel = personalLevelScores.count
        self.gamesPlayedTotal = scores.count
        if scores.count > 0 {
            self.averageTotalTime = totalTime / scores.count
            self.averageTotalMoves = totalMoves / scores.count
        } else {
            averageTotalTime = 0
            averageTotalMoves = 0
        }
        if personalLevelScores.count > 0 {
            self.averageLevelTime = totalTimeLevel / personalLevelScores.count
            self.averageLevelMoves = totalMovesLevel / personalLevelScores.count
        } else {
            averageLevelTime = 0
            averageLevelMoves = 0
        }
    }
}
