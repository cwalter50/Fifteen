//
//  ChoosePictureVC.swift
//  Fifteen
//
//  Created by Christopher Walter on 7/26/19.
//  Copyright © 2019 AssistStat. All rights reserved.
//

import UIKit

protocol ChoosePictureVCDelegate {
    func playGame(image: UIImage?)
}

class ChoosePictureVC: UIViewController {

    // MARK: Properties
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    var imageStrings: [String] = [String]()
    var gameImages: [UIImage?] = [UIImage?]()
    
    var gameSettings: GameSettings = GameSettings() // use default initializer for gameSettings which is 4 x 4 medium
    
    var delegate: ChoosePictureVCDelegate?
    
    var playGameButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 200, y: 200, width: 350, height: 150))
        button.backgroundColor = UIColor.blueJeansDark
        button.setTitle("Play", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir", size: 40.0)
        button.addTarget(self, action: #selector(playGameTapped), for: .primaryActionTriggered)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var backButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 100, y: 0, width: 350, height: 150))
        button.backgroundColor = UIColor.bitterSweetDark
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir", size: 40.0)
        button.addTarget(self, action: #selector(backButtonTapped), for: .primaryActionTriggered)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var randomPictureButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 200, y: 200, width: 350, height: 150))
        button.backgroundColor = UIColor.lavendarLight
        button.setTitle("Random Picture", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir", size: 40.0)
        button.addTarget(self, action: #selector(getAndSetRandomImage), for: .primaryActionTriggered)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    var loadPictureButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 200, y: 200, width: 350, height: 150))
        button.backgroundColor = UIColor.aquaDark
        button.setTitle("Load Picture", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir", size: 40.0)
        button.addTarget(self, action: #selector(loadPicture), for: .primaryActionTriggered)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    var gameImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "Happy")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    // just found out about loadView() method...  i believe it gets triggered before viewDidLoad....
    override func loadView() {
        super.loadView()
        createGameImages()
        setUpViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(GameImageCell.self, forCellWithReuseIdentifier: GameImageCell.identifier)
        self.collectionView.alwaysBounceHorizontal = true
        self.collectionView.backgroundColor = .clear


    }
    
    // this method is called whenever the focused item changes with tvOS
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        let button = context.nextFocusedView
        button?.layer.shadowOffset = CGSize(width: 0, height: 10)
        button?.layer.shadowOpacity = 0.6
        button?.layer.shadowRadius = 15
        button?.layer.shadowColor = UIColor.black.cgColor
        context.previouslyFocusedView?.layer.shadowOpacity = 0
    }
    
    func createGameImages()
    {
        imageStrings = ["ClownFish", "Test", "Happy", "Smile"]
        for word in imageStrings
        {
            let newImage = UIImage(named: word)
            gameImages.append(newImage)
        }
    }
    
    @objc func backButtonTapped()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func playGameTapped()
    {
        delegate?.playGame(image: gameImageView.image)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func loadPicture()
    {
        // ToDo: Load pictures from camera roll and save to cloudkit...
        print("loadPicture tapped... ToDo!!!")
    
    }
    @objc func getAndSetRandomImage()
    {
        if gameImages.count > 0
        {
            let rand = Int.random(in: 0..<gameImages.count)
            gameImageView.image = gameImages[rand]
        }
    }
    
    func setUpViews()
    {
        // bottom views
        self.view.addSubview(backButton)
        self.view.addSubview(playGameButton)
        self.view.addSubview(randomPictureButton)
        self.view.addSubview(loadPictureButton)
        let bottomStack1 = UIStackView(arrangedSubviews: [backButton, randomPictureButton, playGameButton])
        bottomStack1.axis = .horizontal
        bottomStack1.distribution = .fillEqually
        bottomStack1.alignment = .fill
        bottomStack1.spacing = 10
        bottomStack1.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomStack1)
        let bottomStack2 = UIStackView(arrangedSubviews: [randomPictureButton, loadPictureButton])
        bottomStack2.axis = .horizontal
        bottomStack2.distribution = .fillEqually
        bottomStack2.alignment = .fill
        bottomStack2.spacing = 10
        bottomStack2.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomStack2)
        let bottomStackMain = UIStackView(arrangedSubviews: [bottomStack2, bottomStack1])
        bottomStackMain.axis = .vertical
        bottomStackMain.distribution = .fillEqually
        bottomStackMain.alignment = .fill
        bottomStackMain.spacing = 10
        bottomStackMain.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomStackMain)
        
        
        bottomStackMain.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        
        // change the bottom layout for tvOS vs iOS
        if UIScreen.main.bounds.width < 800
        {
            bottomStackMain.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
            bottomStackMain.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        }
        else
        {
            bottomStackMain.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            bottomStackMain.widthAnchor.constraint(equalToConstant: min(width, 800)).isActive = true
        }
        
        bottomStackMain.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        // top view
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "Avenir", size: 35)
        label.text = "Choose Image"
        label.textAlignment = .center
        self.view.addSubview(label)
        
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        label.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        label.heightAnchor.constraint(equalToConstant: 45).isActive = true
        

        self.view.addSubview(collectionView)
        
        collectionView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: height / 6).isActive = true
        
        // add middle imageView...
        self.view.addSubview(gameImageView)
        
        getAndSetRandomImage()

        
        // make gameImageview, fill the space between gameImageView and bottom stack. first figure out if that space is taller or wider, because game imageView needs to be a square
        let vert = UIScreen.main.bounds.height / 2 - 40
        let horiz = UIScreen.main.bounds.width - 40
        let imageWidth = min(vert, horiz)
        print(imageWidth)
        
        gameImageView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20).isActive = true
        gameImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        gameImageView.widthAnchor.constraint(equalToConstant: imageWidth).isActive = true
        gameImageView.heightAnchor.constraint(equalToConstant: imageWidth).isActive = true
        
    }
    


}

extension ChoosePictureVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.gameImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameImageCell.identifier, for: indexPath) as! GameImageCell
        let image = self.gameImages[indexPath.item]
        cell.image = image
        
        return cell
    }
}

extension ChoosePictureVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell: GameImageCell = collectionView.cellForItem(at: indexPath) as? GameImageCell else { return }
        
        let selectedImage = cell.image
        
        self.gameImageView.image = selectedImage
        print("tapped item at index \(indexPath.item)")
        
    }
}

extension ChoosePictureVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) //.zero
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


