//
//  HowToPlayViewController.swift
//  Fifteen
//
//  Created by Christopher Walter on 6/6/18.
//  Copyright © 2018 AssistStat. All rights reserved.
//

import UIKit

class HowToPlayViewController: UIViewController {

    // MARK: Properties
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    
    var backButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 100, y: 0, width: 300, height: 100))
        button.backgroundColor = UIColor.grapefruitDark
        button.titleLabel?.font = UIFont(name: "Avenir", size: 50.0)
        button.setTitle("Back", for: UIControl.State.normal)
        button.addTarget(self, action: #selector(backToGame), for: .primaryActionTriggered)
        return button
    }()
    
    var rulesTextView: UITextView = {
        let textView = UITextView(frame: CGRect(x: 0, y: 0, width: 400, height: 500))
        textView.textColor = UIColor.white
        textView.font = UIFont(name: "Avenir", size: 40.0)
        textView.text = "Slide the tiles around until you reach the solved puzzle.  A solved puzzle will always have the empty tile in the bottom right.  Number Puzzles will start with a \"1\" in the top left, followed by increasing consecutive numbers, and the empty tile in the bottom right.  Below is an example of a solved board with the numbers 1-15."
        return textView
    }()
    
    var solvedBoardImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 600, height: 600))
        imageView.image = #imageLiteral(resourceName: "SolvedBoard")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()


        setUpViews()
    }
    
    @objc func backToGame(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUpViews() {
        
        self.view.backgroundColor = UIColor.blueJeansLight
        self.view.addSubview(backButton)
        self.view.addSubview(rulesTextView)
        self.view.addSubview(solvedBoardImageView)
        
        backButton.center = CGPoint(x: view.center.x, y: height * 0.07)
        rulesTextView.frame = CGRect(x: 0, y: 0, width: width * 0.8, height: height * 0.4)
        rulesTextView.center = CGPoint(x: view.center.x, y: height * 0.35)
        solvedBoardImageView.center = CGPoint(x: view.center.x, y: height * 0.7)
    }


   

}
