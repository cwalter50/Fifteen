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

    @IBOutlet weak var highScoresTableView: UITableView!
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
        return 150.0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scores.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! HighScoreTableViewCell
        let myScore = scores[indexPath.row]
        cell.score = myScore
        cell.rankLabel.text = "\(indexPath.row + 1)"
        
        
        return cell
    }
    
    
    
    

}
