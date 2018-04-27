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
    var scores: [Score] = []
    var score : Score?
    
    
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
        board.shuffle(numberOfMoves: 1)
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
//        self.performSegue(withIdentifier: "HighScoresSegue", sender: self)

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
            timer.invalidate()
            solvedBoardAlert(moves: board.moves)
            
        }
    }
    
    func saveScoreInCloudKit(name: String) {
        let newScore = Score(name: name, moves: board.moves, time: time, difficultyLevel: "Easy")
        newScore.delegate = self // set the delegate so that we can alert this view when cloud data is saved or if there is an error
        newScore.saveToCloudkit() // I created a method to save to cloudkit within the class Score
//        scores.append(newScore)
    }
    

    
    func solvedBoardAlert(moves: Int) {
        let alert = UIAlertController(title: "You won in \(moves) moves!!!", message: "Enter your name below", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "Enter your name here"
            textField.autocapitalizationType = .words
            // give textfield a default value or save the name to user defaults, so that the name is saved for next time you play.
        }
        let saveScoreAction = UIAlertAction(title: "Save Score", style: .default, handler: {action in
            
            let textField = alert.textFields![0]
            let name = textField.text ?? ""
            self.saveScoreInCloudKit(name: name)
            self.board.shuffle(numberOfMoves: 20)
            
//            self.performSegue(withIdentifier: "HighScoresSegue", sender: self)
//            self.board.moves = 0
            
        })
        let playAgainAction = UIAlertAction(title: "Play Again", style: .default, handler: {action in
            self.board.shuffle(numberOfMoves: 20)
        })
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(saveScoreAction)
//        alert.addAction(playAgainAction)
//        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
    }
    

    
//    func loadScoresFromCloudkit() {
//        let publicDatabase = CKContainer.default().publicCloudDatabase
//
//        // Initialize Query.  And load all classes.
//        let predicate = NSPredicate(value: true) // this will grab all scores
//        let query = CKQuery(recordType: "Score", predicate: predicate)
//
//        // Configure Query.  Figure out a better way to sort.  Maybe sort by created?
//        query.sortDescriptors = [NSSortDescriptor(key: "moves", ascending: true)]
//
//        publicDatabase.perform(query, inZoneWith: nil) {
//            (records, error) in
//            guard let records = records else {
//                print("Error querying records: ", error as Any)
//                return
//            }
//            print("Found \(records.count) records matching query")
//            if records.count == 0 {
//                // we found no scores.  Display default score.
//                let score = Score(name: "No Scores yet", moves: 0, time: 0, difficultyLevel: "Easy")
//                // populate scores with just the default score
//                self.scores = [score]
//            } else {
//
//                for record in records {
//                    // create a score from the record...
//                    let foundScore = Score(record: record)
//                    self.scores.append(foundScore)
//                }
//            }
//        }
//    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HighScoresSegue" {
            let destVC = segue.destination as! HighScoresViewController
            // pass data here
            

//            destVC.scores = scores
        }
    }
}

extension ViewController: newScoreAddedDelegate {
    // this function will get called after theScore is saved in cloudkit
    func showHighScores() {
        self.performSegue(withIdentifier: "HighScoresSegue", sender: self)
    }
    // this will be called if there is an error in saving the score to cloudkit
    func errorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(yesAction)
        present(alert, animated: true, completion: nil)
    }
}

