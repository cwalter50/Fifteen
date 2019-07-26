//
//  GameSettings.swift
//  Fifteen
//
//  Created by Christopher Walter on 5/13/18.
//  Copyright © 2018 AssistStat. All rights reserved.
//

import UIKit

class GameSettings {
    var rows = 4 {
        didSet {
            updateDifficultyLevel()
        }
    }
    var columns = 4 {
        didSet {
            updateDifficultyLevel()
        }
    }
    var difficulty = "medium" {
        didSet {
            updateShuffleCount()
            updateDifficultyLevel()
        }
    }
    var shuffleCount = 10
    
    // this is formatted as rows x columns difficulty, ie "4 x 3 black belt"
    var difficultyLevel:String = ""
    
    var isWithImage: Bool = false
    var image: UIImage?

    
    init() {
        rows = 4
        columns = 4
        difficulty = "medium"
        shuffleCount = 10
        updateShuffleCount()
        difficultyLevel = "\(rows) x \(columns) \(difficulty)"
        isWithImage = false
        image = nil
        
    }
    
    init(rows: Int, columns: Int, difficulty: String, shuffleCount: Int) {
        self.rows = rows
        self.columns = columns
        self.difficulty = difficulty
        difficultyLevel = "\(rows) x \(columns) \(difficulty)"

        self.shuffleCount = shuffleCount
        updateShuffleCount()
        isWithImage = false
        image = nil
    }
    
    convenience init(rows: Int, columns: Int, difficulty: String, shuffleCount: Int, image: UIImage?) {
        self.init(rows: rows, columns: columns, difficulty: difficulty, shuffleCount: shuffleCount)
        
        isWithImage = true
        self.image = image
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
        // this line is just for testing.  Uncomment below to update after testing is complete
//        self.shuffleCount = 3
        self.shuffleCount = rows * columns * shuffleMultiplier
        print("changed shuffleCount to \(shuffleCount)")
    }
    
    func updateDifficultyLevel() {
        self.difficultyLevel = "\(rows) x \(columns) \(difficulty)"
    }
}
