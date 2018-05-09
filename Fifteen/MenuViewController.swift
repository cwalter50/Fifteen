//
//  MenuViewController.swift
//  Fifteen
//
//  Created by  on 5/9/18.
//  Copyright © 2018 AssistStat. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    // MARK: Properties
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    var quickGameButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 100, y: 0, width: 300, height: 100))
        button.backgroundColor = UIColor.aquaLight
        button.setTitle("Quick Game", for: .normal)
        button.addTarget(self, action: #selector(quickGame), for: .primaryActionTriggered)
        return button
    }()
    
//    var resetButton: UIButton = {
//        let button = UIButton(frame: CGRect(x: 100, y: 0, width: 300, height: 100))
//        button.backgroundColor = UIColor.red
//        button.setTitle("Reset Game", for: UIControlState.normal)
//        button.addTarget(self, action: #selector(resetBoard), for: .primaryActionTriggered)
//        return button
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createLabelsAndButtons()
    }
    
    func createLabelsAndButtons() {
        self.view.addSubview(quickGameButton)

        quickGameButton.center = view.center
    }

    @objc func quickGame() {
        performSegue(withIdentifier: "quickGameSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "quickGameSegue" {
            let destVC = segue.destination as! ViewController
            // pass in some settings like shuffle count and board size etc.
            destVC.shuffleCount = 10
        }
    }
    

}
