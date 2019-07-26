//
//  GameImageCell.swift
//  Fifteen
//
//  Created by Christopher Walter on 7/26/19.
//  Copyright © 2019 AssistStat. All rights reserved.
//

import UIKit

class GameImageCell: UICollectionViewCell {
    static var identifier: String = "Cell"
    
    var image: UIImage? {
        didSet {
            if let myImage = image
            {
                imageView.image = myImage
                textLabel.text = ""
            }
            else
            {
                imageView.image = nil
                textLabel.text = "Error: No Image"
            }
        }
    }
    
    var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "Test")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    weak var textLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        self.contentView.addSubview(imageView)
        imageView.image = image
        // set constraints
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        
        
        // currently not using textLabel... I found this code online and thought it might be helpful later
        let textLabel = UILabel(frame: .zero)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(textLabel)
        NSLayoutConstraint.activate([
            self.contentView.centerXAnchor.constraint(equalTo: textLabel.centerXAnchor),
            self.contentView.centerYAnchor.constraint(equalTo: textLabel.centerYAnchor),
            ])
        self.textLabel = textLabel
        self.reset()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.reset()
    }
    
    func reset() {
        self.textLabel.textAlignment = .center
    }
}


