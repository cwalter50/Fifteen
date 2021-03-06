//
//  Score.swift
//  Fifteen
//
//  Created by  on 4/12/18.
//  Copyright © 2018 AssistStat. All rights reserved.
//

import UIKit
import CloudKit

protocol newScoreAddedDelegate {
    func showHighScores(score: Score)
    func errorAlert(message: String)
}
class Score {
    var name: String
    var moves: Int
    var time: Int
    var difficultyLevel: String
    var creationDate: Date
    var record: CKRecord?
    
    var delegate: newScoreAddedDelegate? // this will allow us to call a method on ViewController when newScore gets added to cloudkit
    
    init (name: String, moves: Int, time: Int, difficultyLevel: String) {
        self.name = name
        self.moves = moves
        self.time = time
        self.difficultyLevel = difficultyLevel
        self.creationDate = Date()
        record = nil
    }
    
    init(record: CKRecord) {

        self.name = record["name"] as? String ?? ""
        self.moves = record["moves"] as? Int ?? 0
        self.time = record["time"] as? Int ?? 0
        self.difficultyLevel = record["difficultyLevel"] as? String ?? ""
        self.creationDate = record.creationDate ?? Date()
        self.record = record
        
//        self.recordName = record.recordID.recordName
      
    }
    
    func saveToCloudkit() {
        // create the CKRecord that gets saved to the database
        let uid = UUID().uuidString // get a uniqueID
        let recordID = CKRecord.ID(recordName: uid)
        
        let newScoreRecord = CKRecord(recordType: "Score", recordID: recordID)

        newScoreRecord["name"] = self.name as NSString
        newScoreRecord["moves"] = self.moves as CKRecordValue
        newScoreRecord["time"] = self.time as CKRecordValue
        newScoreRecord["difficultyLevel"] = self.difficultyLevel as NSString
        
        // these Bools are used to make sure that I am not calling HighScoreVC twice.
        var publicSaved = false
        var privateSaved = false
        
//        let myContainer = CKContainer.default()
        let publicDatabase = CKContainer(identifier: "iCloud.com.AssistStat.Fifteen").publicCloudDatabase
//        let publicDatabase = myContainer.publicCloudDatabase
        publicDatabase.save(newScoreRecord) {
            (record, error) in
            if let error = error {
                print(error)
                DispatchQueue.main.async(execute: {
                    self.delegate?.errorAlert(message: error.localizedDescription)
                })
                
                return
            }
            // insert successfully saved record code... reload table, etc...
            print("record saved!!!")
            self.record = newScoreRecord // record was nil until its saved in cloudkit
            publicSaved = true

            DispatchQueue.main.async(execute: {
                if publicSaved && privateSaved {
                    self.delegate?.showHighScores(score: self)
                }

            })

        }
//        let privateDatabase = myContainer.privateCloudDatabase
        let privateDatabase = CKContainer(identifier: "iCloud.com.AssistStat.Fifteen").privateCloudDatabase
        privateDatabase.save(newScoreRecord) {
            (record, error) in
            if let error = error {
                print(error)
                DispatchQueue.main.async(execute: {
                    self.delegate?.errorAlert(message: error.localizedDescription)
                })
                
                return
            }
            // insert successfully saved record code... reload table, etc...
            print("record saved!!!")
            self.record = newScoreRecord // record was nil until its saved in cloudkit
            privateSaved = true
//            if publicSaved && privateSaved {
//                self.delegate?.showHighScores(score: self)
//            }
            DispatchQueue.main.async(execute: {
                // this is used to make sure that I am not opening High Scores VC twice
                if publicSaved && privateSaved {
                    self.delegate?.showHighScores(score: self)
                }
            })
            
        }
    }
}
