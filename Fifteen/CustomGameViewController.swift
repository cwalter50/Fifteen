//
//  CustomGameViewController.swift
//  Fifteen
//
//  Created by  on 5/11/18.
//  Copyright © 2018 AssistStat. All rights reserved.
//

import UIKit

class CustomGameViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var rowsCollectionView: UICollectionView!
    var cellId = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    func createCollectionViews() {
        // Create an instance of UICollectionViewFlowLayout since you cant
        // Initialize UICollectionView without a layout
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: view.frame.width, height: 700)
        
        rowsCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        rowsCollectionView.dataSource = self
        rowsCollectionView.delegate = self
        rowsCollectionView.register(customCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        rowsCollectionView.showsVerticalScrollIndicator = false
        rowsCollectionView.backgroundColor = UIColor.white
        self.view.addSubview(rowsCollectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! customCollectionViewCell

        return cell
    }

    
}

class customCollectionViewCell: UICollectionViewCell {
    
//    var customLabel: UILabel = {
//       let label = UILabel(frame: )
//    }()
    
}
