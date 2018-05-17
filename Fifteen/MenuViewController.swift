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
        let button = UIButton(frame: CGRect(x: 100, y: 0, width: 400, height: 100))
        button.backgroundColor = UIColor.mintDark
        button.setTitle("Quick Game", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir", size: 60)
        button.addTarget(self, action: #selector(quickGame), for: .primaryActionTriggered)
        return button
    }()
    
    var customGameButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 100, y: 0, width: 400, height: 100))
        button.backgroundColor = UIColor.blueJeansDark
        button.setTitle("Custom Game", for: .normal)
        button.addTarget(self, action: #selector(customGame), for: .primaryActionTriggered)
        button.titleLabel?.font = UIFont(name: "Avenir", size: 60.0)
        
        return button
    }()
    
    var resumeGameButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 100, y: 0, width: 400, height: 100))
        button.backgroundColor = UIColor.aquaDark
        button.setTitle("Resume Game", for: .normal)
        button.addTarget(self, action: #selector(resumeGame), for: .primaryActionTriggered)
        button.titleLabel?.font = UIFont(name: "Avenir", size: 60.0)
        
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
        self.view.addSubview(resumeGameButton)
        
        quickGameButton.center = CGPoint(x: view.center.x, y: view.center.y - 200)
        customGameButton.center = CGPoint(x: view.center.x, y: view.center.y)
        resumeGameButton.center = CGPoint(x: view.center.x, y: view.center.y + 200)
    }
    
    @objc func customGame() {
        performSegue(withIdentifier: "customGameSettingsSegue", sender: self)
    }

    @objc func quickGame() {
        performSegue(withIdentifier: "quickGameSegue", sender: self)
    }
    
    var savedBoard: Board?
    @objc func resumeGame() {
        // load savedBoard if it exists.
        let decodedData = UserDefaults.standard.object(forKey: "savedBoard") as! Data
//        let decoded = userDefaults.object(forKey: "teams") as! Data
        let savedBoard = NSKeyedUnarchiver.unarchiveObject(with: decodedData) as? Board
//        savedBoard = UserDefaults.standard.object(forKey: "savedBoard") as? Board
        
        if savedBoard != nil {
            // pass savedBoard with segue
            performSegue(withIdentifier: "resumeGameSegue", sender: self)
        } else {
            // display error that says that we could not find a saved game.
            let alert = UIAlertController(title: "We did not find a saved game.", message: "Would you like to play a new game?", preferredStyle: .alert)
            let yesQuick = UIAlertAction(title: "Yes, Play Quick Game", style: .default, handler: {action in
                self.quickGame()
            })
            let yesCustom = UIAlertAction(title: "Yes, Play Default Game", style: .default, handler: {action in
                self.customGame()
            })
            let no = UIAlertAction(title: "No", style: .default, handler: nil)
            alert.addAction(yesQuick)
            alert.addAction(yesCustom)
            alert.addAction(no)
            self.present(alert, animated: true, completion: nil)
        }
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
        }
        
        if segue.identifier == "resumeGameSegue"{
            let destVC = segue.destination as! GameViewController
            // pass stuff here
            destVC.gameSettings = self.gameSettings
            destVC.savedBoard = savedBoard
            // figure out how to save current game and pass game to continue.
        }
    }
    

}
