//
//  HighScoreTableViewCell.swift
//  Fifteen
//
//  Created by Christopher Walter on 4/15/18.
//  Copyright © 2018 AssistStat. All rights reserved.
//

import UIKit


class HighScoreTableViewCell: UITableViewCell {

    @IBOutlet weak var movesLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    var score: Score? {
        didSet {
            guard let theScore = score else {return}
            self.movesLabel.text = "\(theScore.moves)"
            self.nameLabel.text = theScore.name
            
            let min = theScore.time / 60
            let sec = theScore.time % 60
            let timeText = String(format:"%i:%02i",min, sec)
            self.timeLabel.text = timeText
            
            
//            self.dateLabel.text = score?.createdAt
//            self.layer.borderWidth = 2.0
//            self.layer.borderColor = UIColor.darkGray.cgColor
//            self.layer.cornerRadius = 5.0
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
