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
    var highScoresTableView: UITableView = UITableView()
    var personalTableView: UITableView = UITableView()
    var personalBackgroundView: UIView = UIView()
    var scores: [Score] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        loadScoresFromCloudkit()
    }
    
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUpViews() {
        personalBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: width / 4.0 - 10, height: height * 0.75))
        personalBackgroundView.center = view.center
        personalBackgroundView.backgroundColor = UIColor.mintDark
        personalBackgroundView.layer.cornerRadius = 10.0
        self.view.addSubview(personalBackgroundView)
        
        personalTableView = UITableView(frame: CGRect(x: 0, y: 0, width: width / 4.0, height: height * 0.75), style: UITableViewStyle.plain)
        personalTableView.center = CGPoint(x: width * 0.25, y: height * 0.5)
        personalTableView.delegate = self
        personalTableView.dataSource = self
        personalTableView.register(HighScoreTableViewCell.self, forCellReuseIdentifier: "personalCell")
        self.view.addSubview(self.personalTableView)
        personalTableView.backgroundColor = UIColor.white
        personalTableView.layer.cornerRadius = 10.0
        personalTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        highScoresTableView = UITableView(frame: CGRect(x: 0, y: 0, width: width / 4.0, height: height * 0.75), style: UITableViewStyle.plain)
        highScoresTableView.center = CGPoint(x: width * 0.75, y: height * 0.5)
        highScoresTableView.delegate = self
        highScoresTableView.dataSource = self
        highScoresTableView.register(HighScoreTableViewCell.self, forCellReuseIdentifier: "highCell")
        self.view.addSubview(self.highScoresTableView)
        highScoresTableView.tableFooterView = UIView(frame: CGRect.zero)
        highScoresTableView.backgroundColor = UIColor.white
        highScoresTableView.layer.cornerRadius = 10.0
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
                    self.highScoresTableView.reloadData()
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
        if tableView == personalTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "personalCell", for: indexPath) as! HighScoreTableViewCell
            let myScore = scores[indexPath.row]
            cell.score = myScore
            cell.rankLabel.text = "\(indexPath.row + 1)"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! HighScoreTableViewCell
            let myScore = scores[indexPath.row]
            cell.score = myScore
            cell.rankLabel.text = "\(indexPath.row + 1)"
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    

}
