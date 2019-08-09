//
//  SelectDifficultyVC.swift
//  Fifteen
//
//  Created by Christopher Walter on 7/29/19.
//  Copyright © 2019 AssistStat. All rights reserved.
//

import UIKit

@objc protocol SelectDifficultyDelegate {
    func difficultySelected(difficulty: String?)
}

class SelectDifficultyVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var difficulties: [String] = [String]()
    
    weak var delegate: SelectDifficultyDelegate?
    
    
    let mainView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.layer.borderColor = UIColor.blueJeansDark.cgColor
        view.layer.shadowOffset = CGSize(width: 20, height: 20)
        view.layer.shadowRadius = 20
        view.layer.shadowOpacity = 0.5
        view.layer.masksToBounds = true
        view.layer.borderWidth = 3.0
        view.isUserInteractionEnabled = true
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(cancelTapped))
//        view.addGestureRecognizer(tap)
        return view
    }()
    let headerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        view.backgroundColor = UIColor.blueJeansDark
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.layer.borderColor = UIColor.blueJeansDark.cgColor
        //        view.layer.shadowOffset = CGSize(width: 20, height: 20)
        //        view.layer.shadowRadius = 20
        //        view.layer.shadowOpacity = 0.5
        view.layer.masksToBounds = true
        view.layer.borderWidth = 3.0
        
        return view
    }()
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        titleLabel.font = UIFont(name: "Avenir Medium", size: 50.0)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.white
        titleLabel.text = "Select Difficulty Level"
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        button.backgroundColor = UIColor.bitterSweetDark
        button.setTitle("CANCEL", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir Medium", size: 50.0)
        button.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.layer.shadowOffset = CGSize(width: 20, height: 20)
        button.layer.shadowRadius = 20
        button.layer.shadowOpacity = 0.5
        
        
        return button
    }()
    
    var myTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // load difficulties
            // difficulty level is saved as "\(rows) x \(columns) \(difficulty)"
        let rows = [3,4,5,6]
        let columns = [3,4,5,6]
        let difficultyNames = ["easy", "medium", "hard", "black belt"]
        
        for r in rows
        {
            for c in columns
            {
                for d in difficultyNames
                {
                    difficulties.append("\(r) x \(c) \(d)")
                }
            }
        }
        setupViews()

        
        // this is for custom Popup animation. THe other part is in viewDidAPpear
        mainView.alpha = 0
        mainView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // this will make the view appera with a cool enlarging spring motion.
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 10, options: .curveLinear, animations: {
            self.mainView.alpha = 1
            self.mainView.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    
    func setupViews()
    {
        // make view transparent
        view.backgroundColor = UIColor(red: 155.0/255.0, green: 155.0/255.0, blue: 155.0/255.0, alpha: 0.5)
        
        // set up MainView
        self.view.addSubview(mainView)
        mainView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        mainView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        mainView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/1.5).isActive = true
        mainView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 1.5).isActive = true
        
        self.mainView.addSubview(headerView)
        headerView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 10).isActive = true
        headerView.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -10).isActive = true
        headerView.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 10).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        headerView.addSubview(titleLabel)
        
        titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -20).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 20).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        mainView.addSubview(cancelButton)
        cancelButton.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -10).isActive = true
        cancelButton.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -10).isActive = true
        cancelButton.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 10).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // set up myTableView
        myTableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100))
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.translatesAutoresizingMaskIntoConstraints = false
        
        mainView.addSubview(myTableView)
        
        myTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        myTableView.bottomAnchor.constraint(equalTo: cancelButton.topAnchor).isActive = true
        myTableView.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 8).isActive = true
        myTableView.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -8).isActive = true
        
    }
    
    
    @objc func cancelTapped()
    {
//        delegate?.difficultySelected(difficulty: nil)
        coolDismiss()
    }
    
    func coolDismiss()
    {
        print("should dismiss")
        self.dismiss(animated: true, completion: nil)
        //        // cool custom dismiss with pop
        //        UIView.animate(withDuration: 0.3, animations: {
        //            self.mainView.transform = CGAffineTransform(translationX: 0, y: -self.view.frame.height)
        //        }, completion: {(action) in
        //            self.dismiss(animated: true, completion: nil)
        //        })
    }
    
    
    
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return difficulties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        
        // Configure the cell...
        let difficulty = difficulties[indexPath.row]
        
        cell.textLabel!.text = difficulty
        cell.textLabel?.font = UIFont(name: "Avenir Medium", size: 20.0)
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        
        //        cell.detailTextLabel!.text = season.notes
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let diff = difficulties[indexPath.row]
        
        // send the season backwards
        delegate?.difficultySelected(difficulty: diff)
        coolDismiss()
        
        
        
    }
    
}
