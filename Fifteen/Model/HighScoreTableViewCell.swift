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
        label.font = UIFont(name: "Avenir", size: 40)
        label.textColor = UIColor.white
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    var aboutLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 500, height: 100))
        label.text = "Test"
        label.numberOfLines = 2
        label.font = UIFont(name: "Avenir", size: 40)
        label.textColor = UIColor.darkGray
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    var dateLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 500, height: 100))
        label.text = "Test"
        label.numberOfLines = 2
        label.font = UIFont(name: "Avenir", size: 30)
        label.textColor = UIColor.darkGray
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    

    var score: Score? {
        didSet {
            
//            rankLabel.frame = CGRect(x: 10, y: 5, width: 50, height: 100)
//            aboutLabel.frame = CGRect(x: 60, y: 5, width: frame.width - 60, height: 60)
//            dateLabel.frame = CGRect(x: 60, y: 65, width: frame.width - 60, height: 35)
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
    
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        setOrUpdateConstraints()
//    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: true)
        if highlighted {
            self.layer.borderColor = UIColor.darkGray.cgColor
            self.layer.borderWidth = 3.0
            self.backgroundColor = UIColor.white
            self.rankLabel.textColor = UIColor.darkGray
            self.aboutLabel.textColor = UIColor.mintDark
            self.dateLabel.textColor = UIColor.mintDark
        }
        else
        {
            self.layer.borderColor = UIColor.darkGray.cgColor
            self.layer.borderWidth = 0.0
            self.backgroundColor = UIColor.mintLight
            self.rankLabel.textColor = UIColor.white
            self.aboutLabel.textColor = UIColor.darkGray
            self.dateLabel.textColor = UIColor.darkGray
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.mintLight
        self.layer.cornerRadius = 10.0
//        self.layer.borderColor = UIColor.darkGray.cgColor
//        self.layer.borderWidth = 2.0
//        rankLabel.frame = CGRect(x: 10, y: 5, width: 50, height: 100)
//        aboutLabel.frame = CGRect(x: 60, y: 5, width: frame.width - 60, height: 60)
//        dateLabel.frame = CGRect(x: 60, y: 65, width: frame.width - 60, height: 30)
        self.contentView.addSubview(rankLabel)
        self.contentView.addSubview(aboutLabel)
        self.contentView.addSubview(dateLabel)
//        self.addSubview(rankLabel)
//        self.addSubview(aboutLabel)
//        self.addSubview(dateLabel)
        
        // set up constraints
        let stackView = UIStackView(arrangedSubviews: [aboutLabel, dateLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(stackView)
        
        let stackViewMain = UIStackView(arrangedSubviews: [rankLabel, stackView])
        stackViewMain.axis = .horizontal
        stackViewMain.distribution = .fill
        stackViewMain.alignment = .fill
        stackViewMain.spacing = 5
        stackViewMain.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(stackViewMain)
        
        stackViewMain.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 20).isActive = true
        stackViewMain.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20).isActive = true
        stackViewMain.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5).isActive = true
        stackViewMain.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5).isActive = true
        
        rankLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
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
