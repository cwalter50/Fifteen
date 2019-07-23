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
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.layer.cornerRadius = 10.0
        return button
    }()
    
    var rulesTextView: UITextView = {
        let textView = UITextView(frame: CGRect(x: 0, y: 0, width: 400, height: 500))
        textView.textColor = UIColor.white
        textView.font = UIFont(name: "Avenir", size: 40.0)
        textView.text = "Slide the tiles around until you reach the solved puzzle.  A solved puzzle will always have the empty tile in the bottom right.  Number Puzzles will start with a \"1\" in the top left, followed by increasing consecutive numbers, and the empty tile in the bottom right.  Below is an example of a solved board with the numbers 1-15."
        textView.backgroundColor = UIColor.clear
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
        
        #if os(iOS)
            setUpViewsiOS()
        #elseif os(tvOS)
            setUpViewstvOS()
        #else
            print("OMG, it's that mythical new Apple product!!!")
            setUpViewsiOS()
        #endif


        
    }
    //this will make sure text view is scrolled to the top when view opens
    override func viewDidLayoutSubviews() {
        self.rulesTextView.setContentOffset(.zero, animated: false)
    }
    
    
    
    @objc func backToGame(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUpViewsiOS() {
        print("setUp views for iOS")
        self.view.backgroundColor = UIColor.blueJeansLight
        
        self.view.addSubview(backButton)
        self.view.addSubview(rulesTextView)
        self.view.addSubview(solvedBoardImageView)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        rulesTextView.translatesAutoresizingMaskIntoConstraints = false
        solvedBoardImageView.translatesAutoresizingMaskIntoConstraints = false
        
        rulesTextView.font = UIFont(name: "Avenir", size: 25.0)
        
        // constraints for all objects
        backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        backButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        solvedBoardImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        solvedBoardImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        solvedBoardImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        solvedBoardImageView.heightAnchor.constraint(equalToConstant: view.bounds.width - 48).isActive = true
        
        rulesTextView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 10).isActive = true
        rulesTextView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        rulesTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        rulesTextView.bottomAnchor.constraint(equalTo: solvedBoardImageView.topAnchor, constant: -10).isActive = true
        
    }
    
    func setUpViewstvOS() {
        print("set up views for tvOS")
        self.view.backgroundColor = UIColor.blueJeansLight
        self.view.addSubview(backButton)
        self.view.addSubview(rulesTextView)
        self.view.addSubview(solvedBoardImageView)
        backButton.translatesAutoresizingMaskIntoConstraints = true
        rulesTextView.translatesAutoresizingMaskIntoConstraints = true
        solvedBoardImageView.translatesAutoresizingMaskIntoConstraints = true
        
        backButton.center = CGPoint(x: view.center.x, y: height * 0.07)
        rulesTextView.frame = CGRect(x: 0, y: 0, width: width * 0.8, height: height * 0.4)
        rulesTextView.center = CGPoint(x: view.center.x, y: height * 0.35)
        solvedBoardImageView.center = CGPoint(x: view.center.x, y: height * 0.7)
        
        
    }


   

}
