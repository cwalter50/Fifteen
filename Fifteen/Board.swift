//
//  Board.swift
//  Fifteen
//
//  Created by Christopher Walter on 4/2/18.
//  Copyright © 2018 AssistStat. All rights reserved.
//

import UIKit

class Board {
    
    var rows: Int, columns: Int

//    var emptySquare: TilePosition
    var emptyTile: Tile

    var tiles = [Tile]()
    var backgroundView: UIView

    init(rows: Int, columns: Int)
    {
        self.rows = rows
        self.columns = columns
        
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        let blockWidth = (height - 300.0) / CGFloat(rows)
        let center = CGPoint(x: width * 0.5, y: height * 0.5)
        self.backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: (blockWidth + 2.0) * CGFloat(columns), height: (blockWidth + 2.0) * CGFloat(rows)))
//        self.backgroundView.backgroundColor = UIColor.grapefruitDark
        self.backgroundView.center = center
        
        for i in 0..<(rows * columns - 1)
        {
            let row = i / columns + 1
            let column = (i % columns) + 1
            let pos = TilePosition(row: row, column: column)
            let rect = CGRect(x:CGFloat(column - 1) * (blockWidth + 2.0) , y: CGFloat(row - 1) * (blockWidth + 2.0), width: blockWidth, height: blockWidth)
            let tile = Tile(position: pos, name: i + 1, frame: rect)
            tiles.append(tile)
            backgroundView.addSubview(tile)
        }
        let pos = TilePosition(row: rows, column: columns)
        emptyTile = Tile(position: pos, name: 0, frame: CGRect(x: CGFloat(columns - 1) * (blockWidth + 2), y: CGFloat(rows - 1) * (blockWidth + 2), width: blockWidth, height: blockWidth))
        tiles.append(emptyTile)
        backgroundView.addSubview(emptyTile)
    }
    
    func shuffle(numberOfMoves: Int) {
        for _ in 0..<numberOfMoves {
            // find all possible moves.  up to 4.
            var possibleTiles: [Tile] = []
            for tile in self.tiles {
                if isNextToEmptySquare(position: tile.position) {
                    possibleTiles.append(tile)
                    print("found possible tile: \(tile.name)")
                }
            }
            
            // select a random one of the possible moves and move
            let randIndex = Int(arc4random_uniform(UInt32(possibleTiles.count)))
            
            let tileToMove = possibleTiles[randIndex]
            self.move(startPosition: tileToMove.position)
        }
    }
    
    // this function will move swap the tile in the start position with the emptyTile.  The check if its valid happens in the game.
    func move(startPosition: TilePosition) {
        // get the tile you want to move
        if let tile = self.tileAt(position: startPosition) {
            let holdingFrame = emptyTile.frame
            let holdingPosition = emptyTile.position
            // swap emptyTile with tile's frame and position
            emptyTile.frame = tile.frame
            tile.frame = holdingFrame
            
            emptyTile.position = tile.position
            tile.position = holdingPosition
            
            
        }
    }
    
    func isNextToEmptySquare(position: TilePosition) -> Bool
    {
        return
            (position.row == emptyTile.position.row && abs(position.column - emptyTile.position.column) == 1) ||
                (position.column == emptyTile.position.column && abs(position.row - emptyTile.position.row) == 1)
    }
    
    func tileAt(position: TilePosition) -> Tile?
    {
        for tile in self.tiles
        {
            if tile.position.row == position.row && tile.position.column == position.column
            {
                return tile
            }
        }
        return nil
    }
    
    func isSolved() -> Bool {
        for i in 0..<(rows * columns - 1)
        {
            let pos = TilePosition(row: i / columns + 1, column: (i % columns) + 1)
            if let tile = tileAt(position: pos) {
                if tile.name != i + 1 {
                    return false
                }
            }

        }
        return true
    }
    
    // this will bring board back to the solved position
    func resetBoard()
    {
        for i in 0..<(rows * columns - 1)
        {
            let pos = TilePosition(row: i / columns + 1, column: (i % columns) + 1)
            if let tile = tileAt(position: pos) {
                tile.name = i + 1
                tile.setTileTitle()
            }
        }
        emptyTile = tileAt(position: TilePosition(row: rows, column: columns))!
        emptyTile.name = 0
        emptyTile.setTileTitle()
    }
    
    //    func move(movement: TileMovement)
    //    {
    //        let tile = self.tileAt(position: movement.start)
    //
    //        assert(movement.end == emptySquare, "destination not empty")
    //        assert(tile != nil, "tile not found")
    //
    //        emptySquare = movement.start
    //        tile?.position = movement.end
    //    }
    

//    func resetBoard()
//    {
//        for i in 0..<(rows * columns - 1)
//        {
//            let pos = TilePosition(row: i / columns + 1, column: (i % columns) + 1)
//            tiles[i].position = pos
//        }
//        emptySquare = TilePosition(row: rows, column: columns)
//    }
//
//    func isInRowToEmptySquare(position: TilePosition) -> Bool
//    {
//        return position.row == emptySquare.row || position.column == emptySquare.column
//    }
//
//    func isNextToEmptySquare(position: TilePosition) -> Bool
//    {
//        return
//            (position.row == emptySquare.row && abs(position.column - emptySquare.column) == 1) ||
//                (position.column == emptySquare.column && abs(position.row - emptySquare.row) == 1)
//    }

//    func tileAt(position: TilePosition) -> PuzzleTile?
//    {
//        for tile in self.tiles
//        {
//            if tile.position.row == position.row && tile.position.column == position.column
//            {
//                return tile
//            }
//        }
//        return nil
//    }
//
//    func move(movement: TileMovement)
//    {
//        let tile = self.tileAt(position: movement.start)
//        
//        assert(movement.end == emptySquare, "destination not empty")
//        assert(tile != nil, "tile not found")
//        
//        emptySquare = movement.start
//        tile?.position = movement.end
//    }
//
//    func tileMovementsFor(position: TilePosition) -> [TileMovement]
//    {
//        var movements: [TileMovement] = []
//        
//        if(self.isNextToEmptySquare(position: position))
//        {
//            movements.append(TileMovement(start: position, end: emptySquare))
//        }
//        else if(self.isInRowToEmptySquare(position: position))
//        {
//            var dr = 0, dc = 0
//            if(self.emptySquare.row != position.row)
//            {
//                dr = (self.emptySquare.row - position.row) / abs(self.emptySquare.row - position.row)
//            }
//            if(self.emptySquare.column != position.column) {
//                dc = (self.emptySquare.column - position.column) / abs(self.emptySquare.column - position.column)
//            }
//            
//            var row = self.emptySquare.row
//            var col = self.emptySquare.column
//            let endrow = position.row
//            let endcol = position.column
//            repeat
//            {
//                let esq = TilePosition(row: row, column: col)
//                
//                row -= dr
//                col -= dc
//                let tmptile = self.tileAt( position: TilePosition(row: row , column: col) )
//                
//                assert(tmptile != nil, "tile not found")
//                //                println("moving tile at \(row), \(col)")
//                movements.append(TileMovement(start: tmptile!.position, end: esq))
//            } while row != endrow || col != endcol
//        }
//        
//        return movements
//    }
//
//    func isSolved() -> Bool
//    {
//        for i in 0..<(rows * columns - 1)
//        {
//            let pos = TilePosition(row: i / columns + 1, column: (i % columns) + 1)
//            if(tiles[i].position != pos)
//            {
//                return false
//            }
//        }
//        return true
//    }
}
