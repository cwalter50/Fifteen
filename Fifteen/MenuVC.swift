//
//  MenuVC.swift
//  Slidearoo
//
//  Created by  on 6/7/19.
//  Copyright © 2019 AssistStat. All rights reserved.
//

import UIKit

class MenuVC: UIViewController, CustomGameDelegate {
    
    // MARK: Properties
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    var gameSettings: GameSettings = GameSettings() // use default initializer for gameSettings which is 4 x 4 medium
    
    var quickGameButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 100, y: 0, width: 400, height: 100))
        button.backgroundColor = UIColor.mintDark
        button.setTitle("Quick Game", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir", size: 60)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(quickGame), for: .primaryActionTriggered)
        button.layer.cornerRadius = 10
        return button
    }()
    
    var customGameButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 100, y: 0, width: 400, height: 100))
        button.backgroundColor = UIColor.sunFlowerDark
        button.setTitle("Custom Game", for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(customGame), for: .primaryActionTriggered)
        button.titleLabel?.font = UIFont(name: "Avenir", size: 60.0)
        button.layer.cornerRadius = 10
        return button
    }()
    
    var resumeGameButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 100, y: 0, width: 400, height: 100))
        button.backgroundColor = UIColor.aquaDark
        button.setTitle("Resume Game", for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(resumeGame), for: .primaryActionTriggered)
        button.titleLabel?.font = UIFont(name: "Avenir", size: 60.0)
        button.layer.cornerRadius = 10
        return button
    }()
    
    var howToButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 100, y: 0, width: 400, height: 100))
        button.backgroundColor = UIColor.grapefruitDark
        button.titleLabel?.font = UIFont(name: "Avenir", size: 60.0)
        button.setTitle("How to Play", for: UIControl.State.normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(howToPlay), for: .primaryActionTriggered)
        button.layer.cornerRadius = 10
        return button
    }()
    
    var highScoresButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 100, y: 0, width: 400, height: 100))
        button.backgroundColor = UIColor.blueJeansDark
        button.titleLabel?.font = UIFont(name: "Avenir", size: 60.0)
        button.setTitle("High Scores", for: UIControl.State.normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(highScores), for: .primaryActionTriggered)
        button.layer.cornerRadius = 10
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createLabelsAndButtons()
        
//        if #available(tvOS 9.0,*)
//        {
//            print("Code that executes only on tvOS 9.0 or later.")
//        }
//
//        if #available(iOS 10.0,*)
//        {
//            print("Code that executes only on iOS 10.0 or later.")
//        }
        
//        #if os(iOS)
//            print("running on iOS")
//        #elseif os(tvOS)
//            print("running on tvOS")
//        #else
//            print("OMG, it's that mythical new Apple product!!!")
//        #endif
        
        
    }

    
    // this method is called whenever the focused item changes.. Not necessary for iOS.. only tvOS
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
        //        self.view.backgroundColor = UIColor.white
        view.addSubview(quickGameButton)
        view.addSubview(customGameButton)
        view.addSubview(resumeGameButton)
        view.addSubview(howToButton)
        view.addSubview(highScoresButton)
        
        let stackView = UIStackView(arrangedSubviews: [quickGameButton, customGameButton, resumeGameButton, howToButton, highScoresButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        // add Constraints
        stackView.heightAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.height*2/3).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width*2/3).isActive = true
        
    }
    
    @objc func customGame() {
        performSegue(withIdentifier: "customGameSettingsSegue", sender: self)
    }
    
    @objc func quickGame() {
        performSegue(withIdentifier: "quickGameSegue", sender: self)
    }
    
    @objc func howToPlay() {
        performSegue(withIdentifier: "HowToSegue", sender: self)
    }
    
    @objc func highScores() {
        performSegue(withIdentifier: "HighScoresSegue", sender: self)
    }
    
    var savedBoard: Board?
    
    @objc func resumeGame() {
        // load savedBoard if it exists.
        let decodedData = UserDefaults.standard.object(forKey: "savedBoard") as? Data
        
        if decodedData != nil {
            savedBoard = NSKeyedUnarchiver.unarchiveObject(with: decodedData!) as? Board
        }
        
        if savedBoard != nil {
            // pass savedBoard with segue
            
            performSegue(withIdentifier: "resumeGameSegue", sender: self)
        } else {
            // display error that says that we could not find a saved game.
            let alert = UIAlertController(title: "We did not find a saved game.", message: "Would you like to play a new game?", preferredStyle: .alert)
            let yesQuick = UIAlertAction(title: "Yes, Play Quick Game", style: .default, handler: {action in
                self.quickGame()
            })
            let yesCustom = UIAlertAction(title: "Yes, Play Custom Game", style: .default, handler: {action in
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
