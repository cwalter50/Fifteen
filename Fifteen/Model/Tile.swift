//
//  Tile.swift
//  Fifteen
//
//  Created by Christopher Walter on 4/2/18.
//  Copyright © 2018 AssistStat. All rights reserved.
//

import UIKit

class Tile : UIView
{
        // this will carry the row and column
    var position: TilePosition
    var name: Int
    var initialFrame: CGRect // used to reset the game.  Its set on init and after shuffle
    var initialPosition: TilePosition // used to help reset game
    var bordersEmptyTile: Bool
    var nameLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.textColor = UIColor.black
        label.font = UIFont(name: "Avenir", size: 20)
        label.textAlignment = .center
        return label
    }()

    
    init(position: TilePosition, name: Int, frame: CGRect) {
        self.position = position
        self.name = name
        self.bordersEmptyTile = false
        self.initialPosition = position
        self.initialFrame = frame

        super.init(frame: frame)
        self.nameLabel.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
//        nameLabel.center = self.center
        self.nameLabel.font = UIFont(name: "Avenir", size: frame.height*0.8)

        self.addSubview(nameLabel)
        
//        self.setTitleColor(.black, for: .normal)
//        self.titleLabel?.font = UIFont(name: "Avenir", size: frame.height*0.8)
        
        self.backgroundColor = UIColor.blueJeansLight
        self.layer.cornerRadius = 10.0
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.borderWidth = 2.0
        self.setTileTitle()
        
    }
    
    
    func setTileTitle() {
        if self.name == 0 {
            // this is the empty tile
            self.nameLabel.text = ""
//            self.setTitle("", for: .normal)
        } else {
            // this is every other tile
            self.nameLabel.text = "\(name)"
//            self.setTitle("\(name)", for: .normal)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
struct TilePosition : Equatable
{
    var row: Int, column: Int
}


