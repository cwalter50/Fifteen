//
//  MenuButton.swift
//  Fifteen
//
//  Created by Christopher Walter on 5/13/18.
//  Copyright © 2018 AssistStat. All rights reserved.
//

import UIKit

class MenuButton: UIButton {
    
    var name: String {
        didSet {
            self.setTitle(name, for: .normal)
        }
    }
    
    init(name: String, frame: CGRect) {
        self.name = name
        super.init(frame: frame)
        self.backgroundColor = UIColor.mintDark
        self.setTitle(name, for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = UIFont(name: "Avenir", size: 60.0)
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        
    }
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected == true {
                self.backgroundColor = UIColor.blueJeansDark
            }
            else {
                self.backgroundColor = UIColor.mintDark
            }
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
