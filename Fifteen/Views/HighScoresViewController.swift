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

class HighScoresViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SelectDifficultyDelegate  {
    
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
    var personalLevelScores: [Score] = []
    var stats: Stats = Stats(scores: [], difficultyLevel: "easy")
    var gameScore: Score?
    
    var playAgainButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
        button.backgroundColor = UIColor.mintDark
        button.titleLabel?.font = UIFont(name: "Avenir", size: 50.0)
        button.setTitle("Play Again", for: UIControl.State.normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(playAgainTapped), for: .primaryActionTriggered)
        return button
    }()
    var mainMenuButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 100, y: 0, width: 300, height: 100))
        button.backgroundColor = UIColor.grapefruitDark
        button.titleLabel?.font = UIFont(name: "Avenir", size: 50.0)
        button.setTitle("Main Menu", for: UIControl.State.normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(mainMenuTapped), for: .primaryActionTriggered)
        return button
    }()
    
    var scoreTypeSegmentedControl: UISegmentedControl = {
        
        let items = ["My Scores" , "All Scores"]
        let segmentedControl = UISegmentedControl(items : items)
        segmentedControl.frame = CGRect.zero
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(scoreTypeChanged(_:)), for: .valueChanged)
        segmentedControl.layer.cornerRadius = 5.0
        
        let font = UIFont(name: "Avenir", size: 30)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: font ?? UIFont.systemFont(ofSize: 30)], for: .normal)
        
        segmentedControl.backgroundColor = UIColor.darkGray
        segmentedControl.tintColor = UIColor.white
        
        segmentedControl.layer.cornerRadius = 5.0
        segmentedControl.layer.borderColor = UIColor.darkGray.cgColor
        segmentedControl.layer.borderWidth = 3.0
        
        return segmentedControl
    }()
    
    var sortBySegmentedControl: UISegmentedControl = {
        
        let items = ["moves" , "time"]
        let segmentedControl = UISegmentedControl(items : items)
        segmentedControl.frame = CGRect.zero
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(sortByChanged(_:)), for: .valueChanged)
        segmentedControl.layer.cornerRadius = 5.0
        segmentedControl.backgroundColor = UIColor.darkGray
        
        let font = UIFont(name: "Avenir", size: 30)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: font ?? UIFont.systemFont(ofSize: 30)], for: .normal)
        segmentedControl.tintColor = UIColor.white
        segmentedControl.layer.cornerRadius = 5.0
        segmentedControl.layer.borderColor = UIColor.darkGray.cgColor
        segmentedControl.layer.borderWidth = 3.0
        
        return segmentedControl
    }()
    
    // difficulty level is saved as "\(rows) x \(columns) \(difficulty)"
    var levelButton: UIButton = {
        
        let button = UIButton(frame: CGRect(x: 100, y: 0, width: 300, height: 100))
        button.backgroundColor = UIColor.lavendarDark
        button.titleLabel?.font = UIFont(name: "Avenir", size: 30.0)
        button.setTitle("Dificulty Level", for: UIControl.State.normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(levelButtonTapped(sender:)), for: .primaryActionTriggered)
        button.layer.cornerRadius = 10.0
        button.clipsToBounds = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        #if os(iOS)
        setUpViewsiOS()
        self.title = "Slidearoo"
        
        #elseif os(tvOS)
        print("running on tvOS")
        setUpViewstvOS()
        
        #else
        print("OMG, it's that mythical new Apple product!!!")
        setUpViewsiOS()
        #endif
        //        setUpViews()
        
        //        view.backgroundColor = UIColor.white
        if let score = gameScore {
            stats = Stats(scores: [score], difficultyLevel: score.difficultyLevel)
            self.reloadBackgroundViewLabels(stats: stats)
        }
        if let score = gameScore {
            personalScores.append(score)
            allScores.append(score)
        }
        let sortBy = sortBySegmentedControl.titleForSegment(at: sortBySegmentedControl.selectedSegmentIndex) ?? "moves"
        loadAllScoresFromCloudkit(sortBy: sortBy, difficulty: gameScore?.difficultyLevel)
        loadPersonalScoresFromCloudkit(sortBy: sortBy, difficulty: gameScore?.difficultyLevel)
        
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
    
    
    @objc func scoreTypeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            print("My Scores Selected");
            self.highTableView.reloadData()
        case 1:
            print("All Scores Selected")
            self.highTableView.reloadData()
        default:
            break
        }
    }
    
    @objc func sortByChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            print("moves")
            print("allscores \(allScores.count): personalScores: \(personalScores.count)")
            self.allScores.sort(by: {$0.moves < $1.moves})
            self.personalScores.sort(by: {$0.moves < $1.moves})
            highTableView.reloadData()
            myTableView.reloadData()
            
        case 1:
            print("time")
            print("allscores \(allScores.count): personalScores: \(personalScores.count)")
            self.allScores.sort(by: {$0.time < $1.time})
            self.personalScores.sort(by: {$0.time < $1.time})
            highTableView.reloadData()
            myTableView.reloadData()
        default:
            break
        }
    }
    
    @objc func levelButtonTapped(sender: UIButton)
    {
        //        // this method should create a drop down menu for possible difficulty levels
        //        difficultyLevelTableView.isHidden = !difficultyLevelTableView.isHidden
        let modalVC = SelectDifficultyVC()
        modalVC.modalPresentationStyle = .overCurrentContext
        modalVC.delegate = self
        present(modalVC, animated: true, completion: nil)
        
    }
    
    func difficultySelected(difficulty: String?) {
        if difficulty != nil || difficulty != ""
        {
            levelButton.setTitle(difficulty, for: .normal)
            
            let sortBy = sortBySegmentedControl.titleForSegment(at: sortBySegmentedControl.selectedSegmentIndex) ?? "moves"
            loadAllScoresFromCloudkit(sortBy: sortBy, difficulty: difficulty)
            loadPersonalScoresFromCloudkit(sortBy: sortBy, difficulty: difficulty)
        }
        else
        {
            levelButton.setTitle("Select Difficulty", for: .normal)
            print("No difficulty selected")
        }
        
    }
    
    
    
    
    func setUpViewsiOS() {
        
        let theFrame = CGRect(x: 0, y: 0, width: 100, height: 100) // this is a default frame and shouldn't matter for iOS because I am using constraints in iOS
        let gameScoreView = UIView(frame: CGRect.zero)
        gameScoreView.backgroundColor = UIColor.blueJeansDark
        gameScoreView.layer.cornerRadius = 10.0
        
        gameScoreLabel = getDisplayLabel(frame: theFrame, numberOfLines: 3)
        gameScoreView.addSubview(gameScoreLabel)
        
        let levelAverageView = UIView(frame: CGRect.zero)
        levelAverageView.backgroundColor = UIColor.sunFlowerDark
        levelAverageView.layer.cornerRadius = 10.0
        levelAverageLabel = getDisplayLabel(frame: theFrame, numberOfLines: 4)
        levelAverageView.addSubview(levelAverageLabel)
        
        let personalAverageView: UIView = UIView(frame: CGRect.zero)
        personalAverageView.backgroundColor = UIColor.aquaDark
        personalAverageView.layer.cornerRadius = 10.0
        personalAverageLabel = getDisplayLabel(frame: theFrame, numberOfLines: 4)
        personalAverageView.addSubview(personalAverageLabel)
        
        
        backgroundView.addSubview(gameScoreView)
        backgroundView.addSubview(levelAverageView)
        backgroundView.addSubview(personalAverageView)
        
        backgroundView.addSubview(levelButton)
        
        let topStack = UIStackView(arrangedSubviews: [levelButton,gameScoreView, levelAverageView, personalAverageView])
        topStack.axis = .vertical
        topStack.distribution = .fillEqually
        topStack.alignment = .fill
        topStack.spacing = 5
        topStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topStack)
        
        view.addSubview(scoreTypeSegmentedControl)
        view.addSubview(sortBySegmentedControl)
        scoreTypeSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        sortBySegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        //        myTableView = UITableView(frame: CGRect(x: 0, y: 0, width: width / 4.0, height: height * 0.7), style: UITableView.Style.plain)
        //        myTableView.center = CGPoint(x: width * 0.25 - 10, y: height * 0.5 + 10.0)
        //        myTableView.delegate = self
        //        myTableView.dataSource = self
        //        myTableView.register(HighScoreTableViewCell.self, forCellReuseIdentifier: "myCell")
        //        self.view.addSubview(self.myTableView)
        //        myTableView.backgroundColor = UIColor.clear
        //        myTableView.layer.cornerRadius = 10.0
        //        myTableView.tableFooterView = UIView(frame: CGRect.zero)
        //        // created a custom function to get headerView
        //        myTableView.tableHeaderView = getHeaderView(text: "Personal Best Scores")
        
        highTableView = UITableView(frame: CGRect(x: 0, y: 0, width: width / 4.0, height: height * 0.7), style: UITableView.Style.plain)
        highTableView.center = CGPoint(x: width * 0.75 + 10.0, y: height * 0.5 + 10)
        highTableView.delegate = self
        highTableView.dataSource = self
        highTableView.register(HighScoreTableViewCell.self, forCellReuseIdentifier: "highCell")
        self.view.addSubview(self.highTableView)
        highTableView.tableFooterView = UIView(frame: CGRect.zero)
        highTableView.backgroundColor = UIColor.clear
        highTableView.layer.cornerRadius = 10.0
        highTableView.tableHeaderView = getHeaderView(text: "All-Time Best Scores")
        
        view.addSubview(playAgainButton)
        view.addSubview(mainMenuButton)
        
        
        let bottomStack = UIStackView(arrangedSubviews: [playAgainButton, mainMenuButton])
        bottomStack.axis = .horizontal
        bottomStack.distribution = .fillEqually
        bottomStack.alignment = .fill
        bottomStack.spacing = 5
        bottomStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topStack)
        
        reloadBackgroundViewLabels(stats: stats)
        
        let mainStack = UIStackView(arrangedSubviews: [scoreTypeSegmentedControl, topStack, sortBySegmentedControl,highTableView, bottomStack])
        mainStack.axis = .vertical
        mainStack.distribution = .fill
        mainStack.alignment = .fill
        mainStack.spacing = 5
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainStack)
        
        // add constraints to main stack
        if gameScore == nil
        {
            topStack.heightAnchor.constraint(equalToConstant: view.frame.height/5).isActive = true
        } else {
            topStack.heightAnchor.constraint(equalToConstant: view.frame.height/4).isActive = true
        }
        
        bottomStack.heightAnchor.constraint(equalToConstant: 60).isActive = true
        scoreTypeSegmentedControl.heightAnchor.constraint(equalToConstant: 45).isActive = true
        sortBySegmentedControl.heightAnchor.constraint(equalToConstant: 45).isActive = true
        mainStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        mainStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        mainStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        mainStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        
        // remove playAgainButton, and gameScoreView if gameScore does not exist. This will be the case if we ump to high scores directly from the menu, as opposed to after winning.
        if gameScore == nil
        {
            gameScoreView.isHidden = true
            playAgainButton.isHidden = true
            
        }
        
    }
    
    func setUpViewstvOS() {
        
        myTableView = UITableView(frame: CGRect(x: 0, y: 0, width: width / 4.0, height: height * 0.7), style: UITableView.Style.plain)
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
        
        highTableView = UITableView(frame: CGRect(x: 0, y: 0, width: width / 4.0, height: height * 0.7), style: UITableView.Style.plain)
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
        headerLabel.font = UIFont(name: "Avenir", size: 30)
        headerLabel.textColor = UIColor.white
        headerLabel.textAlignment = .center
        headerLabel.adjustsFontSizeToFitWidth = true
        headerLabel.text = text
        headerView.addSubview(headerLabel)
        return headerView
    }
    
    func getDisplayLabel(frame: CGRect, numberOfLines: Int) -> UILabel {
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height / 3.0))
        label.font = UIFont(name: "Avenir", size: 30.0)
        label.numberOfLines = numberOfLines
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.white
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
        let attributes = [NSAttributedString.Key.font:UIFont(name: "Avenir", size: 80)!]
        let displayString = NSMutableAttributedString(string: string)
        
        displayString.addAttributes(attributes, range: range)
        return displayString
    }
    
    func reloadBackgroundViewLabels(stats: Stats) {
        
        var congratsString = "You won! Congrats!"
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
            
            //            averageString = "Overall Stats\nBest: \(stats.leastMoves) moves, \(getDisplayTime(time: stats.bestTime)) time\nAverage: \(stats.averageTotalMoves) moves in \(getDisplayTime(time: stats.averageLevelTime))\nGames Won: \(stats.gamesPlayedTotal)"
            averageString = "Overall Stats\nBest: \(stats.leastMoves) moves, \(getDisplayTime(time: stats.bestTime)) time, Average: \(stats.averageTotalMoves) moves in \(getDisplayTime(time: stats.averageLevelTime)), Games Won: \(stats.gamesPlayedTotal)"
            averageRange = NSRange(location: 0, length: 13)
            
        }
        
        gameScoreLabel.attributedText = getLabelsAttributedText(string: congratsString, range: congratsRange)
        levelAverageLabel.attributedText = getLabelsAttributedText(string: levelString, range: levelRange)
        personalAverageLabel.attributedText = getLabelsAttributedText(string: averageString, range: averageRange)
        
    }
    
    
    func loadAllScoresFromCloudkit(sortBy: String, difficulty: String?)
    {
        let publicDatabase = CKContainer(identifier: "iCloud.com.AssistStat.Fifteen").publicCloudDatabase
        //        let publicDatabase = CKContainer.
        //        let publicDatabase = CKContainer.default().publicCloudDatabase
        
        // Initialize Query.  And load all classes.
        var predicate = NSPredicate(value: true) // this will grab all scores
        if let diff = difficulty
        {
            predicate = NSPredicate(format: "difficultyLevel == %@", diff)
        }
        //        if let score = gameScore {
        //            predicate = NSPredicate(format: "difficultyLevel == %@", score.difficultyLevel)
        //        }
        
        
        
        let query = CKQuery(recordType: "Score", predicate: predicate)
        
        // Configure Query.  Figure out a better way to sort.  Maybe sort by created?
        
        query.sortDescriptors = [NSSortDescriptor(key: sortBy, ascending: true)]
        
        //        var queryOperation = CKQueryOperation(query: query)
        //        queryOperation.resultsLimit = 10
        
        
        publicDatabase.perform(query, inZoneWith: nil) {
            (records, error) in
            guard let records = records else {
                print("Error querying records: ", error as Any)
                return
            }
            print("Found \(records.count) records matching query in public Database")
            
            if records.count == 0 {
                // we found no scores.  Display default score.
                let score = Score(name: "No Scores yet", moves: 0, time: 0, difficultyLevel: "Easy")
                // populate scores with just the default score
                self.allScores = [score]
                DispatchQueue.main.async(execute: {
                    self.highTableView.reloadData()
                    print("reloaded HighTableView")
                })
            } else {
                self.allScores.removeAll()
                for record in records {
                    // create a score from the record...
                    let foundScore = Score(record: record)
                    self.allScores.append(foundScore)
                }
                
                // add in current gameScore manually.  I need to do this because Cloudkit saved records take time before they will show up in queries. And its not showing up fast enough.
                if let score = self.gameScore {
                    self.allScores.append(score)
                    // sort all Scores
                    if self.sortBySegmentedControl.selectedSegmentIndex == 0
                    {
                        self.allScores.sort(by: {$0.moves < $1.moves})
                    }
                    else
                    {
                        self.allScores.sort(by: {$0.time < $1.time})
                    }
                    
                }
                
                DispatchQueue.main.async(execute: {
                    self.highTableView.reloadData()
                    let newStats = Stats(scores: self.personalScores, difficultyLevel: difficulty ?? "4 x 4 medium")
                    self.reloadBackgroundViewLabels(stats: newStats)
                    print("reloaded HighTableView")
                })
            }
        }
    }
    
    func loadPersonalScoresFromCloudkit(sortBy: String, difficulty: String?)
    {
        let privateDatabase = CKContainer(identifier: "iCloud.com.AssistStat.Fifteen").privateCloudDatabase
        //        let privateDatabase = CKContainer.default().privateCloudDatabase
        
        var predicate = NSPredicate(value: true) // this will grab all scores
        if let diff = difficulty
        {
            predicate = NSPredicate(format: "difficultyLevel == %@", diff)
        }
        
        //        if let score = gameScore {
        //            predicate = NSPredicate(format: "difficultyLevel == %@", score.difficultyLevel)
        //
        //        }
        let query = CKQuery(recordType: "Score", predicate: predicate)
        
        query.sortDescriptors = [NSSortDescriptor(key: sortBy, ascending: true)]
        
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
                self.personalScores.removeAll()
                for record in records {
                    // create a score from the record...
                    let foundScore = Score(record: record)
                    self.personalScores.append(foundScore)
                    if foundScore.difficultyLevel == self.gameScore?.difficultyLevel  {
                        self.personalLevelScores.append(foundScore)
                    }
                    
                }
                
                DispatchQueue.main.async(execute: {
                    // add in current gameScore manually.  I need to do this because Cloudkit saved records take time before they will show up in queries. And its not showing up fast enough.
                    if let score = self.gameScore {
                        self.personalScores.append(score)
                        self.personalLevelScores.append(score)
                        // sort all Scores
                        self.personalScores.sort(by: {$0.moves < $1.moves})
                        self.personalLevelScores.sort(by: {$0.moves < $1.moves})
                        
                        let newStats = Stats(scores: self.personalScores, difficultyLevel: score.difficultyLevel)
                        self.reloadBackgroundViewLabels(stats: newStats)
                        self.highTableView.reloadData() // this is for iOS...
                        self.myTableView.reloadData()
                        print("personalTable should be reloaded")
                    }
                })
            }
        }
    }
    //    func loadPersonalScoresFromCloudkit() {
    //        let privateDatabase = CKContainer(identifier: "iCloud.com.AssistStat.Fifteen").privateCloudDatabase
    ////        let privateDatabase = CKContainer.default().privateCloudDatabase
    //
    //        let predicate = NSPredicate(value: true) // this will grab all scores
    ////        if let score = gameScore {
    ////            predicate = NSPredicate(format: "difficultyLevel == %@", score.difficultyLevel)
    ////
    ////        }
    //        let query = CKQuery(recordType: "Score", predicate: predicate)
    //
    //        query.sortDescriptors = [NSSortDescriptor(key: "moves", ascending: true)]
    //
    //        privateDatabase.perform(query, inZoneWith: nil) {
    //            (records, error) in
    //            guard let records = records else {
    //                print("Error querying records: ", error as Any)
    //                return
    //            }
    //            print("Found \(records.count) records matching query in private Database")
    //            if records.count == 0 {
    //                // we found no scores.  Display default score.
    //                let score = Score(name: "No Scores yet", moves: 0, time: 0, difficultyLevel: "")
    //                // populate scores with just the default score
    //                self.personalScores = [score]
    //            } else {
    //                self.personalScores.removeAll()
    //                for record in records {
    //                    // create a score from the record...
    //                    let foundScore = Score(record: record)
    //                    self.personalScores.append(foundScore)
    //                    if foundScore.difficultyLevel == self.gameScore?.difficultyLevel  {
    //                        self.personalLevelScores.append(foundScore)
    //                    }
    //                }
    //
    //                DispatchQueue.main.async(execute: {
    //                 // add in current gameScore manually.  I need to do this because Cloudkit saved records take time before they will show up in queries. And its not showing up fast enough.
    //                    if let score = self.gameScore {
    //                        self.personalScores.append(score)
    //                        self.personalLevelScores.append(score)
    //                        // sort all Scores
    //                        self.personalScores.sort(by: {$0.moves < $1.moves})
    //                        self.personalLevelScores.sort(by: {$0.moves < $1.moves})
    //
    //                        let newStats = Stats(scores: self.personalScores, difficultyLevel: score.difficultyLevel)
    //                        self.reloadBackgroundViewLabels(stats: newStats)
    //
    //                        self.myTableView.reloadData()
    //                        print("personalTable should be reloaded")
    //                    }
    //                })
    //            }
    //        }
    //    }
    //
    //
    //    func loadAllScoresFromCloudkit() {
    //        let publicDatabase = CKContainer(identifier: "iCloud.com.AssistStat.Fifteen").publicCloudDatabase
    ////        let publicDatabase = CKContainer.
    ////        let publicDatabase = CKContainer.default().publicCloudDatabase
    //
    //        // Initialize Query.  And load all classes.
    //        var predicate = NSPredicate(value: true) // this will grab all scores
    //        if let score = gameScore {
    //            predicate = NSPredicate(format: "difficultyLevel == %@", score.difficultyLevel)
    //        }
    //
    //        let query = CKQuery(recordType: "Score", predicate: predicate)
    //
    //        // Configure Query.  Figure out a better way to sort.  Maybe sort by created?
    //        query.sortDescriptors = [NSSortDescriptor(key: "moves", ascending: true)]
    //
    ////        var queryOperation = CKQueryOperation(query: query)
    ////        queryOperation.resultsLimit = 10
    //
    //
    //        publicDatabase.perform(query, inZoneWith: nil) {
    //            (records, error) in
    //            guard let records = records else {
    //                print("Error querying records: ", error as Any)
    //                return
    //            }
    //            print("Found \(records.count) records matching query in public Database")
    //            if records.count == 0 {
    //                // we found no scores.  Display default score.
    //                let score = Score(name: "No Scores yet", moves: 0, time: 0, difficultyLevel: "Easy")
    //                // populate scores with just the default score
    //                self.allScores = [score]
    //            } else {
    //                self.allScores.removeAll()
    //                for record in records {
    //                    // create a score from the record...
    //                    let foundScore = Score(record: record)
    //                    self.allScores.append(foundScore)
    //                }
    //
    //                // add in current gameScore manually.  I need to do this because Cloudkit saved records take time before they will show up in queries. And its not showing up fast enough.
    //                if let score = self.gameScore {
    //                    self.allScores.append(score)
    //                    // sort all Scores
    //                    self.allScores.sort(by: {$0.moves < $1.moves})
    //                }
    //
    //                DispatchQueue.main.async(execute: {
    //                    self.highTableView.reloadData()
    //                    print("reloaded HighTableView")
    //                })
    //            }
    //        }
    //    }
    
    // Mark: TableView methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //        return 100
        return UIScreen.main.bounds.height / 12
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == myTableView {
            return personalLevelScores.count
        } else {
            if scoreTypeSegmentedControl.selectedSegmentIndex == 0
            {
                return personalScores.count
            } else
            {
                return allScores.count
            }
            
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == myTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! HighScoreTableViewCell
            let myScore = personalLevelScores[indexPath.row]
            cell.score = myScore
            cell.rankLabel.text = "\(indexPath.row + 1)"
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "highCell", for: indexPath) as! HighScoreTableViewCell
            
            var scores: [Score] = [Score]()
            if scoreTypeSegmentedControl.selectedSegmentIndex == 0
            {
                scores = personalScores
            }
            else
            {
                scores = allScores
            }
            
            let myScore = scores[indexPath.row]
            cell.score = myScore
            cell.rankLabel.text = "\(indexPath.row + 1)"
            if gameScore?.creationDate == myScore.creationDate
            {
                cell.setHighlighted(true, animated: true)
            }
            else {
                cell.setHighlighted(false, animated: false)
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
    
    
    
    
}
