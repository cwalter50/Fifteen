//
//  HighScoresViewController.swift
//  Fifteen
//
//  Created by Christopher Walter on 4/15/18.
//  Copyright © 2018 AssistStat. All rights reserved.
//

import UIKit
import CloudKit

class HighScoresViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: Properties
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    var highTableView: UITableView = UITableView() // this will display all the high scores
    var myTableView: UITableView = UITableView() // this will display personal scores
    var backgroundView: UIView = UIView()
    var scores: [Score] = []
    var gameScore: Score?
    
    var playAgainButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
        button.backgroundColor = UIColor.mintDark
        button.titleLabel?.font = UIFont(name: "Avenir", size: 50.0)
        button.setTitle("Play Again", for: UIControlState.normal)
        button.addTarget(self, action: #selector(playAgainTapped), for: .primaryActionTriggered)
        return button
    }()
    var mainMenuButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 100, y: 0, width: 300, height: 100))
        button.backgroundColor = UIColor.grapefruitDark
        button.titleLabel?.font = UIFont(name: "Avenir", size: 50.0)
        button.setTitle("Main Menu", for: UIControlState.normal)
        button.addTarget(self, action: #selector(mainMenuTapped), for: .primaryActionTriggered)
        return button
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
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        loadScoresFromCloudkit()
    }
    
    // this method is called whenever the focused item changes
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        let button = context.nextFocusedView
        button?.layer.shadowOffset = CGSize(width: 0, height: 10)
        button?.layer.shadowOpacity = 0.6
        button?.layer.shadowRadius = 15
        button?.layer.shadowColor = UIColor.black.cgColor
        context.previouslyFocusedView?.layer.shadowOpacity = 0
    }
    
    @objc func playAgainTapped(sender: UIButton) {
        // add more logic, to make sure that we playAgain
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func mainMenuTapped(sender: UIButton) {
        // figure out how to dismiss to rootVC.
        self.dismiss(animated: true, completion: nil)
    }

    
    func setUpViews() {
//        personalBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: width / 4.0 - 10, height: height * 0.7))
        
        myTableView = UITableView(frame: CGRect(x: 0, y: 0, width: width / 4.0, height: height * 0.7), style: UITableViewStyle.plain)
        myTableView.center = CGPoint(x: width * 0.25, y: height * 0.5)
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.register(HighScoreTableViewCell.self, forCellReuseIdentifier: "myCell")
        self.view.addSubview(self.myTableView)
        myTableView.backgroundColor = UIColor.white
        myTableView.layer.cornerRadius = 10.0
        myTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        highTableView = UITableView(frame: CGRect(x: 0, y: 0, width: width / 4.0, height: height * 0.7), style: UITableViewStyle.plain)
        highTableView.center = CGPoint(x: width * 0.75, y: height * 0.5)
        highTableView.delegate = self
        highTableView.dataSource = self
        highTableView.register(HighScoreTableViewCell.self, forCellReuseIdentifier: "highCell")
        self.view.addSubview(self.highTableView)
        highTableView.tableFooterView = UIView(frame: CGRect.zero)
        highTableView.backgroundColor = UIColor.white
        highTableView.layer.cornerRadius = 10.0
        
        self.view.addSubview(playAgainButton)
        playAgainButton.center = CGPoint(x: width * 0.6, y: height * 0.07)
        self.view.addSubview(mainMenuButton)
        mainMenuButton.center = CGPoint(x: width * 0.4, y: height * 0.07)
        
        backgroundView = PersonalScoresView(theFrame: CGRect(x: 0, y: 0, width: width / 4.0 - 10, height: height * 0.7))
        backgroundView.center = view.center
        backgroundView.backgroundColor = UIColor.mintDark
        backgroundView.layer.cornerRadius = 10.0
        self.view.addSubview(backgroundView)
        
        let theFrame = backgroundView.frame
        let gameScoreView = UIView(frame: CGRect(x: 0, y: 0, width: theFrame.width, height: theFrame.height / 3.0))
            gameScoreView.backgroundColor = UIColor.blueJeansDark
            gameScoreView.layer.cornerRadius = 10.0
        
        var congratsString = "You won!  Congrats!"
        var congratsRange = NSRange(location: 0, length: congratsString.count)
        var levelString = "Level Stats"
        var levelRange = NSRange(location: 0, length: levelString.count)
        var averageString = "Overall Stats"
        var averageRange = NSRange(location: 0, length: averageString.count)
        if let score = gameScore {
            let displayTime = getDisplayTime(time: score.time)
            congratsString = "Congrats \(score.name)!\nYou completed \(score.difficultyLevel)\nMoves: \(score.moves)  Time: \(displayTime)"
            congratsRange = NSRange(location: 0, length: 10 + score.name.count)
            levelString = "\(score.difficultyLevel) Stats\nBest: \(score.moves) moves in \(getDisplayTime(time: score.time))\nAverage: \(score.moves) moves in \(getDisplayTime(time: score.time))"
            levelRange = NSRange(location: 0, length: 6 + score.difficultyLevel.count)
            averageString = "Overall Stats\nBest: \(score.moves) moves in \(getDisplayTime(time: score.time))\nAverage: \(score.moves) moves in \(getDisplayTime(time: score.time))"
            averageRange = NSRange(location: 0, length: 13)
        }
        
        gameScoreView.addSubview(getDisplayLabel(frame: theFrame, string: congratsString, range: congratsRange))
        
        let levelAverageView = UIView(frame: CGRect(x: 0, y: theFrame.height / 3.0, width: theFrame.width, height: theFrame.height / 3.0))
            levelAverageView.backgroundColor = UIColor.sunFlowerDark
            levelAverageView.layer.cornerRadius = 10.0
        
        levelAverageView.addSubview(getDisplayLabel(frame: theFrame, string: levelString, range: levelRange))
        
        let personalAverageView: UIView = UIView(frame: CGRect(x: 0, y: theFrame.height * 2.0 / 3.0, width: theFrame.width, height: theFrame.height / 3.0))
            personalAverageView.backgroundColor = UIColor.aquaDark
            personalAverageView.layer.cornerRadius = 10.0
        
        personalAverageView.addSubview(getDisplayLabel(frame: theFrame, string: averageString, range: averageRange))
        
        backgroundView.addSubview(gameScoreView)
        backgroundView.addSubview(levelAverageView)
        backgroundView.addSubview(personalAverageView)
    }
    
    func getDisplayLabel(frame: CGRect, string: String, range: NSRange) -> UILabel {
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height / 3.0))
        label.font = UIFont(name: "Avenir", size: 50.0)
        label.numberOfLines = 3
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.white
        // create attributedString for label
        let attributes = [NSAttributedStringKey.font:UIFont(name: "Avenir", size: 80)!]
        let displayString = NSMutableAttributedString(string: string)
        
        displayString.addAttributes(attributes, range: range)
        label.attributedText = displayString
        return label
        
    }
    func getDisplayTime(time: Int) -> String {
        let min = time / 60
        let sec = time % 60
        let timeText = String(format:"%i:%02i",min, sec)
        return timeText
    }
    
    func loadScoresFromCloudkit() {
        let publicDatabase = CKContainer.default().publicCloudDatabase
        
        // Initialize Query.  And load all classes.
        let predicate = NSPredicate(value: true) // this will grab all scores
        let query = CKQuery(recordType: "Score", predicate: predicate)
        
        // Configure Query.  Figure out a better way to sort.  Maybe sort by created?
        query.sortDescriptors = [NSSortDescriptor(key: "moves", ascending: true)]
        
        publicDatabase.perform(query, inZoneWith: nil) {
            (records, error) in
            guard let records = records else {
                print("Error querying records: ", error as Any)
                return
            }
            print("Found \(records.count) records matching query")
            if records.count == 0 {
                // we found no scores.  Display default score.
                let score = Score(name: "No Scores yet", moves: 0, time: 0, difficultyLevel: "Easy")
                // populate scores with just the default score
                self.scores = [score]
            } else {
                
                for record in records {
                    // create a score from the record...
                    let foundScore = Score(record: record)
                    self.scores.append(foundScore)
                }
             
                DispatchQueue.main.async(execute: {
                    self.highTableView.reloadData()
                })
            }
        }
    }
    
    // Mark: TableView methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scores.count
//        return 5
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == myTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! HighScoreTableViewCell
            let myScore = scores[indexPath.row]
//            cell.score = myScore
//            cell.rankLabel.text = "\(indexPath.row + 1)"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "highCell", for: indexPath) as! HighScoreTableViewCell
            let myScore = scores[indexPath.row]
//            cell.score = myScore
//            cell.rankLabel.text = "\(indexPath.row + 1)"
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    

}
