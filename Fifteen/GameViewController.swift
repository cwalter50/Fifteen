//
//  ViewController.swift
//  Fifteen
//
//  Created by Christopher Walter on 4/2/18.
//  Copyright © 2018 AssistStat. All rights reserved.
//

//
//  ViewController.swift
//  Fifteen
//
//  Created by Christopher Walter on 4/2/18.
//  Copyright © 2018 AssistStat. All rights reserved.
//
import UIKit
import CloudKit

class GameViewController: UIViewController {
    
    // MARK: Properties
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    //    var blockWidth: CGFloat = 0.0

    var scores: [Score] = []
    
    var gameSettings = GameSettings() // this carries rows, columns, shuffle, etc

    var board: Board = Board(rows: 4, columns: 4)
    
    var gameWon = false // this is used to prevent the user from keep moving the board around with swipes after the game is won
    
    var time = 0
    var timer: Timer = Timer()
    
    var timerLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 100, y: 0, width: 200, height: 100))
        label.backgroundColor = UIColor.sunFlowerLight
        label.font = UIFont(name: "Avenir", size: 50.0)
        label.text = "0:00"
        label.textAlignment = .center
        return label
    }()
    
    var movesLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 100, y: 0, width: 300, height: 100))
        label.backgroundColor = UIColor.sunFlowerLight
        label.font = UIFont(name: "Avenir", size: 50.0)
        label.text = "Moves: 0"
        label.textAlignment = .center
        return label
    }()
    
    var quitButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 100, y: 0, width: 300, height: 100))
        button.backgroundColor = UIColor.grapefruitDark
        button.titleLabel?.font = UIFont(name: "Avenir", size: 50.0)
        button.setTitle("Quit", for: UIControlState.normal)
        button.addTarget(self, action: #selector(quitGame), for: .primaryActionTriggered)
        return button
    }()
    
    var resetButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 100, y: 0, width: 300, height: 100))
        button.backgroundColor = UIColor.grapefruitDark
        button.titleLabel?.font = UIFont(name: "Avenir", size: 50.0)
        button.setTitle("Reset", for: UIControlState.normal)
        button.addTarget(self, action: #selector(resetBoard), for: .primaryActionTriggered)
        return button
    }()
    
    var pauseButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 100, y: 0, width: 300, height: 100))
        button.backgroundColor = UIColor.sunFlowerDark
        button.titleLabel?.font = UIFont(name: "Avenir", size: 50.0)
        button.setTitle("Pause", for: UIControlState.normal)
        button.titleLabel?.font = UIFont(name: "Avenir", size: 60.0)
        button.addTarget(self, action: #selector(pauseGame), for: .primaryActionTriggered)
        return button
    }()
    
    var saveButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 100, y: 0, width: 300, height: 100))
        button.backgroundColor = UIColor.mintDark
        button.titleLabel?.font = UIFont(name: "Avenir", size: 50.0)
        button.setTitle("Save", for: UIControlState.normal)
        button.addTarget(self, action: #selector(saveGame), for: .primaryActionTriggered)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpSwipeGestures()
        createGameBoard()
        // figure out a setting to shuffle board for easy/ medium, or hard
        board.shuffle(numberOfMoves: gameSettings.shuffleCount)
        //        board.moves = 0 // reset moves after the shuffle so that we start at 0
        createLabelsAndButtons()
        updateMovesLabel()
        
        // start timer
        startTimer()
        
    }
    
    func setUpSwipeGestures() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
    }
    @objc func swiped(sender: UISwipeGestureRecognizer) {
        
        // add logic to move pieces if its a valid direction. Also if the game is not paused or won
        if gameWon == false && gamePaused == false {
            board.moveDirection(direction: sender.direction)
            updateMovesLabel()
            // check if board is solved
            if board.isSolved() {
                print("board solved!!!")
                timer.invalidate()
                solvedBoardAlert(moves: board.moves)
            }
        }
        
    }
    

    
    func startTimer() {
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
    
    func createLabelsAndButtons() {
        self.view.addSubview(timerLabel)
        timerLabel.center = CGPoint(x: width * 0.43, y: height * 0.07)

        self.view.addSubview(movesLabel)
        movesLabel.center = CGPoint(x: width * 0.6, y: height * 0.07)
        self.view.addSubview(quitButton)
        quitButton.center = CGPoint(x: width * 0.2, y: height * 0.94)
        self.view.addSubview(resetButton)
        resetButton.center = CGPoint(x: width * 0.4, y: height * 0.94)
        self.view.addSubview(pauseButton)
        pauseButton.center = CGPoint(x: width * 0.6, y: height * 0.94)
        self.view.addSubview(saveButton)
        saveButton.center = CGPoint(x: width * 0.8, y: height * 0.94)
        
        
        
    }
    func updateMovesLabel() {
        movesLabel.text = "Moves: \(board.moves)"
    }
    
    func createGameBoard() {
        board = Board(rows: gameSettings.rows, columns: gameSettings.columns)
        self.view.addSubview(board.backgroundView)
        
        //        // add target to each tile
        //        for tile in board.tiles {
        //            tile.addTarget(self, action: #selector(tileTapped), for: .primaryActionTriggered)
        //        }
        
    }
    
    @objc func quitGame() {
        print("quitGame tapped")
        navigationController?.popViewController(animated: true)
    }
    @objc func saveGame(sender: UIButton) {
        print("saveGame tapped")
        
    }
    
    @objc func resetBoard(sender: UIButton) {
        // reset Moves label to 0, timer label to 0, solve puzzle, then shuffle Again
        board.moves = 0
        timer.invalidate()
        time = 0
        startTimer()
        board.resetBoard()
        board.shuffle(numberOfMoves: gameSettings.shuffleCount)
        
    }
    
    var gamePaused = false
    @objc func pauseGame(sender: UIButton) {
        gamePaused = !gamePaused
        
        if gamePaused {
            // stop timer
            timer.invalidate()
            // make all numbers disapear
            for tile in board.tiles {
                tile.nameLabel.text = "#"
            }
        } else {
            // DO NOT reset time
            startTimer()
            for tile in board.tiles {
                tile.setTileTitle()
            }
            
        }
    }
    
    
    func saveScoreInCloudKit(name: String) {
        let newScore = Score(name: name, moves: board.moves, time: time, difficultyLevel: "Easy")
        newScore.delegate = self // set the delegate so that we can alert this view when cloud data is saved or if there is an error
        newScore.saveToCloudkit() // I created a method to save to cloudkit within the class Score
        //        scores.append(newScore)
    }
    
    
    
    func solvedBoardAlert(moves: Int) {
        let alert = UIAlertController(title: "You won in \(moves) moves!!!", message: "Enter your name below.", preferredStyle: .alert)
        
        alert.addTextField {textField in
            textField.placeholder = "Enter Name Here"
            textField.autocapitalizationType = .words
            
        }
        let yesAction = UIAlertAction(title: "Save", style: .default, handler: {action in
            
            let nameTF = alert.textFields![0] // force unwrap because we know it's there
            let name = nameTF.text ?? "Hulk"
            self.saveScoreInCloudKit(name: name)
            
            
            //            self.board.shuffle(numberOfMoves: 1)
            //            self.board.moves = 0
            
        })
//        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(yesAction)
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

extension GameViewController: newScoreAddedDelegate {
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