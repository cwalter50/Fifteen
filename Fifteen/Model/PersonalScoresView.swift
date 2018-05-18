//
//  PersonalScoresView.swift
//  Fifteen
//
//  Created by  on 5/18/18.
//  Copyright © 2018 AssistStat. All rights reserved.
//

import UIKit

class PersonalScoresView: UIView {
    
    var gameScoreView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.backgroundColor = UIColor.blueJeansDark
        view.layer.cornerRadius = 10.0
        return view
    }()
    
    var levelAverageView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.backgroundColor = UIColor.bitterSweetDark
        view.layer.cornerRadius = 10.0
        return view
    }()
    
    var personalAverageView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.backgroundColor = UIColor.lavendarDark
        view.layer.cornerRadius = 10.0
        return view
    }()
    
    
    
    init(theFrame: CGRect) {
        
        super.init(frame: theFrame)
        self.gameScoreView = UIView(frame: CGRect(x: 0, y: 0, width: theFrame.width, height: theFrame.height / 3.0))
        self.levelAverageView = UIView(frame: CGRect(x: 0, y: theFrame.height / 3.0, width: theFrame.width, height: theFrame.height / 3.0))
        self.personalAverageView = UIView(frame: CGRect(x: 0, y: theFrame.height * 2.0 / 3.0, width: theFrame.width, height: theFrame.height / 3.0))
        
        
        self.addSubview(gameScoreView)
        
        self.addSubview(levelAverageView)
        
        self.addSubview(personalAverageView)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
