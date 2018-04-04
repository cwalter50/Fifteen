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
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("screen width: \(width), screenHeight: \(height)")
//        blockWidth = height / 6.0
        createGameBoard()
    }
    
    func createGameBoard() {
        
        let board = Board(rows: 4, columns: 7)
        self.view.addSubview(board.backgroundView)
//        // create a 4x4 grid of buttons
//        let center = CGPoint(x: width * 0.5, y: height * 0.5)
//        for row in 0...3 {
//            for column in 0...3 {
//                // to find the position move to the center, then shift 2 blocks back and up.
//                let x = center.x - (2*blockWidth + 4) + CGFloat(column)*(blockWidth+2)
//                let y = center.y - (2*blockWidth + 4) + CGFloat(row)*(blockWidth+2)
//                let button = UIButton(frame: CGRect(x: x , y: y, width: blockWidth, height: blockWidth))
//                button.backgroundColor = UIColor.green
//                button.layer.cornerRadius = 10.0
//                button.layer.borderColor = UIColor.darkGray.cgColor
//                button.layer.borderWidth = 2.0
//                button.setTitle("Test", for: UIControlState())
//                self.view.addSubview(button)
//                
//            }
//        }
        
    }




}

