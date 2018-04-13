//
//  Score.swift
//  Fifteen
//
//  Created by  on 4/12/18.
//  Copyright © 2018 AssistStat. All rights reserved.
//

import UIKit
import CloudKit

class Score {
    var name: String
    var moves: Int
    var time: Int
    var difficultyLevel: String
    
    init (name: String, moves: Int, time: Int, difficultyLevel: String) {
        self.name = name
        self.moves = moves
        self.time = time
        self.difficultyLevel = difficultyLevel
    }
    
    func saveToCloudkit() {
        // create the CKRecord that gets saved to the database
        let uid = UUID().uuidString // get a uniqueID
        let recordID = CKRecordID(recordName: uid)
        
        let newScoreRecord = CKRecord(recordType: "Score", recordID: recordID)
        newScoreRecord["name"] = self.name as NSString
        newScoreRecord["moves"] = self.moves as CKRecordValue
        newScoreRecord["time"] = self.time as CKRecordValue
        newScoreRecord["difficultyLevel"] = self.difficultyLevel as NSString
        
        let myContainer = CKContainer.default()
        let publicDatabase = myContainer.publicCloudDatabase
        publicDatabase.save(newScoreRecord) {
            (record, error) in
            if let error = error {
                print(error)
                return
            }
            // insert successfully saved record code... reload table, etc...
            print("record saved!!!")
            
            
            //            DispatchQueue.main.async(execute: {
            //                self.delegate?.addStudent(student: newStudent)
            //            })
        }
    }
}
