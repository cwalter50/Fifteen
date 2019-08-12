//
//  HowToPlayViewController.swift
//  Fifteen
//
//  Created by Christopher Walter on 6/6/18.
//  Copyright © 2018 AssistStat. All rights reserved.
//

import UIKit

class HowToPlayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: Properties
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    var tableViewFont = UIFont(name: "Avenir", size: 40)
    
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
    
    var myTableView: UITableView = UITableView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        #if os(iOS)
            setUpViewsiOS()
        #elseif os(tvOS)
            setUpViewstvOS()
        #else
            print("OMG, it's that mythical new Apple product!!!")
            setUpViewsiOS()
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
    
    @objc func backToGame(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUpViewsiOS() {
        print("setUp views for iOS")
        self.view.backgroundColor = UIColor.white
        tableViewFont = UIFont(name: "Avenir", size: 20)
        
        self.view.addSubview(backButton)

        
        myTableView = UITableView(frame: CGRect(x: 0, y: 0, width: width / 4.0, height: height * 0.7), style: UITableView.Style.plain)
        myTableView.center = CGPoint(x: width * 0.25 - 10, y: height * 0.5 + 10.0)
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
        myTableView.backgroundColor = UIColor.clear
        myTableView.layer.cornerRadius = 10.0
        myTableView.tableFooterView = UIView(frame: CGRect.zero)
        myTableView.translatesAutoresizingMaskIntoConstraints = false
        myTableView.allowsSelection = false
        // created a custom function to get headerView

        
        view.addSubview(myTableView)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
    
        // constraints for all objects
        backButton.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 50).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        backButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        myTableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -20).isActive = true
        myTableView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 20).isActive = true
        myTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        myTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        
    }
    
    func setUpViewstvOS() {
        print("set up views for tvOS")

        self.view.backgroundColor = UIColor.white
        tableViewFont = UIFont(name: "Avenir", size: 40)
        
        self.view.addSubview(backButton)
        
        myTableView = UITableView(frame: CGRect(x: 0, y: 0, width: width / 4.0, height: height * 0.7), style: UITableView.Style.plain)
        myTableView.center = CGPoint(x: width * 0.25 - 10, y: height * 0.5 + 10.0)
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
        myTableView.backgroundColor = UIColor.clear
        myTableView.layer.cornerRadius = 10.0
        myTableView.tableFooterView = UIView(frame: CGRect.zero)
        myTableView.translatesAutoresizingMaskIntoConstraints = false
        myTableView.allowsSelection = true
        // created a custom function to get headerView
        //        myTableView.tableHeaderView = getHeaderView(text: "My Best Scores")
        
        view.addSubview(myTableView)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
//        rulesTextView.font = UIFont(name: "Avenir", size: 25.0)
        
        // constraints for all objects
        backButton.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 50).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        backButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        myTableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -20).isActive = true
        myTableView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 20).isActive = true
        myTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        myTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
    }
    
    // MARK: TableView methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let theMin = min(width-80, 300)
        return theMin
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
        // rules, solved board, rules about picture game, solved Picture board
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        cell.textLabel?.font = tableViewFont // this updates based on if os is tvOS or iOS
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.imageView?.contentMode = .scaleAspectFit
        // this caused crashes during reuse cell.... had to remove...

        if indexPath.row == 0
        {
            // rules
            cell.imageView?.image = nil
            cell.textLabel?.text = "Slide the tiles around until you reach the solved puzzle.  A solved puzzle will always have the empty tile in the bottom right.  Number Puzzles will start with a \"1\" in the top left, followed by increasing consecutive numbers, and the empty tile in the bottom right.  Below is an example of a solved board with the numbers 1-15."
        } else if indexPath.row == 1
        {
            // picture
            cell.textLabel?.text = ""
            cell.imageView?.image = UIImage(named: "SolvedBoard")
        }
        else if indexPath.row == 2
        {
            // picture rules
            cell.imageView?.image = nil
            cell.textLabel?.text = "For picture puzzles, just slide the tiles around until it matches the solution image as seen below."
        }
        else
        {
            // picture
            cell.textLabel?.text = ""
            cell.imageView?.image = UIImage(named: "SolvedBoardPicture2")
        }
        
        return cell
    }


   

}
