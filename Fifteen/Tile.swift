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
    var tile : PuzzleTile
    
    var positionOnScreen: TilePosition
    
    required init(tile: PuzzleTile, frame: CGRect)
    {
        self.tile = tile
        self.positionOnScreen = tile.position
        super.init(frame: frame)
        self.setTitle("\(tile.index)", for: UIControlState.normal)
        self.setTitleColor(UIColor.black, for: UIControlState.normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


struct TilePosition : Equatable
{
    var row: Int, column: Int
}

func == (left: TilePosition, right: TilePosition) -> Bool
{
    return (left.row == right.row) && (left.column == right.column)
}


struct TileMovement
{
    var start: TilePosition, end: TilePosition
}

class PuzzleTile
{
    var index: Int
    var position: TilePosition
    
    init(position: TilePosition, index: Int)
    {
        self.index = index
        self.position = position
    }
}