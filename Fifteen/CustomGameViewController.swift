//
//  CustomGameViewController.swift
//  Fifteen
//
//  Created by  on 5/11/18.
//  Copyright © 2018 AssistStat. All rights reserved.
//

import UIKit

protocol CustomGameDelegate {
    func playGame(newGameSettings: GameSettings)
}

class CustomGameViewController: UIViewController {

    var rowsCollectionView: UICollectionView!
    var cellId = "Cell"
    
    // MARK: Properties
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    var delegate: CustomGameDelegate?
    var gameSettings = GameSettings()
    
    var rowButtons: [MenuButton] = [MenuButton]()
    var columnButtons: [MenuButton] = [MenuButton]()
    var difficultyButtons: [MenuButton] = [MenuButton]()
//    var rows = 4
//    var columns = 4
//    var difficulty = "Medium"
    
    let rowLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 200, y: 200, width: 350, height: 100))
        label.font = UIFont(name: "Avenir", size: 60.0)
        label.text = "Rows"
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.black
        label.backgroundColor = UIColor.sunFlowerLight
        label.layer.cornerRadius = 10.0
        label.layer.borderColor = UIColor.darkGray.cgColor
        label.layer.borderWidth = 2.0
        label.layer.masksToBounds = true
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    let columnLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 200, y: 200, width: 350, height: 100))
        label.font = UIFont(name: "Avenir", size: 60.0)
        label.text = "Columns"
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.black
        label.backgroundColor = UIColor.sunFlowerLight
        label.layer.cornerRadius = 10.0
        label.layer.borderColor = UIColor.darkGray.cgColor
        label.layer.borderWidth = 2.0
        label.layer.masksToBounds = true
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    let difficultyLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 200, y: 200, width: 350, height: 100))
        label.font = UIFont(name: "Avenir", size: 60.0)
        label.text = "Difficulty"
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.black
        label.backgroundColor = UIColor.sunFlowerLight
        label.layer.cornerRadius = 10.0
        label.layer.borderColor = UIColor.darkGray.cgColor
        label.layer.borderWidth = 2.0
        label.layer.masksToBounds = true
        label.adjustsFontSizeToFitWidth = true

        return label
    }()
    
    var playGameButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 200, y: 200, width: 350, height: 150))
        button.backgroundColor = UIColor.blueJeansDark
        button.setTitle("Play", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir", size: 60.0)
        button.addTarget(self, action: #selector(playGameTapped), for: .primaryActionTriggered)
        button.titleLabel?.adjustsFontSizeToFitWidth = true

        
        return button
    }()
    
    var backButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 100, y: 0, width: 350, height: 150))
        button.backgroundColor = UIColor.bitterSweetDark
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir", size: 60.0)
        button.addTarget(self, action: #selector(backButtonTapped), for: .primaryActionTriggered)
        button.titleLabel?.adjustsFontSizeToFitWidth = true

        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        #if os(iOS)
        print("running on iOS")
        createButtonsAndLabelsiOS()
        self.title = "Slidearoo"
        
        #elseif os(tvOS)
        print("running on tvOS")
        createButtonsAndLabelstvOS()
        
        #else
        print("OMG, it's that mythical new Apple product!!!")
        #endif
        
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
    
    func createButtonsAndLabelstvOS() {
        view.addSubview(rowLabel)
        rowLabel.center = CGPoint(x: width * 0.2, y: height * 0.1)
        view.addSubview(columnLabel)
        columnLabel.center = CGPoint(x: width * 0.5, y: height * 0.1)
        view.addSubview(difficultyLabel)
        difficultyLabel.center = CGPoint(x: width * 0.8, y: height * 0.1)
        view.addSubview(playGameButton)
        playGameButton.center = CGPoint(x: width * 0.6, y: height * 0.9)
        view.addSubview(backButton)
        backButton.center = CGPoint(x: width * 0.4, y: height * 0.9)
        
        // create 4 row, 4 column, and 4 difficulty MenuButtons
        
        for i in 3...6 {
            let rowButton = MenuButton(name: "\(i)", frame: CGRect(x: 0, y: 0, width: 350, height: 150))

            rowButton.addTarget(self, action: #selector(rowButtonTapped), for: .primaryActionTriggered)
            self.view.addSubview(rowButton)
            rowButtons.append(rowButton)
            rowButton.center = CGPoint(x: width*0.2, y: height * 0.1 + 160 * (CGFloat(i) - 2.0))
            // these are the columns buttons
            let button = MenuButton(name: "\(i)", frame: CGRect(x: 0, y: 0, width: 350, height: 150))

            button.addTarget(self, action: #selector(columnButtonTapped), for: .primaryActionTriggered)
            self.view.addSubview(button)
            columnButtons.append(button)
            button.center = CGPoint(x: width*0.5, y: height * 0.1 + 160 * (CGFloat(i) - 2.0))
            if gameSettings.rows == i {
                rowButton.isSelected = true
            }
            if gameSettings.columns == i {
                button.isSelected = true
            }
        }
        
        var difficultyNames = ["easy", "medium", "hard", "black belt"]
        for i in 0..<difficultyNames.count {
            
            let button = MenuButton(name: "\(difficultyNames[i])", frame: CGRect(x: 0, y: 0, width: 350, height: 150))

            button.addTarget(self, action: #selector(difficultyButtonTapped), for: .primaryActionTriggered)
            self.view.addSubview(button)
            difficultyButtons.append(button)
            button.center = CGPoint(x: width*0.8, y: height * 0.1 + 160 * (CGFloat(i) + 1.0))
            if gameSettings.difficulty == difficultyNames[i] {
                button.isSelected = true
            }
        }
    }
    
    func createButtonsAndLabelsiOS() {
        view.addSubview(rowLabel)
        view.addSubview(columnLabel)
        view.addSubview(difficultyLabel)
        view.addSubview(playGameButton)
        view.addSubview(backButton)
        
        playGameButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false

        rowLabel.font = UIFont(name: "Avenir", size: 30)
        columnLabel.font = UIFont(name: "Avenir", size: 30)
        difficultyLabel.font = UIFont(name: "Avenir", size: 30)
        backButton.titleLabel?.font = UIFont(name: "Avenir", size: 30)
        playGameButton.titleLabel?.font = UIFont(name: "Avenir", size: 30)
        
        // create 4 row, 4 column, and 4 difficulty MenuButtons
        
        for i in 3...6 {
            let rowButton = MenuButton(name: "\(i)", frame: CGRect(x: 0, y: 0, width: 350, height: 150))
            
            rowButton.addTarget(self, action: #selector(rowButtonTapped), for: .primaryActionTriggered)
            self.view.addSubview(rowButton)
            rowButtons.append(rowButton)
            rowButton.center = CGPoint(x: width*0.2, y: height * 0.1 + 160 * (CGFloat(i) - 2.0))
            // these are the columns buttons
            let button = MenuButton(name: "\(i)", frame: CGRect(x: 0, y: 0, width: 350, height: 150))
            
            button.addTarget(self, action: #selector(columnButtonTapped), for: .primaryActionTriggered)
            self.view.addSubview(button)
            columnButtons.append(button)
            button.center = CGPoint(x: width*0.5, y: height * 0.1 + 160 * (CGFloat(i) - 2.0))
            if gameSettings.rows == i {
                rowButton.isSelected = true
            }
            if gameSettings.columns == i {
                button.isSelected = true
            }
        }
        
        var difficultyNames = ["easy", "medium", "hard", "black belt"]
        for i in 0..<difficultyNames.count {
            
            let button = MenuButton(name: "\(difficultyNames[i])", frame: CGRect(x: 0, y: 0, width: 350, height: 150))
            
            button.addTarget(self, action: #selector(difficultyButtonTapped), for: .primaryActionTriggered)
            button.titleLabel?.font = UIFont(name: "Avenir", size: 30)
            self.view.addSubview(button)
            difficultyButtons.append(button)
            button.center = CGPoint(x: width*0.8, y: height * 0.1 + 160 * (CGFloat(i) + 1.0))
            if gameSettings.difficulty == difficultyNames[i] {
                button.isSelected = true
            }
        }
        
        // create 3 vertical stackviews for rows, columns, difficulty. then place all three in 1 horizontal stackview
        // add playgame button and back button at the bottom
        let rowStack = UIStackView(arrangedSubviews: [rowLabel])
        for button in rowButtons
        {
            rowStack.addArrangedSubview(button)
        }
        rowStack.axis = .vertical
        rowStack.distribution = .fillEqually
        rowStack.alignment = .fill
        rowStack.spacing = 5
        rowStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rowStack)
        
        let columnStack = UIStackView(arrangedSubviews: [columnLabel])
        for button in columnButtons
        {
            columnStack.addArrangedSubview(button)
        }
        columnStack.axis = .vertical
        columnStack.distribution = .fillEqually
        columnStack.alignment = .fill
        columnStack.spacing = 5
        columnStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(columnStack)
        
        let difficultyStack = UIStackView(arrangedSubviews: [difficultyLabel])
        for button in difficultyButtons
        {
            difficultyStack.addArrangedSubview(button)
        }
        difficultyStack.axis = .vertical
        difficultyStack.distribution = .fillEqually
        difficultyStack.alignment = .fill
        difficultyStack.spacing = 5
        difficultyStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(difficultyStack)
        
        let bottomStack = UIStackView(arrangedSubviews: [backButton, playGameButton])
        bottomStack.axis = .horizontal
        bottomStack.distribution = .fillEqually
        bottomStack.alignment = .fill
        bottomStack.spacing = 5
        bottomStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomStack)
        
        let tableStack = UIStackView(arrangedSubviews: [rowStack, columnStack, difficultyStack])
        tableStack.axis = .horizontal
        tableStack.distribution = .fillEqually
        tableStack.alignment = .fill
        tableStack.spacing = 5
        tableStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableStack)
        
        let mainStack = UIStackView(arrangedSubviews: [tableStack, bottomStack])
        mainStack.axis = .vertical
        mainStack.distribution = .equalCentering
        mainStack.alignment = .fill
        mainStack.spacing = 5
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainStack)
        
        
        // add constraints
        bottomStack.heightAnchor.constraint(equalToConstant: 60).isActive = true
        mainStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 120).isActive = true
        mainStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        mainStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        mainStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
    }
    

    @objc func difficultyButtonTapped(sender: UIButton) {
        for button in difficultyButtons {
            button.isSelected = false
        }
        sender.isSelected = true
        let difficultyString = sender.title(for: .normal) ?? ""
        gameSettings.difficulty = difficultyString
        
    }
    @objc func columnButtonTapped(sender: UIButton) {
        for button in columnButtons {
            button.isSelected = false
        }
        sender.isSelected = true
        let columnString = sender.title(for: .normal) ?? ""
        gameSettings.columns = Int(columnString) ?? 4
        
    }
    @objc func rowButtonTapped(sender: UIButton) {
        for button in rowButtons {
            button.isSelected = false
        }
        sender.isSelected = true
        let rowString = sender.title(for: .normal) ?? ""
        gameSettings.rows = Int(rowString) ?? 4
        
    }
    
    @objc func backButtonTapped(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func playGameTapped(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        print("playing customGame with \(gameSettings.difficultyLevel)")
        delegate?.playGame(newGameSettings: gameSettings)
    }
    
}


