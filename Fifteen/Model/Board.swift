//
//  Board.swift
//  Fifteen
//
//  Created by Christopher Walter on 4/2/18.
//  Copyright © 2018 AssistStat. All rights reserved.
//

import UIKit

class Board: NSObject, NSCoding {
    
    var rows: Int, columns: Int

//    var emptySquare: TilePosition
    var emptyTile: Tile

    var tiles = [Tile]()
    var backgroundView: UIView
    var moves: Int = 0
    var time: Int = 0
    var solutionImage: UIImage?

    init(rows: Int, columns: Int)
    {
        self.rows = rows
        self.columns = columns
        
        let theMax = max(rows, columns) // this will make sure that the block width will fit horizontally or vertically
        
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        var blockWidth: CGFloat = 10
        if height > width { // this would be iOS
            blockWidth = (width - 48.0) / CGFloat(theMax) // small buffer for ios for boundaries
        }
        else {
            blockWidth = (height - 300.0) / CGFloat(theMax) // for tvOS.. larger buffer
        }
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
        moves = 0
        time = 0
        
    }
    
    convenience init (rows: Int, columns: Int, image: UIImage?)
    {
        self.init(rows: rows, columns: columns)
        solutionImage = image
        
        // figure out how to set the tiles image to the cropped version of the solution image
        for tile in tiles
        {
            // get width, height, x, and y for cropped image.
            if tile.name != 0
            {
                if let theImage = solutionImage
                {
                    let width = theImage.size.width / CGFloat(columns)
                    let height = theImage.size.height / CGFloat(rows)
                    // the width on the frame, will be different than the width on the UIImage. ie the frame might have a height of 100 pixels, but the image will be 1024 X 1024 pixels
                    let x = CGFloat(tile.initialPosition.column - 1) * (width)
                    let y = CGFloat(tile.initialPosition.row - 1) * (height)
                    
                    tile.imageView.image = cropImage(image: solutionImage, toRect: CGRect(x: x, y: y, width: width, height: height))
                }
                else
                {
                    print("Error. There is no solution image...")
                }
            }
        }
    }
    
    // helper method to crop the image
    func cropImage(image: UIImage?, toRect: CGRect) -> UIImage? {
        // Cropping is available trhough CGGraphics
        if let theImage = image, let cgImage: CGImage = theImage.cgImage, let croppedCGImage: CGImage = cgImage.cropping(to: toRect)
        {
            return UIImage(cgImage: croppedCGImage)
        }
        else
        {
            return UIImage(named: "Test")
        }
        
    }
    
    init(rows: Int, columns:Int, emptyTile: Tile, tiles: [Tile], moves: Int, time: Int, backgroundView: UIView) {
        self.rows = rows
        self.columns = columns
        self.emptyTile = emptyTile
        self.tiles = tiles
        self.moves = moves
        self.time = time
        self.backgroundView = backgroundView
        
        for tile in tiles {
            self.backgroundView.addSubview(tile)
        }
    }
    
    func shuffle(numberOfMoves: Int) {
        for _ in 0..<numberOfMoves {
            // find all possible moves.  up to 4.
            var possibleTiles: [Tile] = []
            for tile in self.tiles {
                if isNextToEmptySquare(position: tile.position) {
                    possibleTiles.append(tile)
                }
            }
            // select a random one of the possible moves and move
            let randIndex = Int(arc4random_uniform(UInt32(possibleTiles.count)))
            let tileToMove = possibleTiles[randIndex]
            self.moveNoAnimation(startPosition: tileToMove.position)
        }
        // reset moves to 0, because you are shuffling and starting over
        self.moves = 0
        // set initialTiles to whatever the shuffle comes out to
        // cycle through tiles and reset initial name so that it can be reset by user
        for tile in tiles {
            tile.initialPosition = tile.position
            tile.initialFrame = tile.frame
            tile.currentFrame = tile.frame
        }
    }
    // this function will move swap the tile in the start position with the emptyTile.  The check if its valid happens in the game.
    func moveNoAnimation(startPosition: TilePosition) {
        // get the tile you want to move
        if let tile = self.tileAt(position: startPosition) {
            // this works with no animation.  uncomment if animation doesnt work.
            let holdingFrame = emptyTile.frame
            let holdingPosition = emptyTile.position

            // swap emptyTile with tile's frame and position
            emptyTile.frame = tile.frame
            emptyTile.position = tile.position
            emptyTile.currentFrame = tile.frame // this is used to help save and load game

            tile.frame = holdingFrame
            tile.position = holdingPosition
            tile.currentFrame = holdingFrame // this is used to help save and load game


            moves += 1
            
        }
    }
    
    func moveWithAnimation(startPosition: TilePosition) {
        if let tile = self.tileAt(position: startPosition) {
            // create a blank tile and place behind moving tile and empty tile.  They will be removed on completion of animation
            let holdingTile = Tile(position: tile.position, name: 0, frame: tile.frame)
            let holdingTile2 = Tile(position: emptyTile.position, name: 0, frame: emptyTile.frame)
            let holdingPosition = emptyTile.position
            self.backgroundView.addSubview(holdingTile)
            self.backgroundView.addSubview(holdingTile2)
            backgroundView.sendSubviewToBack(holdingTile)
            backgroundView.sendSubviewToBack(holdingTile2)
            backgroundView.bringSubviewToFront(tile)
//            UIView.animate(withDuration: 0.25, animations: {
//                tile.frame = self.emptyTile.currentFrame
//                tile.currentFrame = tile.frame
//                })
            UIView.animate(withDuration: 0.2,
                           animations: {
                            tile.frame = self.emptyTile.currentFrame
                            tile.currentFrame = tile.frame },
                           completion: { (action) in

                            holdingTile2.removeFromSuperview()
                            holdingTile.removeFromSuperview()
                            })
            self.emptyTile.frame = holdingTile.frame
            self.emptyTile.position = holdingTile.position
            self.emptyTile.currentFrame = holdingTile.frame
            
            tile.position = holdingPosition
            moves += 1
        }
    }
    
    func moveDirection(direction: UISwipeGestureRecognizer.Direction) {
        
        // get tile next to position
        var tileToMove: Tile?
        switch direction {
        case .up:
            tileToMove = tileAt(position: TilePosition(row: emptyTile.position.row+1, column: emptyTile.position.column))
        case .down:
            tileToMove = tileAt(position: TilePosition(row: emptyTile.position.row-1, column: emptyTile.position.column))
        case .left:
            tileToMove = tileAt(position: TilePosition(row: emptyTile.position.row, column: emptyTile.position.column+1))
        case .right:
            tileToMove = tileAt(position: TilePosition(row: emptyTile.position.row, column: emptyTile.position.column-1))
        default:
            print("did not swipe up, down, left, or right")
        }
        
        if let foundTile = tileToMove {
        
            moveWithAnimation(startPosition:foundTile.position)
        } else {
            print("not a valid swipe direction for current position")
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
        
        // reset moves to 0, because you are shuffling and starting over
        self.moves = 0
        self.time = 0
    }
    
    func setBoardToInitialState() {
        // set board to initialState, then set tile title again.

        for tile in tiles {
            tile.frame = tile.initialFrame
            tile.position = tile.initialPosition
            tile.currentFrame = tile.initialFrame
        }
        moves = 0
        time = 0
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let rows = aDecoder.decodeInteger(forKey: "rows")
        let columns = aDecoder.decodeInteger(forKey: "columns")
        let moves = aDecoder.decodeInteger(forKey: "moves")
        let time = aDecoder.decodeInteger(forKey: "time")
//        let backgroundView = aDecoder.decodeObject(forKey: "backgroundView") as? UIView
        let backgroundView = aDecoder.decodeCGRect(forKey: "backgroundView")
        let emptyTile = aDecoder.decodeObject(forKey: "emptyTile") as! Tile
        let tiles = aDecoder.decodeObject(forKey: "tiles") as! [Tile]
        
        self.init(rows: rows, columns: columns, emptyTile: emptyTile, tiles: tiles, moves: moves, time: time, backgroundView: UIView(frame: backgroundView))
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(rows, forKey: "rows")
        aCoder.encode(columns, forKey: "columns")
        aCoder.encode(moves, forKey: "moves")
        aCoder.encode(time, forKey: "time")
        aCoder.encode(backgroundView.frame, forKey: "backgroundView")
        aCoder.encode(emptyTile, forKey: "emptyTile")
        aCoder.encode(tiles, forKey: "tiles")
    }


}
