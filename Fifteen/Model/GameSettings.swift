//
//  GameSettings.swift
//  Fifteen
//
//  Created by Christopher Walter on 5/13/18.
//  Copyright © 2018 AssistStat. All rights reserved.
//

import UIKit

class GameSettings {
    var rows = 4
    var columns = 4
    var difficulty = "medium" {
        didSet {
            updateShuffleCount()
        }
    }
    var shuffleCount = 10
    var board: Board
    
    init() {
        rows = 4
        columns = 4
        difficulty = "medium"
        board = Board(rows: rows, columns: columns)
        shuffleCount = 10
        updateShuffleCount()
        
    }
    
    init(rows: Int, columns: Int, difficulty: String, shuffleCount: Int) {
        self.rows = rows
        self.columns = columns
        self.difficulty = difficulty
        board = Board(rows: rows, columns: columns)
        self.shuffleCount = shuffleCount
        updateShuffleCount()
    }
    
    func updateShuffleCount() {
        var shuffleMultiplier = 1
        switch difficulty {
        case "easy":
            shuffleMultiplier = 1
        case "medium":
            shuffleMultiplier = 8
        case "hard":
            shuffleMultiplier = 12
        case "black belt":
            shuffleMultiplier = 50
        default:
            shuffleMultiplier = 8
        }
        
        self.shuffleCount = rows * columns * shuffleMultiplier
        print("changed shuffleCount to \(shuffleCount)")
    }
}
