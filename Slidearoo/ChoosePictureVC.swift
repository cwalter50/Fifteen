//
//  ChoosePictureVC.swift
//  Fifteen
//
//  Created by Christopher Walter on 7/26/19.
//  Copyright © 2019 AssistStat. All rights reserved.
//

import UIKit
import StoreKit

protocol ChoosePictureVCDelegate {
    func playGame(image: UIImage?, gameSettings: GameSettings)
}

class ChoosePictureVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: Properties
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    var myPhotosProduct: Product?
//    var product: SKProduct?

    
    var imageStrings: [String] = [String]()
    var gameImages: [UIImage?] = [UIImage?]()
    
    var gameSettings: GameSettings = GameSettings() // use default initializer for gameSettings which is 4 x 4 medium
    
    var delegate: ChoosePictureVCDelegate?
    
    var picker = UIImagePickerController()
    
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
        button.titleLabel?.font = UIFont(name: "Avenir", size: 30.0)
        button.addTarget(self, action: #selector(getAndSetRandomImage), for: .primaryActionTriggered)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    var loadPictureButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 200, y: 200, width: 350, height: 150))
        button.backgroundColor = UIColor.aquaDark
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.lineBreakMode = .byWordWrapping // this is used for Buy label added to button
        button.titleLabel?.textAlignment = NSTextAlignment.center
        button.setTitle("Load Photo", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir", size: 30.0)
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
        
        picker.delegate = self
        //        picker.allowsEditing = true
        
        // this will determine if notify user after Product has been purchased
        NotificationCenter.default.addObserver(self, selector: #selector(handlePurchaseNotification(_:)), name: NSNotification.Name(IAPHelper.IAPHelperPurchaseNotification), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadProducts()
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
        imageStrings = ["Night","ClownFish", "Test", "AppIconiOSOriginal","Happy", "Smile", "OutOfTimeLogo3"]
        for word in imageStrings
        {
            let newImage = UIImage(named: word)
            gameImages.append(newImage)
        }
    }
    
    @objc func backButtonTapped()
    {
        gameSettings.isWithImage = false
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func playGameTapped()
    {
        gameSettings.isWithImage = true
        gameSettings.image = gameImageView.image
        delegate?.playGame(image: gameImageView.image, gameSettings: gameSettings)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func loadPicture()
    {
        // ToDo: Load pictures from camera roll and save to cloudkit...
        print("loadPicture tapped... ToDo!!!")
        if let photosProduct = myPhotosProduct
        {
            if photosProduct.isPurchased
            {
                cameraButtonTapped()
            }
            else
            {
                // handle in app purchase for product
                buyMyPhotosAlert()
            }
        }

    
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
        setupLoadPictureButton()
        let bottomStack1 = UIStackView(arrangedSubviews: [backButton, randomPictureButton, playGameButton])
        bottomStack1.axis = .horizontal
        bottomStack1.distribution = .fillEqually
        bottomStack1.alignment = .fill
        bottomStack1.spacing = 5
        bottomStack1.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomStack1)
        let bottomStack2 = UIStackView(arrangedSubviews: [randomPictureButton, loadPictureButton])
        bottomStack2.axis = .horizontal
        bottomStack2.distribution = .fillEqually
        bottomStack2.alignment = .fill
        bottomStack2.spacing = 5
        bottomStack2.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomStack2)
        let bottomStackMain = UIStackView(arrangedSubviews: [bottomStack2, bottomStack1])
        bottomStackMain.axis = .vertical
        bottomStackMain.distribution = .fillEqually
        bottomStackMain.alignment = .fill
        bottomStackMain.spacing = 5
        bottomStackMain.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomStackMain)
        
        
        bottomStackMain.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -10).isActive = true
        
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
        
        bottomStackMain.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
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
        
        gameImageView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10).isActive = true
        gameImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        gameImageView.widthAnchor.constraint(equalToConstant: imageWidth).isActive = true
        gameImageView.heightAnchor.constraint(equalToConstant: imageWidth).isActive = true
        
    }
    
    // MARK: IAP Methods and helpers
    
    func loadProducts()
    {
        // try loading from UserDefaults first... It will be saved there if the Product has already been purchased
        for productID in SlidearooProducts.productIdentifiers {
            let purchased = UserDefaults.standard.bool(forKey: productID)
            if purchased {
                myPhotosProduct = Product(title: "MyPhotos", purchased: true, about: "Buying this feature will allow you to use photos from your Photo Library and Camera while playing the game", productID: "com.AssistStat.Fifteen.MyPhotos", price: 0, theProduct: nil)
            }
        }
    // check loading from App Store next if the product does not exist in UserDefaults.. this will set theProduct property on product which is an SK Product...
        SlidearooProducts.store.requestProducts{success, products in
            if success {
                if let foundProducts = products {
                    let products = foundProducts
                    
                    for product in products // there should only be one photo...
                    {
                        if product.localizedTitle == "My Photos"
                        {
                            //  self.product = product // this may be unnecessessary..
                            
                            self.myPhotosProduct = Product(title: "MyPhotos", purchased: false, about: "Buying this feature will allow you to use photos from your Photo Library and Camera while playing the game", productID: "com.AssistStat.Fifteen.MyPhotos", price: product.price, theProduct: product)
                            // check if product is purchased....
                            if SlidearooProducts.store.isProductPurchased(product.productIdentifier)
                            {
                                self.myPhotosProduct?.isPurchased = true
                            }
                            
                            DispatchQueue.main.async(execute: {
                                self.setupLoadPictureButton()
                            })
                            
                            break
                        }
                    }
                }
            }
                
            else {
                print("found no products on App Store")
            }
        }
        
    }
    let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.formatterBehavior = .behavior10_4
        formatter.numberStyle = .currency
        
        return formatter
    }()
    
    
    
    func setupLoadPictureButton()
    {
        // myPhotosProduct is filled in loadProduct()...
        print(1)
        if let photoProduct = myPhotosProduct
        {
            print(2)
            if photoProduct.isPurchased == true
            {
                print(3)
                // set title to Load Photo...
                loadPictureButton.setAttributedTitle(nil, for: .normal)
                loadPictureButton.setTitle("Load Photo", for: .normal)

            }
            else if IAPHelper.canMakePayments()
            {
                // set title to contain Buy and the price...
                var priceFormatted = priceFormatter.string(from: photoProduct.price) ?? "NA"
                if photoProduct.price == 0 {
                    priceFormatted = "FREE"
                }
                loadPictureButton.setAttributedTitle(getAttributedStringForIAP(message: "Load Photo\nBuy \(priceFormatted)" as NSString), for: .normal)
            }
            else
            {
                loadPictureButton.setAttributedTitle(getAttributedStringForIAP(message: "Load Photo\nBuy" as NSString), for: .normal)
            }
        }
        
    }
    
    func getAttributedStringForIAP(message: NSString) -> NSAttributedString
    {
        //getting the range to separate the button title strings
        let newlineRange: NSRange = message.range(of: "\n")
        
        //getting both substrings
        var substring1: String = ""
        var substring2: String = ""
        
        if(newlineRange.location != NSNotFound) {
            substring1 = message.substring(to: newlineRange.location)
            substring2 = message.substring(from: newlineRange.location)
        }
        
        //assigning diffrent fonts to both substrings
        let font:UIFont? = UIFont(name: "Avenir", size: 30.0)
//        let attrString = NSMutableAttributedString(
//            string: substring1, attributes: NSDictionary(object: font!, forKey: NSFontAttributeName) as [NSObject : AnyObject])
        let attrString = NSMutableAttributedString(string: substring1, attributes: [NSAttributedString.Key.font: font ?? UIFont.boldSystemFont(ofSize: 20)])
        
        let font1:UIFont? = UIFont(name: "Avenir-Heavy", size: 20.0)
        let attrString1 = NSMutableAttributedString(string: substring2, attributes: [NSAttributedString.Key.font: font1 ?? UIFont.boldSystemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        
        
        //appending both attributed strings
        attrString.append(attrString1)
        
        //assigning the resultant attributed strings to the button
        return attrString
    }
    func buyMyPhotosAlert()
    {
        if let photoProduct = myPhotosProduct
        {
            var priceFormatted = priceFormatter.string(from: photoProduct.price) ?? "NA"
            if photoProduct.price == 0 {
                priceFormatted = "FREE"
            }
            let alert = UIAlertController(title: "Use Your Own Photos", message: photoProduct.about, preferredStyle: .alert)
            let buyAction = UIAlertAction(title: "Buy: \(priceFormatted)", style: .default, handler: {action in
                if IAPHelper.canMakePayments() {
                    if let theProduct = photoProduct.theProduct {
                        SlidearooProducts.store.buyProduct(theProduct)
                    }
                    else {
                        self.errorAlert(message: "Your device cannot find this product on the App Store. Please try again another time.")
                    }
                }
                else {
                    self.errorAlert(message: "Your account is not allowed or set up to make payments")
                }
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            alert.addAction(buyAction)
            present(alert, animated: true, completion: nil)
        }
        else
        {
            errorAlert(message: "Your device cannot find this product on the App Store. Please try again another time.")
        }
    }
    
    func errorAlert(message: String)
    {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    
    // this is called after a product gets purchased.  Its called from IAPHelper and a notification
    @objc func handlePurchaseNotification(_ notification: Notification) {
        //        guard let productID = notification.object as? String else { return }

        // change deck is purchased to true, and change button to play
        //        self.purchaseNotificationAlert(notification: notification)
        print("Should update myPhotosProduct with HandlePurchaseNotification")
        myPhotosProduct?.isPurchased = true
        loadPictureButton.setTitle("Load Photo", for: .normal)
        setupLoadPictureButton()
//        DispatchQueue.main.async(execute: {
//            self.setupLoadPictureButton()
//        })
    }
    
    // MARK: CollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell: GameImageCell = collectionView.cellForItem(at: indexPath) as? GameImageCell else { return }
        
        let selectedImage = cell.image
        
        self.gameImageView.image = selectedImage
        print("tapped item at index \(indexPath.item)")
        
    }
    
    // MARK: CollectionviewDelegateFlowLayout
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
    
    // MARK: CollectionViewDataSource
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
    
    
    // MARK: ImagePicker
    func cameraButtonTapped() {
        
        let sheet = UIAlertController(title: "Select where to get image from", message: nil, preferredStyle: .alert)
        let libraryAction = UIAlertAction(title: "PHOTO LIBRARY", style: .default) { (action) -> Void in
            self.picker.sourceType = .photoLibrary
            self.picker.delegate = self
            self.picker.modalPresentationStyle = .popover
            self.picker.allowsEditing = true
            
            self.present(self.picker, animated: true, completion: nil)
        }
        let cameraAction = UIAlertAction(title: "CAMERA", style: .default) { (action) -> Void in
            if UIImagePickerController.availableCaptureModes(for: .rear) != nil
            {
                self.picker.sourceType = .camera
                self.picker.allowsEditing = true
                self.picker.cameraCaptureMode = .photo
                self.picker.modalPresentationStyle = .fullScreen
                self.picker.delegate = self
                
                self.present(self.picker, animated: true, completion: nil)
            }
            else{
                self.noCamera()
            }
        }
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel)
        {(action) -> Void in
        }
        sheet.addAction(libraryAction)
        sheet.addAction(cameraAction)
        sheet.addAction(cancelAction)
        self.present(sheet, animated: true, completion: nil)
    }
    
    // dsiplays alert if device does not have a camera
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if picker.sourceType == .camera
        {
            // get the image the user selected
            if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
            {
                gameImageView.image = pickedImage
            }
        }
        else
        {
            // get the image the user selected
            //            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            //            {
            //                gameImageView.image = pickedImage
            //            }
            if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
            {
                gameImageView.image = pickedImage
            }
        }
        // dismiss imagePickerController
        dismiss(animated: true, completion: nil)
    }
    

    
    

}

