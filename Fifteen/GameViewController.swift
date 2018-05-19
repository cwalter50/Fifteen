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
    var savedBoard: Board?
    var gameScore: Score? // this will be used to pass winning game to highScoresVC
    
    var gameWon = false // this is used to prevent the user from keep moving the board around with swipes after the game is won
    

    var timer: Timer = Timer() // time is kept in the board class
    
    var timerLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 100, y: 0, width: 300, height: 100))
        label.backgroundColor = UIColor.sunFlowerLight
        label.font = UIFont(name: "Avenir", size: 50.0)
        label.text = "0:00"
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    var movesLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 100, y: 0, width: 300, height: 100))
        label.backgroundColor = UIColor.sunFlowerLight
        label.font = UIFont(name: "Avenir", size: 50.0)
        label.text = "Moves: 0"
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
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
        createOrLoadGameBoard()
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
//                self.performSegue(withIdentifier: "HighScoresSegue", sender: self)
                solvedBoardAlert(moves: board.moves)
            }
        }
    }

    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
            self.board.time += 1
            let min = self.board.time / 60
            let sec = self.board.time % 60
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
    
    // this will either load the saved board, or create a new board
    func createOrLoadGameBoard() {
        // load saved Board if it exists, otherwise create a new board
        if let theBoard = savedBoard {
            board = theBoard
        // update timerLabel to fix the 1 second glitch
        let min = self.board.time / 60
        let sec = self.board.time % 60
        let timeText = String(format:"%i:%02i",min, sec)
        self.timerLabel.text = timeText
        } else {
            board = Board(rows: gameSettings.rows, columns: gameSettings.columns)
            // figure out a setting to shuffle board for easy/ medium, or hard
            board.shuffle(numberOfMoves: gameSettings.shuffleCount)
            
        }
        self.view.addSubview(board.backgroundView)

        
    }
    
    @objc func quitGame() {
        print("quitGame tapped")
        navigationController?.popViewController(animated: true)
    }
    @objc func saveGame(sender: UIButton) {
        print("saveGame tapped")
        // save board to user defaults and dismiss
        let userDefaults = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: board)

        userDefaults.set(encodedData, forKey: "savedBoard")
        userDefaults.synchronize() // consider removing????
//        let defaults = UserDefaults.standard
//        defaults.set(board, forKey: "savedGame")
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @objc func resetBoard(sender: UIButton) {
        // reset Moves label to 0, timer label to 0, solve puzzle, then shuffle Again
        board.moves = 0
        timer.invalidate()
        self.board.time = 0
        startTimer()
        updateMovesLabel()
        board.setBoardToInitialState()
        
    }
    
    var gamePaused = false
    @objc func pauseGame(sender: UIButton) {
        gamePaused = !gamePaused
        if gamePaused {
            // stop timer
            timer.invalidate()
            pauseButton.setTitle("Resume", for: .normal)
            // make all numbers disapear
            for tile in board.tiles {
                tile.nameLabel.text = "#"
            }
        } else {
            // DO NOT reset time
            startTimer()
            pauseButton.setTitle("Pause", for: .normal)
            for tile in board.tiles {
                tile.setTileTitle()
            }
            
        }
    }
    
    
    func saveScoreInCloudKit(name: String) {
        let newScore = Score(name: name, moves: board.moves, time: board.time, difficultyLevel: gameSettings.difficultyLevel)
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
            // uncomment after testing
            self.gameScore = Score(name: name, moves: self.board.moves, time: self.board.time, difficultyLevel: self.gameSettings.difficultyLevel)
            self.performSegue(withIdentifier: "HighScoresSegue", sender: self)
//            self.saveScoreInCloudKit(name: name)
            
 
            
            
            //            self.board.shuffle(numberOfMoves: 1)
            //            self.board.moves = 0
            
        })
//        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(yesAction)
        //        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HighScoresSegue" {
            let destVC = segue.destination as! HighScoresViewController
            // pass data here
            destVC.gameScore = self.gameScore
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
