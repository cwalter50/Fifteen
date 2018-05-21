//
//  HighScoreTableViewCell.swift
//  Fifteen
//
//  Created by Christopher Walter on 4/15/18.
//  Copyright © 2018 AssistStat. All rights reserved.
//

import UIKit


class HighScoreTableViewCell: UITableViewCell {

    // figure out and rewrite all of this so that it can be loaded programmatically.
    var rankLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 100))
        label.text = "1"
        label.font = UIFont(name: "Avenir", size: 60)
        label.textColor = UIColor.white
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    var aboutLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 500, height: 100))
        label.text = "Test"
        label.numberOfLines = 2
        label.font = UIFont(name: "Avenir", size: 40)
        label.textColor = UIColor.black
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    var dateLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 500, height: 100))
        label.text = "Test"
        label.numberOfLines = 2
        label.font = UIFont(name: "Avenir", size: 30)
        label.textColor = UIColor.black
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
//    @IBOutlet weak var movesLabel: UILabel!
//    @IBOutlet weak var dateLabel: UILabel!
//    @IBOutlet weak var nameLabel: UILabel!
//    @IBOutlet weak var timeLabel: UILabel!
    var score: Score? {
        didSet {
            
            rankLabel.frame = CGRect(x: 10, y: 5, width: 50, height: 100)
            aboutLabel.frame = CGRect(x: 60, y: 5, width: frame.width - 60, height: 60)
            dateLabel.frame = CGRect(x: 60, y: 65, width: frame.width - 60, height: 30)
            guard let theScore = score else {return}

            let min = theScore.time / 60
            let sec = theScore.time % 60
            let timeText = String(format:"%i:%02i",min, sec)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            let dateString = dateFormatter.string(from: theScore.creationDate)
            
            var name = theScore.name + ": "
            if name == ": " {
                name = "Hulk: "
            }
            
            aboutLabel.text = "\(name)\(theScore.moves) moves in \(timeText)"
            dateLabel.text = dateString
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.mintLight
        self.layer.cornerRadius = 10.0
//        self.layer.borderColor = UIColor.darkGray.cgColor
//        self.layer.borderWidth = 2.0
        rankLabel.frame = CGRect(x: 10, y: 5, width: 50, height: 100)
        aboutLabel.frame = CGRect(x: 60, y: 5, width: frame.width - 60, height: 60)
        dateLabel.frame = CGRect(x: 60, y: 65, width: frame.width - 60, height: 30)
        self.addSubview(rankLabel)
        self.addSubview(aboutLabel)
        self.addSubview(dateLabel)

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
