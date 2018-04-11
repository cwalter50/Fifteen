//
//  ViewController.swift
//  Fifteen
//
//  Created by Christopher Walter on 4/2/18.
//  Copyright © 2018 AssistStat. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: Properties
//    let width = UIScreen.main.bounds.width
//    let height = UIScreen.main.bounds.height
//    var blockWidth: CGFloat = 0.0
    var board: Board = Board(rows: 4, columns: 4)
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("screen width: \(width), screenHeight: \(height)")
//        blockWidth = height / 6.0
        createGameBoard()
        // figure out a setting to shuffle board for easy/ medium, or hard
        board.shuffle(numberOfMoves: 20)
    }
    
    // this method is called whenever the focused item changes
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        let tile = context.nextFocusedView
        tile?.layer.shadowOffset = CGSize(width: 0, height: 10)
        tile?.layer.shadowOpacity = 0.6
        tile?.layer.shadowRadius = 15
        tile?.layer.shadowColor = UIColor.black.cgColor
        context.previouslyFocusedView?.layer.shadowOpacity = 0
    }
    
    func createGameBoard() {
        self.view.addSubview(board.backgroundView)
        
        // add target to each tile
        for tile in board.tiles {
            tile.addTarget(self, action: #selector(tileTapped), for: .primaryActionTriggered)
        }
        
    }
    
    @objc func tileTapped(sender: Tile) {
        print("\(sender.name) was tapped.")

        if board.isNextToEmptySquare(position: sender.position) {
            board.move(startPosition: sender.position)
        }
        else {
            print("tile: \(sender.name) is invalid to move")
            board.resetBoard()
        }
        
        // check if board is solved
        if board.isSolved() {
            print("board solved!!!")
        }
        
        
    }

    


}

