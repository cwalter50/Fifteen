//
//  Tile.swift
//  Fifteen
//
//  Created by Christopher Walter on 4/2/18.
//  Copyright © 2018 AssistStat. All rights reserved.
//

import UIKit

class Tile : UIButton
{
        // this will carry the row and column
    var position: TilePosition
    var name: Int
    var bordersEmptyTile: Bool
    
    init(position: TilePosition, name: Int, frame: CGRect) {
        self.position = position
        self.name = name
        self.bordersEmptyTile = false
        super.init(frame: frame)
        
        self.setTitleColor(.black, for: .normal)
        self.titleLabel?.font = UIFont(name: "Avenir", size: frame.height*0.8)
        
        self.backgroundColor = UIColor.blueJeansLight
        self.layer.cornerRadius = 10.0
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.borderWidth = 2.0
        self.setTileTitle()
        
    }
    
    func setTileTitle() {
        if self.name == 0 {
            // this is the empty tile
            self.setTitle("", for: .normal)
        } else {
            // this is every other tile
            self.setTitle("\(name)", for: .normal)
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


