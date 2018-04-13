//
//  ViewController.swift
//  Fifteen
//
//  Created by Christopher Walter on 4/2/18.
//  Copyright © 2018 AssistStat. All rights reserved.
//

import UIKit
import CloudKit

class ViewController: UIViewController {

    // MARK: Properties
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
//    var blockWidth: CGFloat = 0.0
    var board: Board = Board(rows: 4, columns: 4)
    
    var timerLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 100, y: 0, width: 200, height: 100))
        label.text = "0:00"
        return label
    }()
    
    var movesLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 100, y: 0, width: 200, height: 100))
        label.text = "Moves: 0"
        return label
    }()
    
    var time = 0
    var timer: Timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createGameBoard()
        // figure out a setting to shuffle board for easy/ medium, or hard
        board.shuffle(numberOfMoves: 5)
//        board.moves = 0 // reset moves after the shuffle so that we start at 0

        
        createTimerAndMovesLabel()
        updateMovesLabel()
        
        // start timer
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
            self.time += 1
            let min = self.time / 60
            let sec = self.time % 60
            let timeText = String(format:"%i:%02i",min, sec)
            self.timerLabel.text = timeText
            })
        
    }
    
    // this method is called whenever the focused item changes
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        let tile = context.nextFocusedView
        tile?.layer.shadowOffset = CGSize(width: 0, height: 10)
        tile?.layer.shadowOpacity = 0.6
        tile?.layer.shadowRadius = 15
        tile?.layer.shadowColor = UIColor.black.cgColor
        context.previouslyFocusedView?.layer.shadowOpacity = 0
    }
    
    func createTimerAndMovesLabel() {
        self.view.addSubview(timerLabel)
        timerLabel.center.x = width * 0.43
        timerLabel.center.y = height * 0.07
        
        self.view.addSubview(movesLabel)
        movesLabel.center.x = width * 0.6
        movesLabel.center.y = height * 0.07
        
    }
    func updateMovesLabel() {
        movesLabel.text = "Moves: \(board.moves)"
    }
    
    func createGameBoard() {
        self.view.addSubview(board.backgroundView)
        
        // add target to each tile
        for tile in board.tiles {
            tile.addTarget(self, action: #selector(tileTapped), for: .primaryActionTriggered)
        }
        
    }
    
    @objc func tileTapped(sender: Tile) {
        print("\(sender.name) was tapped.")

        if board.isNextToEmptySquare(position: sender.position) {
            board.move(startPosition: sender.position)
        }
        else {
            print("tile: \(sender.name) is invalid to move")
//            board.resetBoard()
        }
        updateMovesLabel()
        // check if board is solved
        if board.isSolved() {
            print("board solved!!!")
            saveScoreInCloudKit()
            solvedBoardAlert(moves: board.moves)
            
        }
    }
    
    func saveScoreInCloudKit() {
        let newScore = Score(name: "Test", moves: board.moves, time: time, difficultyLevel: "Easy")
        
        newScore.saveToCloudkit()
       
    }
    
    func solvedBoardAlert(moves: Int) {
        let alert = UIAlertController(title: "You won in \(moves) moves!!!", message: "Would you like to play again?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: {action in
            self.board.shuffle(numberOfMoves: 20)
//            self.board.moves = 0
            
        })
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
    }

    


}

