//
//  MenuViewController.swift
//  Fifteen
//
//  Created by  on 5/9/18.
//  Copyright © 2018 AssistStat. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, CustomGameDelegate {

    // MARK: Properties
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    var gameSettings: GameSettings = GameSettings() // use default initializer for gameSettings which is 4 x 4 medium
    
    var quickGameButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 100, y: 0, width: 300, height: 100))
        button.backgroundColor = UIColor.aquaLight
        button.setTitle("Quick Game", for: .normal)
        button.addTarget(self, action: #selector(quickGame), for: .primaryActionTriggered)
        return button
    }()
    
    var customGameButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 100, y: 0, width: 300, height: 100))
        button.backgroundColor = UIColor.aquaLight
        button.setTitle("Custom Game", for: .normal)
        button.addTarget(self, action: #selector(customGame), for: .primaryActionTriggered)
        
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createLabelsAndButtons()
    }
    
    // this method is called whenever the focused item changes
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        let button = context.nextFocusedView
        button?.layer.shadowOffset = CGSize(width: 0, height: 10)
        button?.layer.shadowOpacity = 0.6
        button?.layer.shadowRadius = 15
        button?.layer.shadowColor = UIColor.black.cgColor
        context.previouslyFocusedView?.layer.shadowOpacity = 0
    }
    
    func createLabelsAndButtons() {
        self.view.addSubview(quickGameButton)
        self.view.addSubview(customGameButton)
        
        quickGameButton.center = CGPoint(x: view.center.x, y: view.center.y - 100)
        customGameButton.center = CGPoint(x: view.center.x, y: view.center.y + 100)
    }
    
    @objc func customGame() {
        performSegue(withIdentifier: "customGameSettingsSegue", sender: self)
    }

    @objc func quickGame() {
        performSegue(withIdentifier: "quickGameSegue", sender: self)
    }
    
    func playGame(newGameSettings: GameSettings) {
        self.gameSettings = newGameSettings
        performSegue(withIdentifier: "playCustomGame", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "quickGameSegue" {
            let destVC = segue.destination as! GameViewController
            // pass in some settings like shuffle count and board size etc.
            destVC.gameSettings = self.gameSettings
//            destVC.shuffleCount = 100
//            destVC.rows = 4
//            destVC.columns = 4
//            destVC.difficulty = "Medium"
        }
        if segue.identifier == "customGameSettingsSegue" {
            let destVC = segue.destination as! CustomGameViewController
            // pass stuff here
            destVC.delegate = self
            destVC.gameSettings = self.gameSettings
        }
        if segue.identifier == "playCustomGame" {
            let destVC = segue.destination as! GameViewController
            // pass stuff here
            destVC.gameSettings = self.gameSettings
//            destVC.shuffleCount = 100
//            destVC.rows = rows
//            destVC.columns = columns
//            destVC.difficulty = difficulty
        }
    }
    

}
