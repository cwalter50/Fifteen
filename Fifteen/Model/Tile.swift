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
    var currentFrame: CGRect
    var bordersEmptyTile: Bool
    var nameLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.textColor = UIColor.black
        label.font = UIFont(name: "Avenir", size: 20)
        label.textAlignment = .center
        return label
    }()
    var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect.zero)
        imageView.contentMode = .scaleToFill
        imageView.image = nil
        return imageView
    }()

    // initializer used in board for Tiles with numbers
    init(position: TilePosition, name: Int, frame: CGRect) {
        self.position = position
        self.name = name
        self.bordersEmptyTile = false
        self.initialPosition = position
        self.initialFrame = frame
        self.currentFrame = frame

        super.init(frame: frame)
        setTileLabelsAndViews()
        
    }
    
    // initializer used if there is an image
    convenience init(position: TilePosition, name: Int, frame: CGRect, image: UIImage?)
    {
        self.init(position: position, name: name, frame: frame)
        
        imageView.image = image
        
    }
    
    
    init(row: Int, column: Int, initialRow: Int, initialColumn: Int, name: Int, initialFrame: CGRect, bordersEmptyTile: Bool, nameLabel: UILabel, currentFrame: CGRect) {
        self.position = TilePosition(row: row, column: column)
        self.name = name
        self.initialFrame = initialFrame
        self.initialPosition = TilePosition(row: initialRow, column: initialColumn)
        self.bordersEmptyTile = bordersEmptyTile
        self.nameLabel = nameLabel
        self.currentFrame = currentFrame
        super.init(frame: currentFrame) // might have to change this to currentFrame and not initialFrame.  TEST!!!
        setTileLabelsAndViews()
    }
    
    func setTileLabelsAndViews() {
        
        self.nameLabel.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        //        nameLabel.center = self.center
        self.nameLabel.font = UIFont(name: "Avenir", size: frame.height*0.8)
        
        self.addSubview(nameLabel)
        
        self.backgroundColor = UIColor.blueJeansLight
        self.layer.cornerRadius = 10.0
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.borderWidth = 2.0
        self.setTileTitle()
        
        // move this above the nameLabel if you want numbers and images...
        imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        self.addSubview(imageView)
        
        
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
    
    func setImage(image: UIImage?)
    {
        imageView.image = image
    }
    required convenience init(coder aDecoder: NSCoder) {
        // use these to get position
        let row = aDecoder.decodeInteger(forKey: "row")
        let column = aDecoder.decodeInteger(forKey: "column")
        // use these to get initialPosition
        let initialRow = aDecoder.decodeInteger(forKey: "initialRow")
        let initialColumn = aDecoder.decodeInteger(forKey: "initialColumn")
        let name = aDecoder.decodeInteger(forKey: "name")
        let initialFrame = aDecoder.decodeCGRect(forKey: "initialFrame")
        let currentFrame = aDecoder.decodeCGRect(forKey: "currentFrame")
        let bordersEmptyTile = aDecoder.decodeBool(forKey: "bordersEmptyTile")
        let nameLabel = aDecoder.decodeObject(forKey: "nameLabel") as! UILabel
        self.init(row: row, column: column, initialRow: initialRow, initialColumn: initialColumn, name: name, initialFrame: initialFrame, bordersEmptyTile: bordersEmptyTile, nameLabel: nameLabel, currentFrame: currentFrame)
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        let row = position.row
        let column = position.column
        aCoder.encode(row, forKey: "row")
        aCoder.encode(column, forKey: "column")
        let initialRow = initialPosition.row
        let initialColumn = initialPosition.column
        aCoder.encode(initialRow, forKey: "initialRow")
        aCoder.encode(initialColumn, forKey: "initialColumn")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(initialFrame, forKey: "initialFrame")
        aCoder.encode(currentFrame, forKey: "currentFrame")
        aCoder.encode(bordersEmptyTile, forKey: "bordersEmptyTile")
        aCoder.encode(nameLabel, forKey: "nameLabel")
    }
}
struct TilePosition : Equatable
{
    var row: Int, column: Int
        
}


