//
//  SlidearooProducts.swift
//  Slidearoo
//
//  Created by Christopher Walter on 8/6/19.
//  Copyright © 2019 AssistStat. All rights reserved.
//


import Foundation

public struct SlidearooProducts {
    
    public static let myPhotos = "com.AssistStat.Fifteen.MyPhotos"
//    public static let foodDeck = "com.AssistStat.OutOfTime.Food"
//    public static let philadelphiaDeck = "com.AssistStat.OutOfTime.Philadelphia"
//    public static let abcDeck = "com.AssistStat.OutOfTime.ABCs"
    
    //    fileprivate static let productIdentifiers: Set<ProductIdentifier> = [OutOfTimeProducts.animalDeck, OutOfTimeProducts.foodDeck]
    public static let productIdentifiers: Set<ProductIdentifier> = [myPhotos]
    
    
    public static let store = IAPHelper(productIds: SlidearooProducts.productIdentifiers)
}

//func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
//    return productIdentifier.components(separatedBy: ".").last
//}
