//
//  LevelsVC.swift
//  Fifteen
//
//  Created by  on 6/13/19.
//  Copyright © 2019 AssistStat. All rights reserved.
//

import UIKit
import CloudKit

class LevelsVC: UIViewController {

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
        label.layer.cornerRadius = 5.0
        return label
    }()
    
    var movesLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 100, y: 0, width: 300, height: 100))
        label.backgroundColor = UIColor.sunFlowerLight
        label.font = UIFont(name: "Avenir", size: 50.0)
        label.text = "Moves: 0"
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.layer.cornerRadius = 5.0
        return label
    }()
    
    var howToButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 100, y: 0, width: 300, height: 100))
        button.backgroundColor = UIColor.mintDark
        button.titleLabel?.font = UIFont(name: "Avenir", size: 50.0)
        button.setTitle("Rules", for: UIControl.State.normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(howToPlay), for: .primaryActionTriggered)
        button.layer.cornerRadius = 5.0
        return button
    }()
    
    var quitButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 100, y: 0, width: 300, height: 100))
        button.backgroundColor = UIColor.grapefruitDark
        button.titleLabel?.font = UIFont(name: "Avenir", size: 50.0)
        button.setTitle("Quit", for: UIControl.State.normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(quitGame), for: .primaryActionTriggered)
        button.layer.cornerRadius = 5.0
        return button
    }()
    
    var resetButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 100, y: 0, width: 300, height: 100))
        button.backgroundColor = UIColor.grapefruitDark
        button.titleLabel?.font = UIFont(name: "Avenir", size: 50.0)
        button.setTitle("Reset", for: UIControl.State.normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(resetBoard), for: .primaryActionTriggered)
        button.layer.cornerRadius = 5.0
        return button
    }()
    
    var pauseButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 100, y: 0, width: 300, height: 100))
        button.backgroundColor = UIColor.sunFlowerDark
        button.titleLabel?.font = UIFont(name: "Avenir", size: 50.0)
        button.setTitle("Pause", for: UIControl.State.normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.font = UIFont(name: "Avenir", size: 60.0)
        button.addTarget(self, action: #selector(pauseGame), for: .primaryActionTriggered)
        button.layer.cornerRadius = 5.0
        return button
    }()
    
    var saveButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 100, y: 0, width: 300, height: 100))
        button.backgroundColor = UIColor.mintDark
        button.titleLabel?.font = UIFont(name: "Avenir", size: 50.0)
        button.setTitle("Save", for: UIControl.State.normal)
        button.addTarget(self, action: #selector(saveGame), for: .primaryActionTriggered)
        button.layer.cornerRadius = 5.0
        return button
    }()
    
    var solutionView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        imageView.image = UIImage(named: "Test")
        imageView.contentMode = .scaleAspectFit
//        imageView.layer.borderColor = UIColor.darkGray.cgColor
//        imageView.layer.borderWidth = 2.0
//        imageView.clipsToBounds = true
//        imageView.layer.cornerRadius = 5.0
        
        return imageView
    }()
    var solutionLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 100, y: 0, width: 300, height: 100))
        label.backgroundColor = UIColor.darkGray
        label.textColor = UIColor.white
        label.font = UIFont(name: "Avenir", size: 18.0)
        label.text = "Solution"
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.layer.cornerRadius = 5.0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        
        setUpSwipeGestures()
        createOrLoadGameBoard()
        #if os(iOS)
        print("running on iOS")
        createLabelsAndButtonsiOS()
        self.title = "Slidearoo"
        
        #elseif os(tvOS)
        print("running on tvOS")
        createLabelsAndButtonstvOS()
        
        #else
        print("OMG, it's that mythical new Apple product!!!")
        createLabelsAndButtonsiOS()
        #endif
        
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
    
    func createLabelsAndButtonstvOS() {
        
        self.view.addSubview(timerLabel)
        timerLabel.center = CGPoint(x: width * 0.43, y: height * 0.07)
        
        self.view.addSubview(movesLabel)
        movesLabel.center = CGPoint(x: width * 0.6, y: height * 0.07)
        self.view.addSubview(howToButton)
        howToButton.center = CGPoint(x: width * 0.1, y: height * 0.94)
        self.view.addSubview(quitButton)
        quitButton.center = CGPoint(x: width * 0.3, y: height * 0.94)
        self.view.addSubview(resetButton)
        resetButton.center = CGPoint(x: width * 0.5, y: height * 0.94)
        self.view.addSubview(pauseButton)
        pauseButton.center = CGPoint(x: width * 0.7, y: height * 0.94)
        self.view.addSubview(saveButton)
        saveButton.center = CGPoint(x: width * 0.9, y: height * 0.94)
    }
    func createLabelsAndButtonsiOS() {
        
        self.view.addSubview(timerLabel)
        
        self.view.addSubview(movesLabel)
        
        self.view.addSubview(solutionView)
        
        let topStackA = UIStackView(arrangedSubviews: [timerLabel, movesLabel])
        topStackA.axis = .vertical
        topStackA.distribution = .fillEqually
        topStackA.alignment = .fill
        topStackA.spacing = 5
        topStackA.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topStackA)
        
        let topStackB = UIStackView(arrangedSubviews: [solutionLabel, solutionView])
        topStackB.axis = .vertical
        topStackB.distribution = .fill
        topStackB.alignment = .fill
        topStackB.spacing = 2
        topStackB.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topStackB)
        
        
        let topStackC = UIStackView(arrangedSubviews: [topStackA, topStackB])
        topStackC.axis = .horizontal
        topStackC.distribution = .fillEqually
        topStackC.alignment = .fill
        topStackC.spacing = 5
        topStackC.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topStackC)
        
        topStackC.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        topStackC.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        topStackC.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        topStackC.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        // bottom buttons
        self.view.addSubview(howToButton)
        self.view.addSubview(quitButton)
        self.view.addSubview(resetButton)
        self.view.addSubview(pauseButton)
        self.view.addSubview(saveButton)
        
        howToButton.titleLabel?.font = UIFont(name: "Avenir", size: 30)
        quitButton.titleLabel?.font = UIFont(name: "Avenir", size: 30)
        resetButton.titleLabel?.font = UIFont(name: "Avenir", size: 30)
        pauseButton.titleLabel?.font = UIFont(name: "Avenir", size: 30)
        saveButton.titleLabel?.font = UIFont(name: "Avenir", size: 30)
        
        let bottomStackA = UIStackView(arrangedSubviews: [howToButton, quitButton, pauseButton])
        bottomStackA.axis = .horizontal
        bottomStackA.distribution = .fillEqually
        bottomStackA.alignment = .fill
        bottomStackA.spacing = 5
        bottomStackA.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomStackA)
        
        let bottomStackB = UIStackView(arrangedSubviews: [resetButton, saveButton])
        bottomStackB.axis = .horizontal
        bottomStackB.distribution = .fillEqually
        bottomStackB.alignment = .fill
        bottomStackB.spacing = 5
        bottomStackB.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomStackB)
        
        bottomStackB.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        bottomStackB.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        bottomStackB.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        bottomStackB.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        bottomStackA.bottomAnchor.constraint(equalTo: bottomStackB.topAnchor, constant: -10).isActive = true
        bottomStackA.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        bottomStackA.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        bottomStackA.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
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
    
    @objc func howToPlay() {
        print("howToPlayTapped")
        performSegue(withIdentifier: "HowToSegue", sender: self)
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
//        newScore.delegate = self // set the delegate so that we can alert this view when cloud data is saved or if there is an error
        newScore.saveToCloudkit() // I created a method to save to cloudkit within the class Score
        //        scores.append(newScore)
    }
    
    func solvedBoardAlert(moves: Int) {
        let alert = UIAlertController(title: "You won in \(moves) moves!!!", message: "Enter your name below.", preferredStyle: .alert)
        
        alert.addTextField {textField in
            textField.placeholder = "Enter Name Here"
            textField.autocapitalizationType = .words
            
        }
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {action in
            
            let nameTF = alert.textFields![0] // force unwrap because we know it's there
            let name = nameTF.text ?? "Hulk"
            // uncomment after testing
            self.gameScore = Score(name: name, moves: self.board.moves, time: self.board.time, difficultyLevel: self.gameSettings.difficultyLevel)
            //            self.performSegue(withIdentifier: "HighScoresSegue", sender: self)
            self.saveScoreInCloudKit(name: name)
            
        })
        let quitAction = UIAlertAction(title: "Quit", style: .cancel, handler: {
            action in
            self.navigationController?.popViewController(animated: true)
        })
        alert.addAction(saveAction)
        alert.addAction(quitAction)
        //        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
    }
    
    // this is called from highScoresVC if the user taps Play Again.
    func playNewGame() {
        // reload the game and playAgain
        board.shuffle(numberOfMoves: gameSettings.shuffleCount)
        board.moves = 0
        timer.invalidate()
        self.board.time = 0
        startTimer()
        updateMovesLabel()
    }
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "HighScoresSegue" {
//            let destVC = segue.destination as! HighScoresViewController
//            // pass data here
//            destVC.gameScore = self.gameScore
//            destVC.delegate = self
//            //            destVC.scores = scores
//        }
//    }
}

//extension GameViewController: newScoreAddedDelegate {
//    // this function will get called after theScore is saved in cloudkit
//    func showHighScores(score: Score) {
//        self.gameScore = score
//        self.performSegue(withIdentifier: "HighScoresSegue", sender: self)
//        print("new Score has been added with difficulty level \(gameScore!.difficultyLevel)")
//    }
//    // this will be called if there is an error in saving the score to cloudkit
//    func errorAlert(message: String) {
//        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
//        let yesAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alert.addAction(yesAction)
//        present(alert, animated: true, completion: nil)
//    }

