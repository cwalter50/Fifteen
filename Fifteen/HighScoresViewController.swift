//
//  HighScoresViewController.swift
//  Fifteen
//
//  Created by Christopher Walter on 4/15/18.
//  Copyright © 2018 AssistStat. All rights reserved.
//

import UIKit
import CloudKit

protocol PlayAgainDelegate {
    func playNewGame()
}

class HighScoresViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: Properties
    
    var delegate: PlayAgainDelegate?
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    var highTableView: UITableView = UITableView() // this will display all the high scores
    var myTableView: UITableView = UITableView() // this will display personal scores
    var backgroundView: UIView = UIView()
    var gameScoreLabel: UILabel = UILabel()
    var levelAverageLabel: UILabel = UILabel()
    var personalAverageLabel: UILabel = UILabel()
    var allScores: [Score] = []
    var personalScores: [Score] = []
    var stats: Stats = Stats(scores: [], difficultyLevel: "easy")
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

        if let score = gameScore {
            stats = Stats(scores: [score], difficultyLevel: score.difficultyLevel)
            self.reloadBackgroundViewLabels(stats: stats)
        }
        loadAllScoresFromCloudkit()
        loadPersonalScoresFromCloudkit()

    }
    override func viewDidAppear(_ animated: Bool) {

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

        navigationController?.popViewController(animated: true)
        delegate?.playNewGame()
    }
    
    @objc func mainMenuTapped(sender: UIButton) {
        // figure out how to dismiss to rootVC.
    
        navigationController?.popToRootViewController(animated: true)
        
    }

    
    func setUpViews() {

        myTableView = UITableView(frame: CGRect(x: 0, y: 0, width: width / 4.0, height: height * 0.7), style: UITableViewStyle.plain)
        myTableView.center = CGPoint(x: width * 0.25 - 10, y: height * 0.5 + 10.0)
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.register(HighScoreTableViewCell.self, forCellReuseIdentifier: "myCell")
        self.view.addSubview(self.myTableView)
        myTableView.backgroundColor = UIColor.clear
        myTableView.layer.cornerRadius = 10.0
        myTableView.tableFooterView = UIView(frame: CGRect.zero)
        // created a custom function to get headerView
        myTableView.tableHeaderView = getHeaderView(text: "Personal Best Scores")

        highTableView = UITableView(frame: CGRect(x: 0, y: 0, width: width / 4.0, height: height * 0.7), style: UITableViewStyle.plain)
        highTableView.center = CGPoint(x: width * 0.75 + 10.0, y: height * 0.5 + 10)
        highTableView.delegate = self
        highTableView.dataSource = self
        highTableView.register(HighScoreTableViewCell.self, forCellReuseIdentifier: "highCell")
        self.view.addSubview(self.highTableView)
        highTableView.tableFooterView = UIView(frame: CGRect.zero)
        highTableView.backgroundColor = UIColor.clear
        highTableView.layer.cornerRadius = 10.0
        highTableView.tableHeaderView = getHeaderView(text: "All-Time Best Scores")
        
        self.view.addSubview(playAgainButton)
        playAgainButton.center = CGPoint(x: width * 0.6, y: height * 0.1)

        self.view.addSubview(mainMenuButton)
        mainMenuButton.center = CGPoint(x: width * 0.4, y: height * 0.1)
        
        backgroundView = UIView(frame:CGRect(x: 0, y: 0, width: width / 4.0 - 10, height: height * 0.7))
        
        backgroundView.center = CGPoint(x: view.center.x, y: view.center.y + 10)
        backgroundView.backgroundColor = UIColor.clear
        backgroundView.layer.cornerRadius = 10.0
        self.view.addSubview(backgroundView)
        
        let theFrame = backgroundView.frame
        let gameScoreView = UIView(frame: CGRect(x: 0, y: 0, width: theFrame.width, height: theFrame.height / 3.0 - 5.0))
            gameScoreView.backgroundColor = UIColor.blueJeansDark
            gameScoreView.layer.cornerRadius = 10.0
        
        gameScoreLabel = getDisplayLabel(frame: theFrame, numberOfLines: 3)
        gameScoreView.addSubview(gameScoreLabel)
        
        let levelAverageView = UIView(frame: CGRect(x: 0, y: theFrame.height / 3.0, width: theFrame.width, height: theFrame.height / 3.0 - 5.0))
            levelAverageView.backgroundColor = UIColor.sunFlowerDark
            levelAverageView.layer.cornerRadius = 10.0
        levelAverageLabel = getDisplayLabel(frame: theFrame, numberOfLines: 4)
        levelAverageView.addSubview(levelAverageLabel)
        
        let personalAverageView: UIView = UIView(frame: CGRect(x: 0, y: theFrame.height * 2.0 / 3.0, width: theFrame.width, height: theFrame.height / 3.0 - 5.0))
            personalAverageView.backgroundColor = UIColor.aquaDark
            personalAverageView.layer.cornerRadius = 10.0
        personalAverageLabel = getDisplayLabel(frame: theFrame, numberOfLines: 4)
        personalAverageView.addSubview(personalAverageLabel)
        
        
        backgroundView.addSubview(gameScoreView)
        backgroundView.addSubview(levelAverageView)
        backgroundView.addSubview(personalAverageView)
        
        reloadBackgroundViewLabels(stats: stats)
    }
    
    func getHeaderView(text: String) -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: myTableView.frame.width, height: 100))
        headerView.backgroundColor = UIColor.blueJeansDark
        headerView.layer.cornerRadius = 10.0
        let headerLabel = UILabel(frame: headerView.frame)
        headerLabel.font = UIFont(name: "Avenir", size: 60)
        headerLabel.textColor = UIColor.white
        headerLabel.textAlignment = .center
        headerLabel.adjustsFontSizeToFitWidth = true
        headerLabel.text = text
        headerView.addSubview(headerLabel)
        return headerView
    }
    
    func getDisplayLabel(frame: CGRect, numberOfLines: Int) -> UILabel {
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height / 3.0))
        label.font = UIFont(name: "Avenir", size: 50.0)
        label.numberOfLines = numberOfLines
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.black
        // create attributedString for label
        label.text = ""
        return label
        
    }
    func getDisplayTime(time: Int) -> String {
        let min = time / 60
        let sec = time % 60
        let timeText = String(format:"%i:%02i",min, sec)
        return timeText
    }
    
    func getLabelsAttributedText(string: String, range: NSRange) -> NSAttributedString {
        // create attributedString for label
        let attributes = [NSAttributedStringKey.font:UIFont(name: "Avenir", size: 80)!]
        let displayString = NSMutableAttributedString(string: string)
        
        displayString.addAttributes(attributes, range: range)
        return displayString
    }
    
    func reloadBackgroundViewLabels(stats: Stats) {
        
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
        
            levelString = "\(score.difficultyLevel) Stats\nBest: \(stats.leastMovesLevel) moves, \(getDisplayTime(time: stats.bestTimeLevel)) time\nAverage: \(stats.averageLevelMoves) moves in \(getDisplayTime(time: stats.averageLevelTime))\nGames Won: \(stats.gamesPlayedLevel)"
            levelRange = NSRange(location: 0, length: 6 + score.difficultyLevel.count)
            
            averageString = "Overall Stats\nBest: \(stats.leastMoves) moves, \(getDisplayTime(time: stats.bestTime)) time\nAverage: \(stats.averageTotalMoves) moves in \(getDisplayTime(time: stats.averageLevelTime))\nGames Won: \(stats.gamesPlayedTotal)"
            averageRange = NSRange(location: 0, length: 13)
            
        }
        
        gameScoreLabel.attributedText = getLabelsAttributedText(string: congratsString, range: congratsRange)
        levelAverageLabel.attributedText = getLabelsAttributedText(string: levelString, range: levelRange)
        personalAverageLabel.attributedText = getLabelsAttributedText(string: averageString, range: averageRange)
        
    }
    func loadPersonalScoresFromCloudkit() {
        let privateDatabase = CKContainer.default().privateCloudDatabase

        var predicate = NSPredicate(value: true) // this will grab all scores
        if let score = gameScore {
            predicate = NSPredicate(format: "difficultyLevel == %@", score.difficultyLevel)
        }
        let query = CKQuery(recordType: "Score", predicate: predicate)
        
        query.sortDescriptors = [NSSortDescriptor(key: "moves", ascending: true)]
        
        privateDatabase.perform(query, inZoneWith: nil) {
            (records, error) in
            guard let records = records else {
                print("Error querying records: ", error as Any)
                return
            }
            print("Found \(records.count) records matching query in private Database")
            if records.count == 0 {
                // we found no scores.  Display default score.
                let score = Score(name: "No Scores yet", moves: 0, time: 0, difficultyLevel: "")
                // populate scores with just the default score
                self.personalScores = [score]
            } else {
                
                for record in records {
                    // create a score from the record...
                    let foundScore = Score(record: record)
                    self.personalScores.append(foundScore)
                }

                DispatchQueue.main.async(execute: {
                 // add in current gameScore manually.  I need to do this because Cloudkit saved records take time before they will show up in queries. And its not showing up fast enough.
                    if let score = self.gameScore {
                        self.personalScores.append(score)
                        // sort all Scores
                        self.personalScores.sort(by: {$0.moves < $1.moves})
                        
                        let newStats = Stats(scores: self.personalScores, difficultyLevel: score.difficultyLevel)
                        self.reloadBackgroundViewLabels(stats: newStats)
                        self.myTableView.reloadData()
                        print("personalTable should be reloaded")
                    }
                })
            }
        }
    }
    
    
    func loadAllScoresFromCloudkit() {
        let publicDatabase = CKContainer.default().publicCloudDatabase
        
        // Initialize Query.  And load all classes.
        var predicate = NSPredicate(value: true) // this will grab all scores
        if let score = gameScore {
            predicate = NSPredicate(format: "difficultyLevel == %@", score.difficultyLevel)
        }
        
        let query = CKQuery(recordType: "Score", predicate: predicate)
        
        // Configure Query.  Figure out a better way to sort.  Maybe sort by created?
        query.sortDescriptors = [NSSortDescriptor(key: "moves", ascending: true)]

//        var queryOperation = CKQueryOperation(query: query)
//        queryOperation.resultsLimit = 10

            
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
                self.allScores = [score]
            } else {
                
                for record in records {
                    // create a score from the record...
                    let foundScore = Score(record: record)
                    self.allScores.append(foundScore)
                }
             
                // add in current gameScore manually.  I need to do this because Cloudkit saved records take time before they will show up in queries. And its not showing up fast enough.
                if let score = self.gameScore {
                    self.allScores.append(score)
                    // sort all Scores
                    self.allScores.sort(by: {$0.moves < $1.moves})
                }

                DispatchQueue.main.async(execute: {
                    self.highTableView.reloadData()
                    print("reloaded HighTableView")
                })
            }
        }
    }
    
    // Mark: TableView methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == myTableView {
            return personalScores.count
        } else {
            return allScores.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == myTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! HighScoreTableViewCell
            let myScore = personalScores[indexPath.row]
            cell.score = myScore
            cell.rankLabel.text = "\(indexPath.row + 1)"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "highCell", for: indexPath) as! HighScoreTableViewCell
            let myScore = allScores[indexPath.row]
            cell.score = myScore
            cell.rankLabel.text = "\(indexPath.row + 1)"
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    

}
