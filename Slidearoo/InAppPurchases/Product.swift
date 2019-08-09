//
//  Product.swift
//  Fifteen
//
//  Created by Christopher Walter on 8/8/19.
//  Copyright © 2019 AssistStat. All rights reserved.
//

import UIKit
import StoreKit

// this is the local class of Product. Now it is used only for the in app purchase of My Photos... Might find other uses later..
class Product {
    var title: String = ""
    var about: String = ""
    var isPurchased: Bool = false
    var productID = ""
    var price: NSDecimalNumber
    var theProduct: SKProduct?
    
    init(title: String, purchased: Bool, about: String, productID: String, price: NSDecimalNumber, theProduct: SKProduct?) {
        self.title = title
        self.isPurchased = purchased
        self.about = about
        self.productID = productID
        self.price = price
        self.theProduct = theProduct
        
    }
}
